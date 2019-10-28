//
//  DelayHelper.swift
//  SparkPerso
//
//  Created by  on 17/10/2019.
//  Copyright © 2019 AlbanPerli. All rights reserved.
//

import UIKit

class DelayHelper {
    static func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}
