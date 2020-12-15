//
//  Shop.swift
//  GoToEatSaitamaMap
//
//  Created by 齋藤健悟 on 2020/12/04.
//

import Foundation
import CoreLocation

struct Shop: Decodable, Equatable {
    let name: String
    let address: String
    let phoneNumber: String
    let coordinate: [String]
    let genre: Genre
    
    var coordinate2D: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(coordinate[0].description) ?? 0,
                                      longitude: CLLocationDegrees(coordinate[1].description) ?? 0)
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case address
        case phoneNumber = "phone_number"
        case coordinate
        case genre
    }
    
    enum Genre: String, Codable {
            case izakaya = "居酒屋"
            case bar = "ダイニングバー/バル"
            case japanese = "和食"
            case chinese = "中華"
            case cafe = "カフェ/スイーツ"
            case noodle = "麺類"
            case western = "洋食"
            case grilledMeat = "焼肉/ホルモン"
            case internationalCuisine = "各国料理"
            case fastfood = "ファーストフード/ファミレス"
            case others = "その他"
        }
        
}

