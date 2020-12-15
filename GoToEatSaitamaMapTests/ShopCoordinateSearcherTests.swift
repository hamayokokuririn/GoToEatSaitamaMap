//
//  ShopCoordinateSearcherTests.swift
//  GoToEatSaitamaMapTests
//
//  Created by 齋藤健悟 on 2020/12/08.
//

import XCTest
@testable import GoToEatSaitamaMap

class ShopCoordinateSearcherTests: XCTestCase {
    
    let 庄や = Shop(
        name: "日本海庄や南与野店",
        address: "さいたま市中央区鈴谷2-748-1ウエストヒルズ1Ｆ",
        phoneNumber: "048-859-9696",
        coordinate: [],
        genre: .izakaya)
    
    let タニタ = Shop(
        name: "ＨＯＭＥ’Ｓさいたまタニタ食堂",
        address: "さいたま市中央区上落合８－３－３２",
        phoneNumber: "048-851-1584",
        coordinate: [],
        genre: .others)
    
    func testSearch() {
        let searcher = ShopCoordinateSearcher()
        let shopList = [庄や, タニタ]
        let expect = expectation(description: "search")
        searcher.searchCoord(shopList: shopList) {
            expect.fulfill()
            XCTAssertFalse($0.isEmpty)
            XCTAssertEqual($0.count, 2)
            XCTAssertEqual($0[0].coordinate.count, 2)
            XCTAssertEqual($0[1].coordinate.count, 2)
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}
