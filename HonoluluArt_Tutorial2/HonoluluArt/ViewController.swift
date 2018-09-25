/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import MapKit // import MapKit


class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView! // connection to mapView
    
    // an array to hold the Artwork objects from the JSON file
    var artworks: [Artwork] = []
    
    // keep track of authorization status for accessing the user’s location
    let locationManager = CLLocationManager()
    // “tick” the map view’s Shows-User-Location checkbox if your app is authorized
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else { // tell locationManager to request authorization from the user
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set initial location in Honolulu
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        
        // zoom into initialLocation on startup
        centerMapOnLocation(location: initialLocation)
        
        // setting ViewController as the delegate of the map view
        mapView.delegate = self
     
        // register ArtworkMakerView class
        /* mapView.register(ArtworkMarkerView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) */
        // replace with:
        mapView.register(ArtworkView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)

        
        // create an artworks array
        loadInitialData()
        
        // add artworks to map
        mapView.addAnnotations(artworks)
        
        // Jen's Functions!!
        addCompass()
        addScale()
        
    }
    
    // Jen's Function!
    // I made a compass!
    func addCompass() {
        
        mapView.showsCompass = false  // Hide built-in compass
        
        let compassButton = MKCompassButton(mapView: mapView)   // Make a new compass
        compassButton.compassVisibility = .visible // Make compass visible
        
        let x = 20
        let y = 40 // to place in top left corner (above compass)
        
        compassButton.frame.origin = CGPoint(x: x, y: y) // position compass
        
        mapView.addSubview(compassButton) // Add compass to the view
        
    }
    
    // Jen's Function!
    // I made a scale!
    func addScale() {
        
        mapView.showsScale = false // Hide built in scale
        
        let scale = MKScaleView(mapView: mapView) // Make a new scale
        scale.scaleVisibility = .visible // Make scale visable (when zoomed)
        
        scale.legendAlignment = MKScaleView.Alignment.leading // makes 0 to the left
        
        scale.frame.origin.x = 20
        scale.frame.origin.y = 10 // position in top left corner
        
         mapView.addSubview(scale) // add scale to view
    }
    
    
    // declare radius and center location
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func loadInitialData() {
        // read the PublicArt.json file into a Data object
        guard let fileName = Bundle.main.path(forResource: "PublicArt", ofType: "json")
            else { return }
        let optionalData = try? Data(contentsOf: URL(fileURLWithPath: fileName))
        
        guard
            let data = optionalData,
            // use JSONSerialization to obtain a JSON object
            let json = try? JSONSerialization.jsonObject(with: data),
            // check that the JSON object is a dictionary with String keys and Any values
            let dictionary = json as? [String: Any],
            // only interested in the JSON object whose key is "data"
            let works = dictionary["data"] as? [[Any]]
            else { return }
        // flatmap this array of arrays
        let validWorks = works.flatMap { Artwork(json: $0) }
        // append the resulting validWorks to the artworks array
        artworks.append(contentsOf: validWorks)
    }

}

extension ViewController: MKMapViewDelegate {
    // called for every annotation you add to the map
    /*func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // check that this annotation is an Artwork object
        guard let annotation = annotation as? Artwork else { return nil }
        // To make markers appear, you create each view as an MKMarkerAnnotationView
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // check to see if a reusable annotation view is available before creating a new one
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // create a new MKMarkerAnnotationView object
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    } */
    
    // when the user taps the callout button.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Artwork // grab the Artwork object that this tap refers to
        // show driving directions from the user’s current location to this pin
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
}


