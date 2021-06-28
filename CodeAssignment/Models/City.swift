
import Foundation
import ObjectMapper

struct City: Mappable {
    
    var aqi: Float?
    var city: String?
    
    var dict: [String: Array<[Date : Float]>] = [ : ]
    var date = Date()
    
    init?(map: Map) { }

    mutating func mapping(map: Map) {
    aqi <- map["aqi"]
    city <- map["city"]
    updateDict(map: map)
    }
}

extension City: Equatable {
  static func ==(lhs: City, rhs: City) -> Bool {
    return lhs.city == rhs.city && lhs.aqi == rhs.aqi
  }
}

extension City {
    mutating func updateDict(map: Map) {
        if let city = self.city,let aqi = self.aqi, let arr = dict[city], arr.count > 0 {
            var arrray = arr
            arrray.append([Date() : aqi])
            if let oldValue = dict.updateValue(arrray, forKey: city) {
                print("The old value of \(oldValue) was replaced with a new one.")
            }
            else {
                dict[city] = arrray
            }
        }
    }
}



