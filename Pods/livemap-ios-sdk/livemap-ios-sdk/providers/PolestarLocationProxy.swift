//
//  PolestarLocationProvider.swift
//  livemap-ios-sdk
//
//  Created by Thibault Capelli on 23/05/2022.
//

import CoreLocation

#if canImport(NAOSwiftProvider)
    import NAOSwiftProvider

    protocol PolestarLocationProviderDelegate: LocationProviderDelegate {}
    class PolestarLocationProvider: LocationProvider {}
#else
    protocol PolestarLocationProviderDelegate {}
    class PolestarLocationProvider {}
#endif

class PolestarLocationProxy: PolestarLocationProviderDelegate {
    var provider: PolestarLocationProvider? = nil

    // Callbacks
    internal var didLocationChangeCallback: ((_ coordinates: PolestarCoordinates) -> Void)? = nil;

    required init(apikey: String) throws {
        #if canImport(NAOSwiftProvider)
            self.provider = PolestarLocationProvider(apikey: apikey)
            self.provider?.delegate = self
        #else
            throw "NAOSwiftProvider is not available. Please make sure you added it to your project."
        #endif
    }
    
    func didLocationChange(_ location: CLLocation!) {
        let coordinates = PolestarCoordinates(lat: location.coordinate.latitude, lng: location.coordinate.longitude, alt: location.altitude, accuracy: location.horizontalAccuracy, time: Int(location.timestamp.timeIntervalSince1970 * 1000), bearing: location.course);

        if let didLocationChangeCallback = self.didLocationChangeCallback {
            didLocationChangeCallback(coordinates);
        }
    }

    func requiresWifiOn() {}

    func requiresBLEOn() {}

    func requiresLocationOn() {}

    func requiresCompassCalibration() {}

    func didSynchronizationSuccess() {}

    func didApikeyReceived(_ apikey: String!) {}

    func didLocationStatusChanged(_ status: String!) {}

    func didEnterSite(_ name: String!) {}

    func didExitSite(_ name: String!) {}

    func didLocationFailWithErrorCode(_ message: String!) {}

    func didSynchronizationFailure(_ message: String!) {}

}

