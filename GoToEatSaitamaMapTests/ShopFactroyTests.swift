//
//  ShopFactroyTests.swift
//  GoToEatSaitamaMapTests
//
//  Created by 齋藤健悟 on 2020/12/04.
//

import XCTest
@testable import GoToEatSaitamaMap

class ShopFactoryTests: XCTestCase {

    let shopFactroy = ShopFactory()
    

    func testGetJSONText() {
        let text = shopFactroy.getJSONText(fileName: "tyuo_shop_list_1206_with_coord")
        XCTAssertNotNil(text)
    }
    
    func testShopList() {
        let shopList = shopFactroy.shopList(area: .tyuo)
        let 庄や = Shop(
            name: "日本海庄や南与野店",
            address: "さいたま市中央区鈴谷2-748-1ウエストヒルズ1Ｆ",
            phoneNumber: "048-859-9696",
            coordinate: ["35.867877", "139.629316"],
            genre: .izakaya)
        
        XCTAssertEqual(shopList.first!, 庄や)
        
        let タニタ = Shop(
            name: "ＨＯＭＥ’Ｓさいたまタニタ食堂",
            address: "さいたま市中央区上落合８－３－３２ホームズさいたま中央店 2F",
            phoneNumber: "048-851-1584",
            coordinate: ["35.899113", "139.623108"],
            genre: .others)
        XCTAssertEqual(shopList.last!, タニタ)
    }
    
    let jsonText = """
    [
      {
        "name": "日本海庄や南与野店",
        "address": "さいたま市中央区鈴谷2-748-1ウエストヒルズ1Ｆ",
        "phone_number": "048-859-9696",
        "coordinate": [
          "35.867877",
          "139.629316"
        ]
      },
      {
        "name": "日本海庄やランド・アクシス・タワー店",
        "address": "さいたま市中央区新都心11-2明治生命ﾗﾝﾄﾞｱｸｼｽﾀﾜｰ",
        "phone_number": "048-601-2969",
        "coordinate": [
          "35.893364",
          "139.632617"
        ]
      },
      {
        "name": "ＨＯＭＥ’Ｓさいたまタニタ食堂",
        "address": "さいたま市中央区上落合８－３－３２ホームズさいたま中央店 2F",
        "phone_number": "048-851-1584",
        "coordinate": [
          "35.899113",
          "139.623108"
        ]
      }
    ]
    """

}

