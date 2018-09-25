// Imports for Map usage, iMessage controller composition
import UIKit
import MapKit
import MessageUI

class ViewController: UIViewController, MFMessageComposeViewControllerDelegate {

    /* Connecting objects from Storyboard */
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var shareArtworkButtonOutlet: UIButton!
    
    /* An array to hold the Artwork objects from the JSON file */
    var artworks: [Artwork] = []
    
    /* Keep track of authorization status for accessing the user’s location */
    let locationManager = CLLocationManager()
    
    /* Selected Artwork to share with friends */
    var selectedAnnotation: Artwork?
    
    /* Check location permissions upon view */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Editing appearance of share button */
        shareArtworkButtonOutlet.layer.cornerRadius = shareArtworkButtonOutlet.frame.height / 2
        shareArtworkButtonOutlet.clipsToBounds = true
        shareArtworkButtonOutlet.isHidden = true
        
        /* Set initial location in Honolulu */
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        
        /* Zoom into initialLocation on startup */
        centerMapOnLocation(location: initialLocation)
        
        /* Setting ViewController as the delegate of the map view */
        mapView.delegate = self
     
        /* Register ArtworkMakerView class */
        mapView.register(ArtworkView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)

        /* Create an artworks array */
        loadInitialData()
        
        /* Add artworks to map */
        mapView.addAnnotations(artworks)

    }
    
    /* Declare radius and center location */
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    /* Loading JSON data */
    func loadInitialData() {
        guard let fileName = Bundle.main.path(forResource: "PublicArt", ofType: "json")
            else { return }
        let optionalData = try? Data(contentsOf: URL(fileURLWithPath: fileName))
        
        guard
            let data = optionalData,
            let json = try? JSONSerialization.jsonObject(with: data),
            let dictionary = json as? [String: Any],
            let works = dictionary["data"] as? [[Any]]
            else { return }
        let validWorks = works.flatMap { Artwork(json: $0) }
        artworks.append(contentsOf: validWorks)
    }
    
    /* iMessage finished */
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    /* Open iMessage upon "Share Artwork" */
    @IBAction func shareArtworkButtonClicked(_ sender: Any) {
        let title = selectedAnnotation?.title
        let coord = selectedAnnotation?.coordinate
        let type = selectedAnnotation?.discipline
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Check out this art piece!\n\n\(title!), a \(type!):\nhttp://maps.apple.com/?ll=\(coord!.latitude),\(coord!.longitude)"
            controller.recipients = []
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    /* “Tick” the map view’s Shows-User-Location checkbox if your app is authorized */
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else { // tell locationManager to request authorization from the user
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension ViewController: MKMapViewDelegate {
    
    /* Upon callout button clicked, open Maps */
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Artwork // grab the Artwork object that this tap refers to
        // show driving directions from the user’s current location to this pin
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    /* When a user selects an artwork, show share buton */
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        shareArtworkButtonOutlet.isHidden = false
        self.selectedAnnotation = view.annotation as? Artwork
    }
    
    /* When a user deselects an artwork, hide share button */
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        shareArtworkButtonOutlet.isHidden = true
    }
    
}


