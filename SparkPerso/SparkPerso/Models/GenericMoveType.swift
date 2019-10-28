//
//  BasicMove.swift
//  SparkPerso
//
//  Created by  on 18/10/2019.
//  Copyright © 2019 AlbanPerli. All rights reserved.
//

import Foundation

class GenericMoveType {
    var durationInSecond:Double
    var speed:Float
    var heading:Double = 0
    var direction:Direction
    var description:String {
        get {
            return "Play \(direction) during \(durationInSecond)s at \(speed) speed"
        }
    }
    
    enum Direction {
        case front, back, rotateLeft, rotateRight, up, down,  translateLeft, translateRight, stop, other
    }
    
    init(durationInSecond:Double, speed:Float, direction:Direction) {
        self.durationInSecond = durationInSecond
        self.speed = speed
        self.direction = direction
    }
}

class SpheroMove:GenericMoveType {
    init(heading:Double, durationInSecond: Double, speed: Float) {
        super.init(durationInSecond: durationInSecond, speed: speed, direction: Direction.other)
        self.heading = heading
    }
}

class FrontMoveType:GenericMoveType {
    init(durationInSecond: Double, speed: Float) {
        super.init(durationInSecond: durationInSecond, speed: speed, direction: Direction.front)
    }
}

class StopMoveType:GenericMoveType {
    init() {
        super.init(durationInSecond: 0, speed: 0, direction: Direction.stop)
    }
}

class RightRotationType:GenericMoveType {
    init() {
        super.init(durationInSecond: 1, speed: 1, direction: Direction.rotateRight)
    }
    init(speed: Float) {
        super.init(durationInSecond: 1, speed: speed, direction: Direction.rotateRight)
    }
    init(durationInSecond: Double, speed: Float) {
        super.init(durationInSecond: durationInSecond, speed: speed, direction: Direction.rotateRight)
    }
}

class LeftRotationType:GenericMoveType {
    init() {
        super.init(durationInSecond: 1, speed: 1, direction: Direction.rotateLeft)
    }
    init(speed: Float) {
        super.init(durationInSecond: 1, speed: speed, direction: Direction.rotateLeft)
    }
    init(durationInSecond: Double, speed: Float) {
        super.init(durationInSecond: durationInSecond, speed: speed, direction: Direction.rotateLeft)
    }
}

class ComplexeMoveType: GenericMoveType {
    var elevation:Float = 0
    var rotation:Float = 0
    var leftRight:Float = 0
    var forwardBackward:Float = 0
    init(durationInSecond: Double, elevation:Float, rotation:Float, leftRight:Float, forwardBackward:Float) {
        super.init(durationInSecond: durationInSecond, speed: 0, direction: Direction.other)
        self.elevation = elevation
        self.rotation = rotation
        self.leftRight = leftRight
        self.forwardBackward = forwardBackward
    }
}
 
