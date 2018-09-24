//
//  ParkMapOverlayView.swift
//  Park View
//
//  Created by Jennifer Lee on 9/23/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ParkMapOverlayView: MKOverlayRenderer {
    var overlayImage: UIImage
    
    //effectively overrides the base method init(overlay:)
    //by providing a second argument
    init(overlay:MKOverlay, overlayImage:UIImage) {
        self.overlayImage = overlayImage
        super.init(overlay: overlay)
    }
    
    //defines how MapKit should render this view when given a specific MKMapRect,
    //MKZoomScale, and the CGContext of the graphic context
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        guard let imageReference = overlayImage.cgImage else { return }
        
        let rect = self.rect(for: overlay.boundingMapRect)
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -rect.size.height)
        context.draw(imageReference, in: rect)
    }
}
