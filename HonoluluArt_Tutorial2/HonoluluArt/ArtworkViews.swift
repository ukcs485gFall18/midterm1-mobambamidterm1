import Foundation
import MapKit

/* Both classes in this file were created by the starter project */

/* Configuring artwork annotation marker view */
class ArtworkMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let artwork = newValue as? Artwork else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            /* Selecting correct image */
            if let imageName = artwork.imageName {
                glyphImage = UIImage(named: imageName)
            } else {
                glyphImage = nil
            }

        }
    }
}

/* Configuring artwork view */
class ArtworkView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let artwork = newValue as? Artwork else {return}
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30)))
            
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = artwork.subtitle
            detailCalloutAccessoryView = detailLabel
            
            /* set background image to the Maps icon */
            mapsButton.setBackgroundImage(UIImage(named: "Maps-icon"), for: UIControlState())
            rightCalloutAccessoryView = mapsButton

            if let imageName = artwork.imageName {
                image = UIImage(named: imageName)
            } else {
                image = nil
            }
        }
    }
}

