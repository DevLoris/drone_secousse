//
//  SpheroMatrixUtils.swift
//  SparkPerso
//
//  Created by  on 31/10/2019.
//  Copyright © 2019 AlbanPerli. All rights reserved.
//

import Foundation
import UIKit

class SpheroMatrixUtils {
    static func setMatrix(_ matrix:NSArray, to:BoltToy) {
        if matrix.count == 2 {
            let colors = matrix[1] as! NSArray
            
            let colorV2:[UIColor] = colors.map { (value) -> UIColor in
                if let v = value as? NSArray {
                    return UIColor(red: v[0] as! CGFloat, green: v[1] as! CGFloat, blue: v[2] as! CGFloat, alpha: v[3] as! CGFloat)
                }
                return UIColor.clear
            }
            
            
            let pixels = matrix[0] as! NSArray
            for (y, line) in pixels.enumerated() {
                for (x, pixel) in (line as? NSArray)?.enumerated() ?? NSArray().enumerated() {
                    to.drawMatrix(pixel: Pixel(x: x, y: y), color: colorV2[pixel as? Int ?? 0])
                }
            }
        }
    }
}
