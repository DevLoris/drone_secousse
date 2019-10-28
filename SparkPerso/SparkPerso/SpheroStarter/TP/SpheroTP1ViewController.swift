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
