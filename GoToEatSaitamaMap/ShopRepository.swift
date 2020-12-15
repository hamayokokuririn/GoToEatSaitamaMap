//
//  ShopRepository.swift
//  GoToEatSaitamaMap
//
//  Created by 齋藤健悟 on 2020/12/07.
//

import Foundation

class ShopRepository {
    var shopList: [Shop]
    
    init(area: Area = .tyuo) {
        let factory = ShopFactory()
        self.shopList = factory.shopList(area: .tyuo)
    }
    
    func select(from name: String) -> Shop? {
        shopList.filter {
            $0.name == name
        }.first
    }
    
    func fetch(area: Area, finishedAction: @escaping () -> Void) {
        let factory = ShopFactory()
        let newList = factory.shopList(area: area)
        let searcher = ShopCoordinateSearcher()
        searcher.searchCoord(shopList: newList) { (withCoordList) in
            self.shopList = withCoordList
            finishedAction()
        }
    }
}
