//
//  ShopCoordinateManager.swift
//  GoToEatSaitamaMap
//
//  Created by 齋藤健悟 on 2020/12/08.
//

import Foundation
import CoreLocation

class ShopCoordinateSearcher {
    private let loader = CoordinateLoader()
    private var shopList = [Shop]()
    private var index = 0
    private var finishedAction: (([Shop]) -> Void)? = nil
    
    func searchCoord(shopList: [Shop], finishedAction: @escaping ([Shop]) -> Void) {
        self.finishedAction = finishedAction
        self.shopList = shopList
        index = 0
        get(shop: shopList[index])
    }
    
    private func get(shop: Shop) {
        self.loader.getCoord(with: shop.address) { (coord, error) in
            if let error = error {
                print(shop.name)
                print(error.localizedDescription)
            }
            if let coord = coord {
                print(shop.name)
                let newShop = Shop(name: shop.name,
                                   address: shop.address,
                                   phoneNumber: shop.phoneNumber,
                                   coordinate: [
                                    coord.latitude.description,
                                    coord.longitude.description],
                                   genre: shop.genre)
                self.shopList[self.index] = newShop
            }
            self.next()
        }
    }
    
    private func next() {
        Thread.sleep(forTimeInterval: 1)
        index += 1
        if shopList.indices.contains(index) {
            get(shop: shopList[index])
        } else {
            finishedAction?(shopList)
        }
    }
}
