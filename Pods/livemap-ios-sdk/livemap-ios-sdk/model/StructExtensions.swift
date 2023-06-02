
// https://stackoverflow.com/questions/53367491/decode-json-string-to-class-object-swift
extension Decodable { // Codable + Decodable = Codable
    static func map(dict: NSDictionary) -> Self? {
        do {
            let decoder = JSONDecoder()
            let bodyStruct = try JSONSerialization.data(withJSONObject: dict)
            let parsedStruct = try decoder.decode(Self.self, from: bodyStruct)
            return parsedStruct
        } catch let error {
            print(error)
            return nil
        }
    }
    
    static func map(string: String) -> Self? {
        do {
            let decoder = JSONDecoder()
            let parsedStruct = try decoder.decode(Self.self, from: Data(string.utf8))
            return parsedStruct
        } catch let error {
            print(error)
            return nil
        }
    }
}

extension Encodable { // Codable + Decodable = Codable

    static func toJsonString(parsedStruct: Self) -> String? {
        do {
            let jsonData = try JSONEncoder().encode(parsedStruct)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            return jsonString
        } catch { print(error) }
        return nil
    }
    
    static func toNSDictionary(parsedStruct: Self) -> NSDictionary? {
        let jsonString = Self.toJsonString(parsedStruct: parsedStruct)
        if (jsonString == nil) {
            return nil
        }
        if let data = jsonString!.data(using: String.Encoding.utf8) {
            do {
                if let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // try to read out a string array
                    return dict as NSDictionary?
                }
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
}
