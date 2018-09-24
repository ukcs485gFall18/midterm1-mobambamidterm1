//
//  Character.swift
//  Park View
//
//  Created by Jennifer Lee on 9/23/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Character: MKCircle {
    
    var name: String?
    var color: UIColor?
    
    //accepts a plist filename and color to draw the circle.
    convenience init(filename: String, color: UIColor) {
        guard let points = Park.plist(filename) as? [String] else { self.init(); return }
        //reads in the data from the plist
        let cgPoints = points.map { CGPointFromString($0) }
        let coords = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }
        //selects a random location from the four locations in the file.
        let randomCenter = coords[Int(arc4random()%4)]
        //choses a random radius to simulate the time variance.
        let randomRadius = CLLocationDistance(max(5, Int(arc4random()%40)))
        
        self.init(center: randomCenter, radius: randomRadius)
        self.name = filename
        self.color = color
    }
}
