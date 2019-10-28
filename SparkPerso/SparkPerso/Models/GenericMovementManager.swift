//
//  GenericMovementManager.swift
//  SparkPerso
//
//  Created by  on 18/10/2019.
//  Copyright © 2019 AlbanPerli. All rights reserved.
//

import Foundation

class GenericMovementManager {
    var sequence:[GenericMoveType]
    var stopAll = false
    
    
    init(sequence:[GenericMoveType]) {
        self.sequence = sequence 
    }
    
    func redAlert() {
        self.sequence = []
        self.stopAll = true
        self.doAction(action: StopMoveType())
        print("alert")
    }
    
    func clear() {
        self.sequence = []
        self.stopAll = false
    }
 
    func playSequence() {
        if let first = sequence.first, !stopAll {
            self.doAction(action: first);
            DelayHelper.delay(first.durationInSecond) {
                if self.sequence.count > 0 {
                    self.sequence.removeFirst()
                    self.playSequence()
                }
            }
        }
    }
    
    func doAction(action:GenericMoveType) {
        print(action.description);
    }
    
    func printDescription() -> String {
        var string = ""
        self.sequence.forEach({ (type) in
            string += "\(type.description )\n"
        })
        return string
    }
}
