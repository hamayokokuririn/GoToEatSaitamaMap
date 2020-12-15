//
//  ShopAnnotaion.swift
//  GoToEatSaitamaMap
//
//  Created by 齋藤健悟 on 2020/12/07.
//

import Foundation
import MapKit

class ShopAnnotaion: MKPointAnnotation {
    
    init(shop: Shop) {
        super.init()
        title = shop.name
        subtitle = shop.genre.rawValue
        let coord = shop.coordinate2D
        coordinate = coord
    }
    
}

class ShopAnnotationView: MKMarkerAnnotationView {
    
    static let ReuseID = "shopAnnotaion"
    
    /// - Tag: ClusterIdentifier
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "shop"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultLow
        markerTintColor = UIColor.red
        glyphImage = UIImage(systemName: "flag.fill")
    }
}
