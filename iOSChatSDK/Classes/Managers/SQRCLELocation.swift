//
//  SQRCLELocation.swift
//  Dynasas
//
//  Created by Dynasas on 29/04/23.
//

import UIKit
import Foundation
import CoreLocation

enum LocationResult<T> {
    case success(T)
    case failure(Error)
}

final class SQRCLELocation: NSObject {
    
    public var newLocation: ((LocationResult<CLLocation>) -> Swift.Void)?
    public var didChangeStatus:((Bool) -> Swift.Void)?
    
    private let locationManager: CLLocationManager?
    init(manager: CLLocationManager = .init()) {
        self.locationManager = manager
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
    
    //MARK:- .init()
    @available(iOS 14.0, *)
    public var authorizationStatus: CLAuthorizationStatus {
       CLAuthorizationStatus(rawValue: (locationManager?.authorizationStatus)!.rawValue) ?? .denied
    }
    
    //MARK:- Request for permission
    public func requestLocationAuthorization() {
        locationManager?.requestWhenInUseAuthorization()
    }
    
    //MARK:- get currentlocation
    public func getCurrentLocation() {
        locationManager?.requestLocation()
    }
    
      //MARK:- allow Backgrounds
    public var allowsBackgroundLocationUpdates: Bool = false {
        didSet {
            locationManager?.pausesLocationUpdatesAutomatically = !allowsBackgroundLocationUpdates
            locationManager?.allowsBackgroundLocationUpdates = allowsBackgroundLocationUpdates
        }
    }

     //MARK:- Reverse Geo Coding
    public func getAddressFromLocation(location: CLLocation?, completionHandler:@escaping(String) -> ()) {
        let geoCoder = CLGeocoder()
        if let location = location,
            geoCoder.isGeocoding == false {
            geoCoder.reverseGeocodeLocation(location) { placeMarks, error in
                if let error = error {
                    print(error.localizedDescription)
                    geoCoder.cancelGeocode()
                    return
                }
                if let placemarker = placeMarks?.first {
                    completionHandler(placemarker.customAddress)
                }
            }
        }
    }
    
    
    //MARK:- GeoCoding
    public func getLocationFromAddress(_ address: String, completionHandler: @escaping(LocationResult<CLLocation>) -> ()) {
        let geoCoder = CLGeocoder()
        if geoCoder.isGeocoding == false {
            geoCoder.geocodeAddressString(address) { placeMarkers, error in
                if let error = error {
                    print(error.localizedDescription)
                    geoCoder.cancelGeocode()
                    completionHandler(.failure(error))
                    return
                }
                if let placeMarker = placeMarkers?.first,
                    let location = placeMarker.location {
                    completionHandler(.success(location))
                }
            }
        }
    }
}


//MARK:- CLLocationManagerDelegate
extension SQRCLELocation: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.sorted(by: { $0.timestamp > $1.timestamp }).first {
            newLocation?(.success(location))
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        newLocation?(.failure(error))
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined, .denied, .restricted:
            didChangeStatus?(false)
        default:
            didChangeStatus?(true)
        }
    }
}

//MARK:- CLPlacemark
extension CLPlacemark {

    var customAddress: String {
        get {
            return [/*[subThoroughfare, thoroughfare],*/
                    /*[subLocality, locality, administrativeArea],*/
                    [locality, country, postalCode]]
                .map { (subComponents) -> String in
                    subComponents.compactMap({ $0 }).joined(separator: ", ")
            }
                .filter({ return !$0.isEmpty })
                .joined(separator: ", ")
        }
    }
}

