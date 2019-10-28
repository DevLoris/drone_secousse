//
//  DroneMovementManager.swift
//  SparkPerso
//
//  Created by  on 18/10/2019.
//  Copyright © 2019 AlbanPerli. All rights reserved.
//

import Foundation
import DJISDK

class DroneMovementManager:GenericMovementManager {
    
    override init(sequence:[GenericMoveType]) {
        super.init(sequence: sequence)
        //pour pas que ca continue à l'infini
        self.sequence.append(StopMoveType())
    }
    
    override func doAction(action:GenericMoveType) {
        print("DRONE");
        print(action.description);
        
        communicateWithSDK(action: action)
    }
    
    func communicateWithSDK(action:GenericMoveType) {
        if let mySpark = DJISDKManager.product() as? DJIAircraft {
            switch action {
                case is StopMoveType:
                    setRemoteController(mySpark: mySpark, elevation: 0, rotation: 0, leftRight: 0, forwardBackward: 0)
                    break;
                case is FrontMoveType:
                    setRemoteController(mySpark: mySpark, elevation: 0, rotation: 0, leftRight: 0, forwardBackward: action.speed)
                    break;
                case is RightRotationType:
                    setRemoteController(mySpark: mySpark, elevation: 0, rotation: action.speed, leftRight: 0, forwardBackward: 0)
                    break;
                case is LeftRotationType:
                    setRemoteController(mySpark: mySpark, elevation: 0, rotation: -action.speed, leftRight: 0, forwardBackward: 0)
                    break;
                case is ComplexeMoveType:
                    if let complexe = action as? ComplexeMoveType {
                        setRemoteController(mySpark: mySpark, elevation: complexe.elevation, rotation: complexe.rotation, leftRight: complexe.leftRight, forwardBackward: complexe.forwardBackward)
                    }
                    break;
                default:
                    break;
            }
        }
    }
    
    func setRemoteController(mySpark:DJIAircraft, elevation:Float, rotation:Float, leftRight:Float, forwardBackward:Float) {
        mySpark.mobileRemoteController?.leftStickVertical = elevation
        mySpark.mobileRemoteController?.leftStickHorizontal = rotation
        mySpark.mobileRemoteController?.rightStickHorizontal = leftRight
        mySpark.mobileRemoteController?.rightStickVertical = forwardBackward
    }
}
