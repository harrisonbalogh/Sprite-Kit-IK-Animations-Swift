//
//  CGPointExtensions.swift
//  Harxer
//
//  Created by Harrison Balogh on 11/3/15.
//  Copyright © 2015 Harxer. All rights reserved.
//

import Foundation
import SpriteKit

extension CGPoint {
    
    /**
     Calculates a distance to the given point.
     
     - parameters: 
        - point: the point to calculate a distance to
     
     - returns: distance between current and the given points
     */
    func distance(_ point: CGPoint) -> CGFloat {
        let dx = self.x - point.x
        let dy = self.y - point.y
        return sqrt(pow(dx, 2) + pow(dy, 2))
    }
}
