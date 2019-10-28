//
//  TP1ViewController.swift
//  SparkPerso
//
//  Created by  on 17/10/2019.
//  Copyright © 2019 AlbanPerli. All rights reserved.
//

import UIKit
import DJISDK

class TP1ViewController: UIViewController {
    @IBOutlet weak var logView: UITextView!
    
    var droneMovementManager:DroneMovementManager? = nil
    var sequence:[GenericMoveType]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        droneMovementManager = DroneMovementManager(sequence: [])
    }
      

    @IBAction func stop(_ sender: Any) {
        print("stop");
        droneMovementManager?.redAlert()
    }
    
    @IBAction func startButton(_ sender: Any) {
        print("start");
        droneMovementManager?.sequence.append(StopMoveType())
        droneMovementManager?.playSequence()
    }
    
    @IBAction func resetLogClicked(_ sender: Any) {
        logView.text = ""
        droneMovementManager?.clear()
    }
    
    @IBAction func rotateLeftButtonClicked(_ sender: Any) {
        self.promptForAnswer { (duration, speed) in
            self.droneMovementManager?.sequence.append(LeftRotationType(durationInSecond: duration, speed: speed))
            self.printSequence()
        }
    }
    
    @IBAction func rotateRightButtonClicked(_ sender: Any) {
        self.promptForAnswer { (duration, speed) in
            self.droneMovementManager?.sequence.append(RightRotationType(durationInSecond: duration, speed: speed))
            self.printSequence()
        }
    }
    
    @IBAction func frontButtonClicked(_ sender: Any) {
        self.promptForAnswer { (duration, speed) in
            self.droneMovementManager?.sequence.append(FrontMoveType(durationInSecond: duration, speed: speed))
            self.printSequence()
        }
    } 
    
    func printSequence() {
        print(droneMovementManager?.printDescription() ?? " ")
        logView.text = droneMovementManager?.printDescription()
    }
     
}
