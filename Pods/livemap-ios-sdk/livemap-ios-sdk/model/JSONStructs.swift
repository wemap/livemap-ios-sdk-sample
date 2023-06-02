import Foundation

extension Dictionary where Key: Encodable, Value: Encodable {
    func asJSONStr() -> String? {
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(self) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        }
        
        return nil
    }
}

public class JSON: NSObject {
    internal func toJSONObject() -> Any? {
        return nil
    }
    
    internal func toJSON() -> Data {
        do {
            return try JSONSerialization.data(withJSONObject: self.toJSONObject()!, options: [])
        } catch {
            return Data()
        }
    }

    internal func toJSONString() -> String {
        return String(data: self.toJSON(), encoding: String.Encoding.ascii) ?? ""
    }
}

public class Coordinates: JSON {
    public let latitude: Double;
    public let longitude: Double;
    public let altitude: Double?;
    public let accuracy: Float?

    /// - Parameters:
    ///   - latitude: Double
    ///   - longitude: Double
    ///   - altitude: Double
    public init(latitude: Double,
                longitude: Double,
                altitude: Double? = nil,
                accuracy: Float? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.accuracy = accuracy
    }
    
    
    public func toJSONArray() -> Any {
         do {
             return [self.longitude, self.latitude]
        } catch {
            return []
        }
    }
    
    
    public static func fromDictionary(_ dict: NSDictionary) -> Coordinates {
        let latitude = dict["latitude"] as! Double;
        let longitude = dict["longitude"] as! Double;
        let altitude = dict["altitude"] as? Double;
        let accuracy = dict["accuracy"] as? Float;
        
        return Coordinates(latitude: latitude, longitude: longitude, altitude: altitude, accuracy: accuracy)
    }
    
    public func toLngLatJSONObject() -> [String: Double] {
        return [
            "latitude": self.latitude,
            "longitude": self.longitude
        ]
    }
    
    public override func toJSONObject() -> Any {
        return [
            "latitude": self.latitude,
            "longitude": self.longitude,
            "altitude": self.altitude as Any,
            "accuracy": self.accuracy as Any
        ]
    }
}

public class PolestarCoordinates: JSON {
    public let lat: Double;
    public let lng: Double;
    public let alt: Double?;
    public let accuracy: Double;
    public let time: Int;
    public let bearing: Double;

    /// - Parameters:
    ///   - latitude: Double
    ///   - longitude: Double
    ///   - altitude: Double
    public init(lat: Double,
                lng: Double,
                alt: Double? = nil,
                accuracy: Double,
                time: Int,
                bearing: Double) {
        self.lat = lat
        self.lng = lng
        self.alt = alt
        self.accuracy = accuracy
        self.time = time
        self.bearing = bearing
    }
    
    public static func fromDictionary(_ dict: NSDictionary) -> PolestarCoordinates {
        let lat = dict["lat"] as! Double;
        let lng = dict["lng"] as! Double;
        let alt = dict["alt"] as? Double;
        let accuracy = dict["accuracy"] as! Double;
        let time = dict["time"] as! Int;
        let bearing = dict["bearing"] as! Double;

        return PolestarCoordinates(lat: lat,
                                   lng: lng,
                                   alt: alt,
                                   accuracy: accuracy,
                                   time: time,
                                   bearing: bearing)
    }
    
    public override func toJSONObject() -> Any {
        return [
            "lat": self.lat,
            "lng": self.lng,
            "alt": self.alt as Any,
            "accuracy": self.accuracy,
            "time": self.time,
            "bearing": self.bearing
        ]
    }
}

public class BoundingBox: JSON {
    public let northEast: Coordinates;
    public let southWest: Coordinates;
    
    /// - Parameters:
    ///   - northEast: Coordinates
    ///   - southWest: Coordinates
    public init(northEast: Coordinates, southWest: Coordinates) {
        self.northEast = northEast
        self.southWest = southWest
    }
    
    public static func fromDictionary(_ dict: NSDictionary) -> BoundingBox {
        let northEast = Coordinates.fromDictionary(dict["northEast"] as! NSDictionary);
        let southWest = Coordinates.fromDictionary(dict["southWest"] as! NSDictionary);
        
        return BoundingBox(northEast: northEast, southWest: southWest)
    }
    
    public static func fromArray(_ bounds: Array<Double>) -> BoundingBox {
        let bottomLeft: NSDictionary = [
            "longitude": bounds[0],
            "latitude": bounds[1]
        ]
        
        let topRight: NSDictionary = [
            "longitude": bounds[2],
            "latitude": bounds[3]
        ]

        let northEast = Coordinates.fromDictionary(topRight);
        let southWest = Coordinates.fromDictionary(bottomLeft);
        
        return BoundingBox(northEast: northEast, southWest: southWest)
    }
    
    public func toJSONArray() -> Any {
         do {
             return [self.southWest.longitude,self.southWest.latitude,self.northEast.longitude,self.northEast.latitude]
        } catch {
            return []
        }
    }
    
    public override func toJSONObject() -> Any {
        return [
            "northEast": self.northEast.toJSONObject(),
            "southWest": self.southWest.toJSONObject(),
        ]
    }
    
    public func toUrlParameter () -> String {
        do {
            let dict = [
                "_northEast": [
                    "lat": self.northEast.latitude,
                    "lng": self.northEast.longitude
                ],
                "_southWest": [
                    "lat": self.southWest.latitude,
                    "lng": self.southWest.longitude
                ],
            ]
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
            
            return String(data: jsonData, encoding: String.Encoding.ascii) ?? ""
        } catch {
            return ""
        }
    }
}

public class OfflineOptions: JSON{
    public let enable: Bool
    public let tiles: String
    public let blacklist: Array<Int>
    
    public init(enable: Bool, tiles: String, blacklist: Array<Int>) {
        self.enable = enable
        self.tiles = tiles
        self.blacklist = blacklist
    }
    
    public static func fromDictionary(_ dict: NSDictionary) -> OfflineOptions {
        let enable = dict["enable"] as! Bool
        let tiles = dict["tiles"] as! String
        let blacklist = dict["blacklist"] as! Array<Int>
        
        return OfflineOptions(enable: enable, tiles: tiles, blacklist: blacklist)
    }
    
    public override func toJSONObject() -> Any {
        return [
            "enable": self.enable,
            "tiles": self.tiles,
            "blacklist": self.blacklist
        ] as [String : Any]
    }
    
    public func toUrlParameter () -> String {
        do {
            let dict = [
                "enable": self.enable,
                "tiles": self.tiles,
                "blacklist": self.blacklist
            ] as [String : Any]
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
            
            return String(data: jsonData, encoding: String.Encoding.ascii) ?? ""
        } catch {
            return ""
        }
    }

}

public class MapMoved: JSON {
    public let zoom: Double?;
    public let bounds: BoundingBox?;
    public let latitude: Double?;
    public let longitude: Double?;

    /// - Parameters:
    ///   - zoom: Double
    ///   - bounds: BoundingBox
    ///   - latitude: Double
    ///   - longitude: Double
    public init(zoom: Double? = nil,
                bounds: BoundingBox? = nil,
                latitude: Double? = nil,
                longitude: Double? = nil) {
        self.zoom = zoom
        self.bounds = bounds
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public static func fromDictionary(_ dict: NSDictionary) -> MapMoved {
        let zoom = dict["zoom"] as? Double;
        let bounds = BoundingBox.fromDictionary(dict["bounds"] as! NSDictionary);
        let latitude = dict["latitude"] as? Double;
        let longitude = dict["longitude"] as? Double;
        
        return MapMoved(
            zoom: zoom,
            bounds: bounds,
            latitude: latitude,
            longitude: longitude
        )
    }
    
    public override func toJSONObject() -> Any {
        return [
            "zoom": self.zoom as Any,
            "bounds": (self.bounds?.toJSONObject()) as Any,
            "latitude": self.latitude as Any,
            "longitude": self.longitude as Any,
        ]
    }
}

public class ContentUpdatedQuery: JSON {
    public let query: String?;
    public let tags: [String]?;
    public let bounds: BoundingBox?;
    public let minAltitude: Int?;
    public let maxAltitude: Int?;
    
    init(query: String? = nil,
         tags: [String]? = nil,
         bounds: BoundingBox? = nil,
         minAltitude: Int? = nil,
         maxAltitude: Int? = nil) {
        self.query = query
        self.tags = tags
        self.bounds = bounds
        self.minAltitude = minAltitude
        self.maxAltitude = maxAltitude
    }
    
    public static func fromDictionary(_ dict: NSDictionary) -> ContentUpdatedQuery {
        let query = dict["query"] as? String;
        let tags = dict["tags"] as? [String];
        let bounds = BoundingBox.fromDictionary(dict["bounds"] as! NSDictionary);
        let minAltitude = dict["minAltitude"] as? Int;
        let maxAltitude = dict["maxAltitude"] as? Int;
        
        return ContentUpdatedQuery(
            query: query,
            tags: tags,
            bounds: bounds,
            minAltitude: minAltitude,
            maxAltitude: maxAltitude
        )
    }
    
    public override func toJSONObject() -> Any {
        return [
            "query": self.query as Any,
            "tags": self.tags as Any,
            "bounds": (self.bounds?.toJSONObject()) as Any,
            "minAltitude": self.minAltitude as Any,
            "maxAltitude": self.maxAltitude as Any
        ]
    }
}

public class IntroCardParameter: JSON {
    let active: Bool?;

    /// - Parameters:
    ///   - active: Bool
    public init(active: Bool? = nil) {
        self.active = active
    }
    
    public static func fromDictionary(_ dict: NSDictionary) -> IntroCardParameter {
        let active = dict["active"] as? Bool
        
        return IntroCardParameter(active: active)
    }
    
    public override func toJSONObject() -> Any {
        return [
            "active": self.active as Any
        ]
    }
}

public class PolylineOptions: JSON {
    public let color: String?;
    public let opacity: Float?;
    public let width: Float?;
    public let useNetwork: Bool?;
    
    init(color: String? = nil,
         opacity: Float? = nil,
         width: Float? = nil,
         useNetwork: Bool? = nil
    ) {
        self.color = color
        self.opacity = opacity
        self.width = width
        self.useNetwork = useNetwork
    }
    
    public static func fromDictionary(_ dict: NSDictionary) -> PolylineOptions {
        let color = dict["color"] as? String
        let opacity = dict["opacity"] as? Float;
        let width = dict["width"] as? Float;
        let useNetwork = dict["useNetwork"] as? Bool;
        
        return PolylineOptions(
            color: color,
            opacity: opacity,
            width: width,
            useNetwork: useNetwork
        )
    }
    
    public override func toJSONObject() -> Any {
        var optionsDict: [String: Any] = [String: Any]()
        
        if(self.color != nil) { optionsDict["color"] = self.color }
        if(self.opacity != nil) { optionsDict["opacity"] = self.opacity }
        if(self.width != nil) { optionsDict["width"] = self.width }
        if(self.useNetwork != nil) { optionsDict["useNetwork"] = self.useNetwork }

        return optionsDict
    }
}

/// Create a Wemap Pinpoint
public class WemapPinpoint: JSON {
    public let data: NSDictionary;
    public let id: Int;
    public let longitude: Double;
    public let latitude: Double;
    public let name: String;
    public let pinpointDescription: String
    public let external_data: NSDictionary?;
    public let image_url: String?;
    public let media_url: String?;
    public let media_type: String?;
    public let geo_entity_shape: NSDictionary?;
    public let tags: [String]?;

    /// - Parameter json: { id, longitude, latitude, name, description, external_data }
    public init(_ json: NSDictionary) {
        self.data = json
        self.id = json["id"] as! Int
        self.longitude = json["longitude"] as! Double
        self.latitude = json["latitude"] as! Double
        self.name = json["name"] as! String
        self.pinpointDescription = json["description"] as! String
        if let external_data = json["external_data"] {
            self.external_data = external_data as? NSDictionary
        } else {
            self.external_data = nil
        }
        self.image_url = json["image_url"] as? String
        self.media_url = json["media_url"] as? String
        self.media_type = json["media_type"] as? String
        self.geo_entity_shape = json["geo_entity_shape"] as? NSDictionary
        self.tags = json["tags"] as? [String]
    }
    
    // TODO: init it without dictionary and uncomment this method
//    public static func fromDictionary(_ dict: NSDictionary) -> WemapPinpoint {
//        let id = dict["id"] as! Int
//        let longitude = dict["longitude"] as! Double;
//        let latitude = dict["latitude"] as! Float;
//        let name = dict["name"] as! String;
//        let description = dict["description"] as! String;
//        let external_data = dict["external_data"] as? NSDictionary;
//
//        return WemapPinpoint(
//            id: id,
//            longitude: longitude,
//            latitude: latitude,
//            name: name,
//            description: description,
//            external_data: external_data
//        )
//    }
    
    public override func toJSONObject() -> Any {
        return [
            "id": self.id,
            "longitude": self.longitude,
            "latitude": self.latitude,
            "name": self.name,
            "description": self.pinpointDescription,
            "external_data": self.external_data as Any,
            "image_url": self.image_url as Any,
            "media_url": self.media_url as Any,
            "media_type": self.media_type as Any,
            "geo_entity_shape": self.geo_entity_shape as Any,
            "tags": self.tags as Any
        ]
    }
}

/// Create a Wemap Event
public class WemapEvent: JSON {
    public let id: Int;
    public let name: String;
    public let eventDescription: String;
    public let pinpoint: WemapPinpoint?;
    public let external_data: NSDictionary?

    /// - Parameter json: { id, name, description, external_data }
    public init(_ json: NSDictionary) {
        self.id = json["id"] as! Int
        self.name = json["name"] as! String
        self.eventDescription = json["description"] as! String
        if let jsonPinpoint = json["point"] as? NSDictionary {
            self.pinpoint = WemapPinpoint(jsonPinpoint)
        } else {
            self.pinpoint = nil
        }
        if let external_data = json["external_data"] {
            self.external_data = external_data as? NSDictionary
        } else {
            self.external_data = nil
        }
    }
  
    // TODO: init it without dictionary and uncomment this method
//    public static func fromDictionary(_ dict: NSDictionary) -> PolylineOptions {
//        let id = dict["id"] as! Int
//        let name = dict["name"] as? String;
//        let description = dict["description"] as! String;
//        let pinpoint = WemapPinpoint(dict["pinpoint"] as! NSDictionary);
//        let external_data = dict["NSDictionary"] as? NSDictionary;
//
//        return WemapEvent(
//            id: id,
//            name: name,
//            description: description,
//            pinpoint: pinpoint,
//            external_data: external_data
//        )
//    }
    
    public override func toJSONObject() -> Any {
        return [
            "id": self.id,
            "name": self.name,
            "description": self.eventDescription,
            "pinpoint": self.pinpoint?.toJSONObject() as Any,
            "external_data": self.external_data as Any
        ]
    }
}

public class Attitude: JSON {
    let quaternion: [Float];

    public init(quaternion: [Float]) {
        self.quaternion = quaternion
    }
    
    public static func fromArray(_ array: [Float]) -> Attitude {
        return Attitude(quaternion: array )
    }
    
    internal override func toJSONObject() -> Any {
        return self.quaternion
    }
}

public class Marker: JSON {
    public let coordinates: Coordinates
    public let img: String
    public let label: String?
    
    public init(coordinates: Coordinates,
                img: String,
                label: String? = nil)
    {
        self.coordinates = coordinates
        self.img = img
        self.label = label
    }
    
    public static func fromDictionary(_ dict: NSDictionary) -> Marker {
        let coordinates = Coordinates.fromDictionary(dict["coordinates"] as! NSDictionary)
        let img = dict["img"] as! String
        let label = dict["label"] as? String

        return Marker(coordinates: coordinates, img: img, label: label)
    }
    
    public override func toJSONObject() -> Any {
        return [
            "coordinates": self.coordinates.toJSONObject(),
            "img": self.img,
            "label": self.label as Any
        ]
    }
}
