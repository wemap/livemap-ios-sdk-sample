//
//  WemapSDKActionsDelegate.swift
//  livemap-ios-sdk
//
//  Created by Bertrand Mathieu-Daudé on 24/02/2020.
//  Copyright © 2020 Bertrand Mathieu-Daudé. All rights reserved.
//

import Foundation

/**
 WemapSDKMapDelegate used to pass notifictons about user actions on map.
 All notifications will be sent in background queue and this is optional to implement handling all of them.
 */
@objc public protocol WemapSDKMapActionsDelegate: class {
    /**
     Notify user moved map to specified region.
     
     - Parameter region: an WemapSDKMapBaseViewController object of map view controller.
     Could be sublassed to WemapSDKMapViewController or WemapSDKMapKitViewController, depends on type of map which you used.
     */
    @objc optional func regionDidChanged(controller: wemapsdk)
    
    /**
     Notify user moved map to specified region.
     
     - Parameter controller: an WemapSDKMapBaseViewController object of map view controller.
     Could be sublassed to WemapSDKMapViewController or WemapSDKMapKitViewController, depends on type of map which you used.
     - Parameter pinpoint: a touched WemapPinpoint object.
     */
    @objc optional func openPinpoint(controller: wemapsdk)
    
    /**
     Notify user moved map to specified region.
     
     - Parameter controller: an WemapSDKMapBaseViewController object of map view controller.
     Could be sublassed to WemapSDKMapViewController or WemapSDKMapKitViewController, depends on type of map which you used.
     - Parameter list: an opened WemapList object.
     */
    @objc optional func openList(controller: wemapsdk)
    
    /**
     Notify user booked event or event added to user calendar.
     
     - Parameter controller: an WemapSDKMapBaseViewController object of map view controller.
     Could be sublassed to WemapSDKMapViewController or WemapSDKMapKitViewController, depends on type of map which you used.
     - Parameter event: a WemapEvent object.
     */
    @objc optional func bookEvent(controller: wemapsdk)
    
    /**
     Notify user moved map to specified region.
     
     - Parameter controller: an WemapSDKMapBaseViewController object of map view controller.
     Could be sublassed to WemapSDKMapViewController or WemapSDKMapKitViewController, depends on type of map which you used.
     - Parameter pinpoint: a shared WemapPinpoint object.
     */
    @objc optional func sharePinpoint(controller: wemapsdk)
    
    /**
     Notify user moved map to specified region.
     
     - Parameter controller: an WemapSDKMapBaseViewController object of map view controller.
     Could be sublassed to WemapSDKMapViewController or WemapSDKMapKitViewController, depends on type of map which you used.
     - Parameter map: an touched WemapPinpoint object.
     */
    @objc optional func shareMap(controller: wemapsdk)
}
