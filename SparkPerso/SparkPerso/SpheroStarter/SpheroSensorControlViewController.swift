//
//  SensorControlViewController.swift
//  SparkPerso
//
//  Created by AL on 01/09/2019.
//  Copyright © 2019 AlbanPerli. All rights reserved.
//

import UIKit
import simd

class SpheroSensorControlViewController: UIViewController {

    @IBOutlet weak var gyroChart: GraphView!
    @IBOutlet weak var acceleroChart: GraphView!
     
    
    class Logger {
        var started:Bool = false
        var limit:Int = 3600
        var movementData: [Double] = []
    }
    
    var l:Logger? = nil
    
    @IBAction func buttonClicked(_ sender: Any) {
        l?.started = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()  
        
        SocketIOManager.instance.setup()
        SocketIOManager.instance.connect {
        }
        
        l = Logger()

        // Do any additional setup after loading the view.
        
        SharedToyBox.instance.bolt?.sensorControl.enable(sensors: SensorMask.init(arrayLiteral: .accelerometer,.gyro))
        SharedToyBox.instance.bolt?.sensorControl.interval = 1
        SharedToyBox.instance.bolt?.setStabilization(state: SetStabilization.State.off)
        
        SharedToyBox.instance.bolt?.sensorControl.onDataReady = { data in
            DispatchQueue.main.async {
                if let acceleration = data.accelerometer?.filteredAcceleration {
                    // PAS BIEN!!!
                    
                    if let logger = self.l, logger.started {
                        logger.movementData.append(contentsOf: [acceleration.x!, acceleration.y!, acceleration.z!])
                    }
                    let dataToDisplay: double3 = [acceleration.x!, acceleration.y!, acceleration.z!]
                    
                    self.acceleroChart.add(dataToDisplay)
                }
                
                if let gyro = data.gyro?.rotationRate {
                    // TOUJOURS PAS BIEN!!!
                    let rotationRate: double3 = [Double(gyro.x!) / 2000.0, Double(gyro.y!) / 2000.0, Double(gyro.z!) / 2000.0]
                    print(rotationRate)
                    
                    
                    if let logger = self.l, logger.started {
                        logger.movementData.append(contentsOf: [Double(gyro.x!) / 2000.0, Double(gyro.y!) / 2000.0, Double(gyro.z!) / 2000.0])
                    }
                    
                    self.gyroChart.add(rotationRate)
                }
                
                //3600 = 3 secondes
                if let logger = self.l, logger.started , logger.movementData.count >= logger.limit {
                    SocketIOManager.instance.emit(channel: "save-movement", value: logger.movementData) 
                    logger.movementData = []
                }
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        SharedToyBox.instance.bolt?.sensorControl.disable()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
