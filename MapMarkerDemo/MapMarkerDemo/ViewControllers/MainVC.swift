//
//  MainVC.swift
//  MapMarkerDemo
//
//  Created by Thái Bô Lão on 8/12/16.
//  Copyright © 2016 TBLStudio. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MainVC: UIViewController {
    
    //MARK: - OUTLET
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - Variable
    var myLocation:CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    
    //MARK: - Constant
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        mapView.delegate = self
        mapView.mapType = .Standard
        mapView.zoomEnabled = true
        mapView.scrollEnabled = true
        
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenterCoordinate(coor, animated: true)
        }
       // addLongPressGesture()
        
        
        //Setup bar button items
        let leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: #selector(MainVC.leftBarButtonPressed))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        
    }
    
    //Bar button action
    static var enable:Bool = true
    func leftBarButtonPressed () {
        print("leftBarButtonPressed")
        if CLLocationManager.locationServicesEnabled() {
            if MainVC.enable {
                locationManager.stopUpdatingHeading()
            }else{
                locationManager.startUpdatingLocation()
            }
            MainVC.enable = !MainVC.enable
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        mapView.showsUserLocation = true;
    }
    
    override func viewWillDisappear(animated: Bool) {
        mapView.showsUserLocation = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func centerMap(center:CLLocationCoordinate2D){
        self.saveCurrentLocation(center)
        
        let spanX = 0.007
        let spanY = 0.007
        
        let newRegion = MKCoordinateRegion(center:center , span: MKCoordinateSpanMake(spanX, spanY))
        mapView.setRegion(newRegion, animated: true)
    }
    
    func saveCurrentLocation(center:CLLocationCoordinate2D){
        let message = "\(center.latitude) , \(center.longitude)"
        print(message)
        //self.lable.text = message
        myLocation = center
    }

}


extension MainVC: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        let identifier = "pin"
        var view : MKPinAnnotationView
        if let dequeueView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView{
            dequeueView.annotation = annotation
            view = dequeueView
        }else{
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        view.pinColor =  .Red
        return view
    }

}

extension MainVC: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        centerMap(locValue)
    }

    

}













