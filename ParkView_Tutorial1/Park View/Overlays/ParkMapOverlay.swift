//
//  ParkMapOverlay.swift
//  Park View
//
//  Created by Jennifer Lee on 9/23/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ParkMapOverlay: NSObject, MKOverlay {
    var coordinate: CLLocationCoordinate2D
    var boundingMapRect: MKMapRect
    
    //takes the properties from the passed Park object, and sets
    //them to the corresponding MKOverlay propertie
    init(park: Park) {
        boundingMapRect = park.overlayBoundingMapRect
        coordinate = park.midCoordinate
    }
}
