//
//  TyuoAreaTests.swift
//  GoToEatSaitamaMapTests
//
//  Created by 齋藤健悟 on 2020/12/16.
//

import XCTest
@testable import GoToEatSaitamaMap

class TyuoAreaTests: XCTestCase {
    
    func testCoordList() {
        let area = TyuoAreaBorder()
        let list = area.coordList(from: text)
        XCTAssertFalse(list.isEmpty)
        XCTAssertEqual(list.count, 3)
        
        XCTAssertEqual(list[0].latitude, 35.87807659)
        XCTAssertEqual(list[0].longitude, 139.60432438)
        
        XCTAssertEqual(list[1].latitude, 35.87813761)
        XCTAssertEqual(list[1].longitude, 139.60431195)
        
        XCTAssertEqual(list[2].latitude, 35.87856478)
        XCTAssertEqual(list[2].longitude, 139.60438659)
    }
    
    private let text = """
            35.87807659 139.60432438
            35.87813761 139.60431195
            35.87856478 139.60438659
    """
}
