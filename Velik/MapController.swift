//
//  MapController.swift
//  Velik
//
//  Created by Pavel Borisevich on 27.02.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

import UIKit
import GoogleMaps

class MapController: UIViewController {
    
    var radius = 5000000
    @IBOutlet weak var viewForMap: UIView!
    
    private var mapView: GMSMapView!
    
    override func loadView() {
        
        let kCameraLatitude = 53.9
        let kCameraLongitude = 27.56
        let camera = GMSCameraPosition.camera(withLatitude: kCameraLatitude, longitude: kCameraLongitude, zoom: 13)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self
        self.view = mapView
        mapView.isMyLocationEnabled = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()

        //MARK - need for real device
        
//        let locationManager = CLLocationManager()
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//        locationManager.delegate = self
        
//        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
//            locationManager.startUpdatingLocation()
//        } else if CLLocationManager.authorizationStatus() == .notDetermined {
//            locationManager.requestWhenInUseAuthorization()
//        } else if CLLocationManager.authorizationStatus() == .restricted {
//            print("User didn't alow using location")
//        }
        
        var fault : Fault? = nil
        let storesQuery = BackendlessGeoQuery(point: GEO_POINT(latitude: 53.9, longitude: 27.5601), radius: Double(radius), units: METERS)
        storesQuery?.includeMeta = 1
        if let collection = BackendlessAPI.shared.backendless?.geoService.getPoints(storesQuery, error: &fault).data {
            let first = collection.first as! GeoPoint
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: first.latitude.doubleValue, longitude: first.longitude.doubleValue))
            let firstStore = first.metadata.object(forKey: "store") as! [Store]
                print("Hey DJ! \(firstStore.first?.information)")
                marker.title = (firstStore.first?.information ?? "Store") as String
            marker.map = mapView
            print("First")
        }
        print(fault?.message ?? "Hasn't fault")
        print("Collection is ready!")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "Radius" {
            (segue.destination as? RadiusViewController)?.previousController = self
        }
    }
}

extension MapController : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let selectedMarker = mapView.selectedMarker, selectedMarker.position.latitude == marker.position.latitude,
            selectedMarker.position.longitude == marker.position.longitude {
            performSegue(withIdentifier: "Store", sender: self)
        }
        return false
    }
}

//MARK - need for real device
extension MapController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        if let userLocation = locations.first {
            var fault : Fault? = nil
            let storesQuery = BackendlessGeoQuery(point: GEO_POINT(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), radius: Double(radius), units: METERS)
            _ = BackendlessAPI.shared.backendless?.geoService.relativeFind(storesQuery, error: &fault)
        }
    }
}
