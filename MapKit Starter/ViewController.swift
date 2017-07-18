//
//  ViewController.swift
//  MapKit Starter
//
//  Created by Pranjal Satija on 10/25/16.
//  Copyright © 2016 Pranjal Satija. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet var mapView: MKMapView?
    
    let locationManager = CLLocationManager()
    
    let places = Place.getPlaces()
    
    
    
    
    override func viewDidLoad() {
        requestLocationAccess()
        
        mapView?.showsUserLocation = true
        addAnnotations()
        
        
//        let coordinate₀ = CLLocation(latitude: 5.0, longitude: 5.0)
//        let coordinate₁ = CLLocation(latitude: 5.0, longitude: 3.0)
//        
//        let distanceInMeters = coordinate₀.distance(from: coordinate₁)
        
        
    }
    
    
    func addAnnotations() {
        
        mapView?.delegate = self
        mapView?.addAnnotations(places)
        
        let overlays = places.map { MKCircle(center: $0.coordinate, radius: 100) }
        mapView?.addOverlays(overlays)
        
        var locations = places.map { $0.coordinate }
        let polyline = MKPolyline(coordinates: &locations, count: locations.count)
        mapView?.add(polyline)
        
        
     
        
        for point in UnsafeBufferPointer(start: polyline.points(), count: polyline.pointCount) {
            print("\(point.x),\(point.y)")
            
            print(mapView?.convert(CGPoint.init(x: point.x, y: point.y), toCoordinateFrom: mapView))
        }
        
        
    
    }
    
    
    func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
            
        case .denied, .restricted:
            print("location access denied")
            
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 2
            return renderer
        } else if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.orange
            renderer.lineWidth = 3
            return renderer
        }
        
        return MKOverlayRenderer()
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
            
        else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            annotationView.image = UIImage(named: "place icon")
            return annotationView
        }
    }
}



