//
//  PlaceController.swift
//  Velik
//
//  Created by Pavel Borisevich on 28.04.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

import UIKit
import GoogleMaps
import SVProgressHUD

class PlaceController: UIViewController {

    private var latitude: Double = 0
    private var longitude: Double = 0
    
    var location: String?
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var viewForMap: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoView.layer.cornerRadius = 12.0
        
        guard let components = location?.components(separatedBy: " ") else { return }
        latitude = Double(components.first ?? "0") ?? 0
        longitude = Double(components.last ?? "0") ?? 0
        
        SVProgressHUD.setDefaultMaskType(.clear)
        
        let kCameraLatitude = latitude
        let kCameraLongitude = longitude
        let camera = GMSCameraPosition.camera(withLatitude: kCameraLatitude, longitude: kCameraLongitude, zoom: 13)
        viewForMap.camera = camera
        viewForMap.delegate = self
        viewForMap.isMyLocationEnabled = true
        
        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let marker = GMSMarker(position: position)
        marker.map = self.viewForMap
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        GMSGeocoder().reverseGeocodeCoordinate(position) { (response, error) in
            if error == nil {
                let address = response?.results()?.first
                self.addressTextView.text = "\(address?.thoroughfare ?? ""), \(address?.locality ?? "")."
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateMap(self)
    }
    
    private func updateMap(_ sender: Any) {
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
    @IBAction func refreshMap(_ sender: UIBarButtonItem) {
        updateMap(self)
    }
}

extension PlaceController : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return false
    }
}

extension PlaceController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
    }
}
