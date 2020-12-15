//
//  CoordinateLoader.swift
//  GoToEatSaitamaMap
//
//  Created by 齋藤健悟 on 2020/12/08.
//

import Foundation
import CoreLocation

class CoordinateLoader {
    
    let coder = CLGeocoder()
    
    func getCoord(with address: String, finishedAction: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        print("getCoord \(address)")
        coder.geocodeAddressString(address) { (list: [CLPlacemark]?, error: Error?) in
            if let error = error {
                finishedAction(nil, error)
                return
            }
            if let placemark = list?.first,
               let coord = placemark.location?.coordinate {
                finishedAction(coord, nil)
            }
        }
    }
    
}
