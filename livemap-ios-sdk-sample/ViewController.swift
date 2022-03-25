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
    var onMapReadyCallback: () -> Void = {}

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        wemap.delegate = self

        _ = wemap.configure(config: wemapsdk_config(token: "GUHTU6TYAWWQHUSR5Z5JZNMXX", mapId: 19158)).presentIn(view: self.view)

        //test_bounding_box()
        //test_introcard_and_disable_analytics()
    }

    func test_bounding_box() {
        // Test with boundaries using the parameter maxBounds
        let box = BoundingBox(northEast: Coordinates(latitude: 52.526714, longitude: 13.37477),
                    southWest: Coordinates(latitude: 52.522667, longitude: 13.364878))
        // let box: BoundingBox? = nil
        _ = wemap.configure(config: wemapsdk_config(
            token: "GUHTU6TYAWWQHUSR5Z5JZNMXX",
            mapId: 19158,
            maxbounds: box
        )).presentIn(view: self.view)
    }

    func test_introcard_and_disable_analytics() {
        _ = wemap.configure(config: wemapsdk_config(
            token: "GUHTU6TYAWWQHUSR5Z5JZNMXX",
            mapId: 19158,
            introcardActive: true
        )).presentIn(view: self.view)

        onMapReadyCallback = {
            self.wemap.disableAnalytics()
            self.wemap.enableAnalytics()
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        wemap.frame = self.view.bounds
    }
}

// clicking pinpoints show log noise that is not problematic, as said by Apple
// https://developer.apple.com/forums/thread/691361
extension ViewController: wemapsdkViewDelegate {

    @objc func waitForReady(_ wemapController: wemapsdk) {
        print("Livemap is Ready")
        // self.wemap.aroundMe()
        // self.wemap.setSourceLists(sourceLists: [74878]) // added over Paris
        // wemap.openPinpoint(WemapPinpointId:31604315)
        // let location = WemapLocation(longitude: 3.6, latitude: 43.9)
        // self.wemap.navigateToPinpoint(WemapPinpointId:29550092, location: location, heading: 50)
        // self.wemap.openEvent(WemapEventId:2816693)
        
        /*
         let filter = WemapFilters(
         tags: ["jardin-remarquable"],
         query: "Aragon",
         startDate: "2019-09-21",
         endDate: "2019-09-21"
         )
         */
        // self.wemap.setFilters(WemapFilters: filter)

        /*
         Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { (timer) in
         // self.wemap.closePinpoint()
         // self.wemap.closeEvent()
         self.wemap.stopNavigation()
         }
         */

         onMapReadyCallback()
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

    @objc func onMapMoved(_ wemapController: wemapsdk, json: NSDictionary) {
        print("Map Moved \(json)")
    }
    
    @objc func onMapClick(_ wemapController: wemapsdk, json: NSDictionary) {
        print("Map Click: \(json)")
    }
    
    @objc func onMapLongClick(_ wemapController: wemapsdk, json: NSDictionary) {
        print("Map Long Click: \(json)")
    }
}

