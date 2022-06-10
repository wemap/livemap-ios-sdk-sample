//
//  ViewController.swift
//  livemap-ios-sdk-sample
//
//  Created by Bertrand Mathieu-Daudé on 21/02/2020.
//  Copyright © 2020 Bertrand Mathieu-Daudé. All rights reserved.
//

import UIKit
import livemap_ios_sdk

class ViewController: UIViewController {
    let wemap = wemapsdk.sharedInstance
    var currentPolylineId: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        wemap.delegate = self
        
        _ = wemap.configure(config: wemapsdk_config(
            token: "GUHTU6TYAWWQHUSR5Z5JZNMXX",
            mapId: 19158
        )).presentIn(view: self.view)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        wemap.frame = self.view.bounds
    }
}


// clicking pinpoints show log noise that is not problematic, as said by Apple
// https://developer.apple.com/forums/thread/691361
extension ViewController: wemapsdkViewDelegate {
    
    private func printClassAttributes(_ classInstance: Any) {
        let mirror = Mirror(reflecting: classInstance)
        let properties = mirror.children
        
        for property in properties {
            print("_ \(property.label!) = \(property.value)")
        }
    }
   
    @objc func waitForReady(_ wemapController: wemapsdk) {
        print("Livemap is Ready")
        
//        // SET PINPOINTS
//        self.wemap.setSourceLists(sourceLists: [74878]) // added over Paris
        
//        // OPEN PINPOINT
//        wemap.openPinpoint(WemapPinpointId: 31604315)
        
//         // NAVIGATE TO PINPOINT
//         let location = WemapLocation(longitude: 3.6, latitude: 43.9)
//         self.wemap.navigateToPinpoint(WemapPinpointId:29550092, location: location, heading: 50)
        
//        // OPEN EVENT
//        self.wemap.openEvent(WemapEventId:2816693)
        
//        // SET FILTERS
//        let filter = WemapFilters(
//             tags: ["jardin-remarquable"],
//             query: "Aragon",
//             startDate: "2019-09-21",
//             endDate: "2019-09-21"
//         )
//        self.wemap.setFilters(WemapFilters: filter)
        
//         Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { (timer) in
//             self.wemap.closePinpoint()
//             self.wemap.closeEvent()
//             self.wemap.stopNavigation()
//         }
         
//        // DRAW POLYLINE
//        if #available(iOS 14.0, *) {
//            let c1 = Coordinates(latitude: 43.618214, longitude: 3.834515, altitude: 0)
//            let c2 = Coordinates(latitude: 45.618214, longitude: 3.834515, altitude: 0)
//
//            self.wemap.drawPolyline(coordinatesList: [c1, c2], completion: { id in print("drawPolyline id is: \(id)") })
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
//                self.wemap.removePolyline(id: self.currentPolylineId!)
//                print("Polyline removed: \(String(describing: self.currentPolylineId))")
//                self.currentPolylineId = nil
//            }
//        }
        
//        // CENTER TO
//        self.wemap.centerTo(center: Coordinates(latitude: 43.618214, longitude: 3.834515, altitude: 0), zoom: 20)
        
//        // ENABLE ANALYTICS
//        self.wemap.enableAnalytics()
        
//        // DISABLE ANALYTICS
//        self.wemap.disableAnalytics()
        
//        // POSITIONING SYSTEM METHODS
//        if #available(iOS 14.0, *) {
//            self.wemap.disablePositioningSystem() {
//                self.wemap.setUserLocation(userLocation: Coordinates(latitude: 48.86, longitude: 2.34)) {
//                    self.wemap.getUserLocation() { coordinate in
//                        print(coordinate)
//                    }
//                }
//                self.wemap.setDeviceAttitude(attitude: Attitude(quaternion: [1, 0, 0, 0])) {
//                    self.wemap.getDeviceAttitude() { attitude in
//                        print(attitude)
//                    }
//                }
//            }
//        }
    }
    
    @objc func onEventOpen(_ wemapController: wemapsdk, event: WemapEvent) {
        print("Event opened: \(event.id)")
    }
    
    @objc func onPinpointOpen(_ wemapController: wemapsdk, pinpoint: WemapPinpoint) {
        print("Pinpoint opened: \(pinpoint.id)")
    }
    
    @objc func onEventClose(_ wemapController: wemapsdk) {
        print("Event closed")
    }
    
    @objc func onPinpointClose(_ wemapController: wemapsdk) {
        print("Pinpoint closed")
    }
    
    @objc func onGuidingStarted(_ wemapController: wemapsdk) {
        print("Guiding Started")
    }
    
    @objc func onGuidingStopped(_ wemapController: wemapsdk) {
        print("Guiding Stopped")
    }
    
    @objc func onBookEventClicked(_ wemapController: wemapsdk, event: WemapEvent) {
        print("Book Event Clicked: \(event.id)")
    }
    
    @objc func onGoToPinpointClicked(_ wemapController: wemapsdk, pinpoint: WemapPinpoint) {
        print("Go To Pinpoint Clicked: \(pinpoint.id)")
    }
    
    @objc func onActionButtonClick(_ wemapController: wemapsdk, event: WemapEvent, actionType: String) {
        print("Action \(actionType) clicked on event: \(event.id)")
    }
    
    @objc func onActionButtonClick(_ wemapController: wemapsdk, pinpoint: WemapPinpoint, actionType: String) {
        print("Action \(actionType) clicked on pinpoint: \(pinpoint.id)")
    }

    @objc func onMapMoved(_ wemapController: wemapsdk, mapMoved: MapMoved) {
        print("Map Moved:")
        printClassAttributes(mapMoved)
    }
    
    @objc func onMapClick(_ wemapController: wemapsdk, coordinates: Coordinates) {
        print("Map Click:")
        printClassAttributes(coordinates)
    }
    
    @objc func onMapLongClick(_ wemapController: wemapsdk, coordinates: Coordinates) {
        print("Map Long Click:")
        printClassAttributes(coordinates)
    }
    
    @objc func onContentUpdated(_ wemapController: wemapsdk, events: [WemapEvent], contentUpdatedQuery: ContentUpdatedQuery) {
        print("Content Updated (WemapEvent):")
        printClassAttributes(contentUpdatedQuery)
    }
    
    @objc func onContentUpdated(_ wemapController: wemapsdk, pinpoints: [WemapPinpoint], contentUpdatedQuery: ContentUpdatedQuery) {
        print("Content Updated (WemapPinpoint):")
        printClassAttributes(contentUpdatedQuery)
    }
    
    @objc func onPolylineDrawn(_ wemapController: wemapsdk, id: String) {
        print("Polyline Drawn: \(id)")
        self.currentPolylineId = id
    }
}

