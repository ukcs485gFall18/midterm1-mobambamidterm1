import Foundation
import MapKit
import Contacts

/* Artwork must subclass NSObject, because MKAnnotation is an NSObjectProtocol */
class Artwork: NSObject, MKAnnotation {
    
    /* Conforming to protocol - using required variables */
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    /* Set the glyph’s image instead of its text */
    var imageName: String? {
        if discipline == "Sculpture" { return "Statue" }
        return "Flag"
    }
    
    /* Initializer for MKAnnotation variables */
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        super.init()
    }
    
    /* Preparing JSON data for mapping */
    init?(json: [Any]) {
        self.title = json[16] as? String ?? "No Title"
        self.locationName = json[11] as! String // formerly json[12]
        self.discipline = json[15] as! String
        if let latitude = Double(json[18] as! String),
            let longitude = Double(json[19] as! String) {
            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            self.coordinate = CLLocationCoordinate2D()
        }
    }

    /* Assigning a computed, read only property called subtitle */
    var subtitle: String? {
        return locationName
    }
    
    /* Annotation right callout accessory opens this mapItem in Maps app */
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}
