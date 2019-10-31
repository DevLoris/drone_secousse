//
//  ViewController.swift
//  SparkPerso
//
//  Created by AL on 14/01/2018.
//  Copyright © 2018 AlbanPerli. All rights reserved.
//

import UIKit
import DJISDK
import SocketIO
 

class ConnectionViewController: UIViewController {
    
    @IBOutlet weak var connectionStateSpheroLabel: UILabel!
    @IBOutlet weak var connectionStateLabel: UILabel!
    let SSID = ""
    var isConnected = false
    @IBOutlet weak var connectionStateSocketLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       SocketIOManager.instance.setup()
       SocketIOManager.instance.connect {}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        DJISDKManager.keyManager()?.stopAllListening(ofListeners: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func connectionButtonClicked(_ sender: UIButton) {
        trySparkConnection()
    }
    
    // SPHERO CONNECTION
    @IBAction func connectionSpheroButtonClicked(_ sender: Any) {
        if(!isConnected){
            let balls = ["SB-C7A8"]
            
            balls.map { (value) in
                SocketIOManager.instance.emit(channel: "sphero-init", value: value)
            }
            
            SocketIOManager.instance.on(channel: "sphero-matrix") { (data:[Any]) in
                
                if
                    data.count >= 2,
                    let name = data.first,
                    let str = name as? String {
                        SharedToyBox.instance.bolts.map { k in
                           if
                               k.getName() == str {
                                print("ball founded")
                            SpheroMatrixUtils.setMatrix(data.last as! NSArray, to: k)
                           }
                       }
                }
                print(data)
                
            }
            
            SharedToyBox.instance.searchForBoltsNamed(balls) { err in
                if err == nil {
 
                        self.connectionStateSpheroLabel.text = "Connected"
                        self.isConnected = true
                }
            }
        } else {
            self.connectionStateSpheroLabel.text = "Disconnected"
            self.isConnected = false
            SharedToyBox.instance.disconnect();
        }
    }
    
    @IBAction func connectionSocketButtonClicked(_ sender: Any) { 
        SocketIOManager.instance.setup()
        SocketIOManager.instance.connect {
            print("tttttttttttttttssg")
            SocketIOManager.instance.on(channel: "test") { (received:String?) in
                if let str = received {
                    print(str)
                }
                else {
                    print("noooo")
                }
            }
        }
    }
}


// SPARK CONNECTION
extension ConnectionViewController { 
    func trySparkConnection() {
        
        guard let connectedKey = DJIProductKey(param: DJIParamConnection) else {
            NSLog("Error creating the connectedKey")
            return;
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            DJISDKManager.keyManager()?.startListeningForChanges(on: connectedKey, withListener: self, andUpdate: { (oldValue: DJIKeyedValue?, newValue : DJIKeyedValue?) in
                if let newVal = newValue {
                    if newVal.boolValue {
                         DispatchQueue.main.async {
                            self.productConnected()
                        }
                    }
                }
            })
            DJISDKManager.keyManager()?.getValueFor(connectedKey, withCompletion: { (value:DJIKeyedValue?, error:Error?) in
                if let unwrappedValue = value {
                    if unwrappedValue.boolValue {
                        // UI goes on MT.
                        DispatchQueue.main.async {
                            self.productConnected()
                        }
                    }
                }
            })
        }
    }
    
   
    
    func productConnected() {
        guard let newProduct = DJISDKManager.product() else {
            NSLog("Product is connected but DJISDKManager.product is nil -> something is wrong")
            return;
        }
     
        if let model = newProduct.model {
            self.connectionStateLabel.text = "\(model) is connected \n"
            Spark.instance.airCraft = DJISDKManager.product() as? DJIAircraft
            
        }
        
        //Updates the product's firmware version - COMING SOON
        newProduct.getFirmwarePackageVersion{ (version:String?, error:Error?) -> Void in
            
            if let _ = error {
                self.connectionStateLabel.text = self.connectionStateLabel.text! + "Firmware Package Version: \(version ?? "Unknown")"
            }else{
                
            }
            
            print("Firmware package version is: \(version ?? "Unknown")")
        }
        
    }
    
    func productDisconnected() {
        self.connectionStateLabel.text = "Disconnected"
        print("Disconnected")
    }
}

