//
//  SpheroMovementManager.swift
//  SparkPerso
//
//  Created by  on 18/10/2019.
//  Copyright © 2019 AlbanPerli. All rights reserved.
//

import Foundation

class SpheroMovementManager:GenericMovementManager {
    override func doAction(action:GenericMoveType) {
        print("SPHERO");
        print(action.description);
        
        communicateWithSDK(action: action)
    }
    
    
    func communicateWithSDK(action:GenericMoveType) {
        switch action {
            case is StopMoveType:
                SharedToyBox.instance.bolts.map{ $0.roll(heading: 0, speed: 0) }
                break;
            case is SpheroMove:
                SharedToyBox.instance.bolts.map{ $0.roll(heading: action.heading, speed: Double(action.speed*255)) }
                break;
            default:
                break;
        }
    }
}
