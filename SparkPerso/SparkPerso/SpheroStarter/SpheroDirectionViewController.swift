//
//  SpheroDirectionViewController.swift
//  SparkPerso
//
//  Created by AL on 01/09/2019.
//  Copyright © 2019 AlbanPerli. All rights reserved.
//

import UIKit

class SpheroDirectionViewController: UIViewController {

    
    var currentSpeed:Double = 0 {
        didSet{
            displayCurrentState()
        }
    }
    var currentHeading:Double = 0 {
        didSet{
            displayCurrentState()
        }
    }
    
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var collisionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var boltCollision = [Bool]()
        
        SharedToyBox.instance.bolts.map {
            $0.setStabilization(state: SetStabilization.State.on)
            $0.setCollisionDetection(configuration: .enabled)
            $0.onCollisionDetected = { collisionData in
                
                DispatchQueue.main.sync {
                    self.collisionLabel.text = "Aïe!!!"
                    if boltCollision.count == 2 {
                        print("Collision")
                    }
                    else {
                        DelayHelper.delay(0.5) {
                            boltCollision = []
                        }
                    }
                    boltCollision.append(true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.collisionLabel.text = ""
                    }
                }
                
            }
        }
    }
    
    func displayCurrentState() {
        stateLabel.text = "Current Speed: \(currentSpeed.rounded())\nCurrent Heading: \(currentHeading.rounded())"
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        currentSpeed = Double(sender.value)
    }
    
    @IBAction func headingValueChanged(_ sender: UISlider) {
        currentHeading = Double(sender.value)
        SharedToyBox.instance.bolts.map{ $0.stopRoll(heading: currentHeading) }
        //SharedToyBox.instance.bolt?.stopRoll(heading: currentHeading)
    }
    
    @IBAction func frontClicked(_ sender: Any) {
        SharedToyBox.instance.bolts.map{ $0.roll(heading: currentHeading, speed: currentSpeed) }
//        SharedToyBox.instance.bolt?.roll(heading: currentHeading, speed: currentSpeed)
    }
    
    @IBAction func leftClicked(_ sender: Any) {
        currentHeading += 30.0
        SharedToyBox.instance.bolts.map{ $0.roll(heading: currentHeading, speed: currentSpeed) }
//        SharedToyBox.instance.bolt?.roll(heading: currentHeading, speed: currentSpeed)
    }
    
    @IBAction func rightClicked(_ sender: Any) {
        currentHeading -= 30.0
        SharedToyBox.instance.bolts.map{ $0.roll(heading: currentHeading, speed: currentSpeed) }
//        SharedToyBox.instance.bolt?.roll(heading: currentHeading, speed: currentSpeed)
    }
    
    @IBAction func backClicked(_ sender: Any) {
        SharedToyBox.instance.bolts.map{ $0.roll(heading: currentHeading, speed: currentHeading, rollType: .roll, direction: .reverse) }
//         SharedToyBox.instance.bolt?.roll(heading: currentHeading, speed: currentHeading, rollType: .roll, direction: .reverse)
    }
    
    @IBAction func stopClicked(_ sender: Any) {
        SharedToyBox.instance.bolts.map{ $0.stopRoll(heading: currentHeading) }
//        SharedToyBox.instance.bolt?.stopRoll(heading: currentHeading)
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
