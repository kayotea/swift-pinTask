//
//  MapViewController.swift
//  PinTask
//
//  Created by Placoderm on 7/13/17.
//  Copyright © 2017 Placoderm. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class MapViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    
    var allowsBackgroundLocationUpdates: Bool = true
    @IBOutlet var mapSearchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    
    //for corelocation
    let manager = CLLocationManager()
    
    //for stored errand addresses
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var errands = [ErrandData]()
    var errand_coords = [CLLocationCoordinate2D]()
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        mapSearchBar.resignFirstResponder()
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(mapSearchBar.text!) { (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil {
                
                let placemark = placemarks?.first
                
                let anno = MKPointAnnotation()
                anno.coordinate = (placemark?.location?.coordinate)!
                anno.title = self.mapSearchBar.text!
                
                let span = MKCoordinateSpanMake(0.2, 0.2)
                let region = MKCoordinateRegionMake(anno.coordinate, span)
                
                self.mapView.setRegion(region, animated: true)
                self.mapView.addAnnotation(anno)
                self.mapView.selectAnnotation(anno, animated: true)
                
            } else {
                print(error?.localizedDescription ?? "error")
            }
            
        }
    }
    
    //update user location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1) //zoom zoom
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude) //location
        
        //region of user's location
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        mapView.setRegion(region, animated: true)
        
        self.mapView.showsUserLocation = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapSearchBar.delegate = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        //manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        fetchAllItems()
        
        //get coordinates for errands
        //then, pin errands to map
        getCoordinates()
        
        //debug
        let handle = setTimeout(2.0, block: { () -> Void in
            print (self.errand_coords)
            self.pinErrandCoordinates()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //CRUD - Read errands from CoreData
    func fetchAllItems() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ErrandData")
        
        do {//database retreive errands
            let result = try managedObjectContext.fetch(request)
            errands = result as! [ErrandData]
        } catch {
            print ("\(error)")
        }
    }
    //get coordinates of errand addresses
    func getCoordinates() {//(handleComlocaplete:(()->())){
        for errand in errands {
            if let errand_address = errand.errandAddress {
                let geoCoder = CLGeocoder()
                geoCoder.geocodeAddressString(errand_address) { (placemarks, error) in
                    guard
                        let placemarks = placemarks,
                        let location = placemarks.first?.location
                        else {// handle no location found
                            print("error")
                            return
                        }
                    let errand_location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)

                    print("\(errand_location)")
                    self.errand_coords.append(errand_location)
                }
            }
        }
    }
    //add errandpins to map
    func pinErrandCoordinates() {
        print ("WE MADE IT")
        
        for i in 0..<errands.count {
            
            let pin = MyAnnotation(title: errands[i].errandText, coordinate: errand_coords[i], subtitle: errands[i].errandAddress)
            
            mapView.addAnnotation(pin)
            
            //let smallSquare = CGSize(width: 30, height: 30)
            //let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
            //let request = MKDirectionsRequest()
            
            var pinView = mapView(mapView: mapView, viewForAnnotation: pin)
            
            //let directions = MKDirections(request: request)
            
            //button.addTarget(self, action: directions.calculate {[unowned self] response, error in
            //    guard let unwrappedResponse = response else { return }
                
            //    for route in unwrappedResponse.routes {
            //        self.mapView.add(route.polyline)
            //        self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            //    }}, for: .touchUpInside)
            //let pinView = MKPinAnnotationView(annotation: pin, reuseIdentifier: nil)
            //pinView.rightCalloutAccessoryView = button
            
            //button.addTarget(self, action: directions.calculate { [unowned self] response, error in
            //    guard let unwrappedResponse = response else {return}
            //    for route in
            //}, for: .TouchUpInside)
        }
    }
    func setTimeout(_ delay:TimeInterval, block:@escaping ()->Void) -> Timer {
        return Timer.scheduledTimer(timeInterval: delay, target: BlockOperation(block: block), selector: #selector(Operation.main), userInfo: nil, repeats: false)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        return renderer
    }
    //when user taps on pin button
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        if control == view.rightCalloutAccessoryView{
            print ("hi")
            
        }
    }
    //add disclosure button inside annotation window
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        print("viewForannotation")
        if annotation is MKUserLocation {
            //return nil
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            //println("Pinview was nil")
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
        }
        
        var button = UIButton(type: UIButtonType.detailDisclosure) as UIButton // button with info sign in it
        
        pinView?.rightCalloutAccessoryView = button
        
        
        return pinView
    }
    //support function - convert given address string into long & lat
    //func convertAddressStringToLongLat(address: String) {
    //    let geoCoder = CLGeocoder()
    //    geoCoder.geocodeAddressString(address) { (placemarks, error) in
    //        guard
    //            let placemarks = placemarks,
    //            let location = placemarks.first?.location
    //            else {// handle no location found
    //                print("error")
    //                return
    //        }
    //        print("location.coordinate: \(location.coordinate)")
    //        self.errand_coords.append(location.coordinate)
    //    }
    //}
    
}
