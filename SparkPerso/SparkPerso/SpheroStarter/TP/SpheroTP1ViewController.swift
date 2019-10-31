//
//  SpheroTP1ViewController.swift
//  SparkPerso
//
//  Created by  on 18/10/2019.
//  Copyright © 2019 AlbanPerli. All rights reserved.
//

import UIKit

class SpheroTP1ViewController: UIViewController {
    
    @IBOutlet weak var logView: UITextView!
    
    var spheroMovementManager:SpheroMovementManager? = nil
    var sequence:[GenericMoveType]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spheroMovementManager = SpheroMovementManager(sequence: [])
        
        SocketIOManager.instance.setup()
        SocketIOManager.instance.connect {
            print("tttttttttttttttssg")
            SocketIOManager.instance.on(channel: "sphero-move") { (received:String?) in
                if let str = received {
                    self.manageCommand(cmd: str)
                }
                else {
                    print("noooo")
                }
            }
        }
    }
      
    
    func manageCommand(cmd:String) {
        switch cmd {
            case let t where t.contains("FRONT"):
                var components = t.split(separator: ":")
                components = Array(components.dropFirst())
                
                let heading = Double(components[0])!
                let durationInSecond = Double(components[1])!
                let speed = Float(components[2])!
                
                self.spheroMovementManager?.sequence.append(SpheroMove(heading: heading, durationInSecond: durationInSecond, speed: speed))
                break
            case "LEFT":
                self.spheroMovementManager?.sequence.append(SpheroMove(heading: 90, durationInSecond: 0, speed: 0))
                break
            case "RIGHT":
                self.spheroMovementManager?.sequence.append(SpheroMove(heading: 270, durationInSecond: 0, speed: 0))
                break
            case "STOP":
                spheroMovementManager?.redAlert()
                break
            default:
                break;
        }
        spheroMovementManager?.playSequence()
    }
    

    @IBAction func stop(_ sender: Any) {
        print("stop");
        spheroMovementManager?.redAlert()
    }
    
    @IBAction func startButton(_ sender: Any) {
        print("start");
        spheroMovementManager?.sequence.append(StopMoveType())
        spheroMovementManager?.playSequence()
    }
    
    @IBAction func resetLogClicked(_ sender: Any) {
        logView.text = ""
        spheroMovementManager?.clear()
    }
    
    @IBAction func rotateLeftButtonClicked(_ sender: Any) {
            self.spheroMovementManager?.sequence.append(SpheroMove(heading: 90, durationInSecond: 0, speed: 0))
            self.printSequence()
    }
    
    @IBAction func rotateRightButtonClicked(_ sender: Any) {
        self.spheroMovementManager?.sequence.append(SpheroMove(heading: 270, durationInSecond: 0, speed: 0))
        self.printSequence()
    }
    
    @IBAction func frontButtonClicked(_ sender: Any) {
        self.promptForAnswerWithHeading { (duration, speed, heading) in
        self.spheroMovementManager?.sequence.append(SpheroMove(heading: Double(heading), durationInSecond: duration, speed: speed))
            self.printSequence()
        }
    }
    
    func printSequence() {
        print(spheroMovementManager?.printDescription() ?? " ")
        logView.text = spheroMovementManager?.printDescription()
    }

}
