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

    enum Classes:Int {
        case Carre, Triangle, Rond
        
        func neuralNetResponse() -> [Double] {
            switch self {
            case .Carre: return [1.0, 0.0, 0.0]
            case .Triangle: return [0.0, 1.0, 0.0]
            case .Rond: return [0.0, 0.0, 1.0]
            }
        }
    }
    
    @IBOutlet weak var gyroChart: GraphView!
    @IBOutlet weak var acceleroChart: GraphView!

    var movementData = [Classes:[[Double]]]()
    var selectedClass = Classes.Carre
    var isRecording:Bool = false
    var limit:Int = 3600
    var isPredicting:Bool = false
    
    var neuralNet:NeuralNet? = nil
     
    
    
    
    @IBAction func startBtnClicked(_ sender: Any) {
        isRecording = true
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        if let s = Classes(rawValue: index) {
            selectedClass = s
        }
    }
    @IBAction func trainBtnClicked(_ sender: Any) {
        trainNetwork()
    }
    @IBAction func predictBtnClicked(_ sender: Any) {
        self.isPredicting = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let structure = try! NeuralNet.Structure(nodes: [3600,30,3], hiddenActivation: .rectifiedLinear, outputActivation: .rectifiedLinear)
        neuralNet = try! NeuralNet(structure: structure)
        
        movementData[.Carre] = []
        movementData[.Triangle] = []
        movementData[.Rond] = []
        
        var currentData = [Double]()
        
        SocketIOManager.instance.setup()
        SocketIOManager.instance.connect {
        }
        

        // Do any additional setup after loading the view.
        
        SharedToyBox.instance.bolt?.sensorControl.enable(sensors: SensorMask.init(arrayLiteral: .accelerometer,.gyro))
        SharedToyBox.instance.bolt?.sensorControl.interval = 1
        SharedToyBox.instance.bolt?.setStabilization(state: SetStabilization.State.off)
        
        SharedToyBox.instance.bolt?.sensorControl.onDataReady = { data in
            DispatchQueue.main.async {
                if self.isRecording || self.isPredicting {
                    if let acceleration = data.accelerometer?.filteredAcceleration {
                        // PAS BIEN!!!
                        
                        currentData.append(contentsOf: [acceleration.x!, acceleration.y!, acceleration.z!])
                        let dataToDisplay: double3 = [acceleration.x!, acceleration.y!, acceleration.z!]
                        
                        self.acceleroChart.add(dataToDisplay)
                    }
                    
                    if let gyro = data.gyro?.rotationRate {
                        // TOUJOURS PAS BIEN!!!
                        let rotationRate: double3 = [Double(gyro.x!) / 2000.0, Double(gyro.y!) / 2000.0, Double(gyro.z!) / 2000.0]
                        
                    
                        currentData.append(contentsOf: [Double(gyro.x!) / 2000.0, Double(gyro.y!) / 2000.0, Double(gyro.z!) / 2000.0])
                        
                        self.gyroChart.add(rotationRate)
                    }

                    print(currentData.count)
                    //3600 = 3 secondes
                    if currentData.count >= self.limit {
                        SocketIOManager.instance.emit(channel: "save", value: currentData)
                        if self.isRecording {
                            self.isRecording = false
                            self.movementData[self.selectedClass]?.append(currentData)
                            currentData = []
                        }
                        if self.isPredicting {
                            self.isPredicting = false
                            let floatInput = currentData.map{ Float($0)}
                            let prediction = try! self.neuralNet?.infer(floatInput)
                            print(prediction)
                            currentData = []
                        }
                    }
                }
            }
        }
        
    }
    
    func trainNetwork() {
        
        /// TRAINING
        
        for _ in 0...80 {
            if let selectedClass = movementData.randomElement(),
                let input = selectedClass.value.randomElement() {
                
                let expectedResponse = selectedClass.key.neuralNetResponse()
                let floatInput = input.map{ Float($0)}
                let floatRes = expectedResponse.map{ Float($0)}
                
                try! neuralNet?.infer(floatInput)
                try! neuralNet?.backpropagate(floatRes)
            }
        }
        
        /// VALIDATION
        
        for k in movementData.keys {
            print("Inference for \(k)")
            let values = movementData[k]!
            
            for v in values {
                let floatInput = v.map{ Float($0)}
                let prediction = try! neuralNet?.infer(floatInput)
                print(prediction)
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
