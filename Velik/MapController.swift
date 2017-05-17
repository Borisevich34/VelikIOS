//
//  MapController.swift
//  Velik
//
//  Created by Pavel Borisevich on 27.02.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

import UIKit
import GoogleMaps
import SVProgressHUD

class MapController: UIViewController {
    
    var radius = 7000
    var userLocation: CLLocation?
    
    private var mapView: GMSMapView!
    var stores: [GeoPoint: Store?] = [:]
    
    override func loadView() {
        
        SVProgressHUD.setDefaultMaskType(.clear)
        
        let kCameraLatitude = 53.9
        let kCameraLongitude = 27.56
        let camera = GMSCameraPosition.camera(withLatitude: kCameraLatitude, longitude: kCameraLongitude, zoom: 13)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self
        self.view = mapView
        mapView.isMyLocationEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateMap(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        if identifier == "Radius" {
            (segue.destination as? RadiusViewController)?.previousController = self
        }
        if identifier == "Store" {
            guard let marker = sender as? GMSMarker else { return }
            let latitude = marker.position.latitude
            let longitude = marker.position.longitude
            if let storeKey = stores.keys.first(where: { (point) -> Bool in
                (point.latitude.doubleValue == latitude && point.longitude.doubleValue == longitude)
            }) {
                (segue.destination as? StoreViewController)?.navigationItem.title = (stores[storeKey])??.name as String?
                (segue.destination as? StoreViewController)?.store = stores[storeKey] ?? nil
            }
        }
    }
    
    @IBAction func updateMap(_ sender: Any) {
        
        SVProgressHUD.show()
        var isNeedToHideHUD = false
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            if isNeedToHideHUD {
                SVProgressHUD.dismiss()
            }
            else {
                isNeedToHideHUD = true
            }
        }
        DispatchQueue.global().async { [weak self] in
            
            let locationManager = CLLocationManager()
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.delegate = self
            
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                locationManager.startUpdatingLocation()
            } else if CLLocationManager.authorizationStatus() == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            } else if CLLocationManager.authorizationStatus() == .restricted {
                print("User didn't alow using location")
            }
            
            DispatchQueue.main.async {
                self?.mapView.clear()
            }
            self?.stores.removeAll()
            
            var fault : Fault? = nil
            let storesQuery = BackendlessGeoQuery(point: GEO_POINT(latitude: self?.userLocation?.coordinate.latitude ?? 53.9,
                                                                   longitude: self?.userLocation?.coordinate.longitude ?? 27.5601),
                                                  radius: Double(self?.radius ?? 7000),
                                                  units: METERS)
            
            storesQuery?.includeMeta = 1
            if let collection = BackendlessAPI.shared.backendless?.geoService.getPoints(storesQuery, error: &fault).data {
                let geopoints = collection as? [GeoPoint] ?? [GeoPoint]()
                geopoints.forEach({ (point) in
                    let position = CLLocationCoordinate2D(latitude: point.latitude.doubleValue, longitude: point.longitude.doubleValue)
                    let store = (point.metadata.object(forKey: "store") as? [Store])?.first
                    DispatchQueue.main.async {
                        let marker = GMSMarker(position: position)
                        marker.title = (store?.name ?? "Store") as String
                        marker.map = self?.mapView
                    }
                    self?.stores[point] = store
                })
            }
            print(fault?.message ?? "Success")
            DispatchQueue.main.sync {
                if isNeedToHideHUD {
                    SVProgressHUD.dismiss()
                }
                else {
                    isNeedToHideHUD = true
                }
            }
        }
    }
}

extension MapController : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let selectedMarker = mapView.selectedMarker, selectedMarker.position.latitude == marker.position.latitude,
            selectedMarker.position.longitude == marker.position.longitude {
            performSegue(withIdentifier: "Store", sender: marker)
        }
        return false
    }
}

extension MapController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        if let userLocation = locations.first {
            self.userLocation = userLocation
            var fault : Fault? = nil
            let storesQuery = BackendlessGeoQuery(point: GEO_POINT(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), radius: Double(radius), units: METERS)
            _ = BackendlessAPI.shared.backendless?.geoService.relativeFind(storesQuery, error: &fault)
        }
    }
}
