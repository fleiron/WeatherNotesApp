
import Foundation


struct WeatherAPIResponse: Decodable {
    let location: Location
    let current: Current
    
    struct Location: Decodable {
        let name: String
        let region: String
        let country: String
    }
    
    struct Current: Decodable {
        let tempC: Double
        let condition: Condition
        
        enum CodingKeys: String, CodingKey {
            case tempC = "temp_c"
            case condition
        }
        
        struct Condition: Decodable {
            let text: String
            let icon: String
        }
    }
}
