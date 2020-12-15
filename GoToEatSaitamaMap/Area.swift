//
//  Area.swift
//  GoToEatSaitamaMap
//
//  Created by 齋藤健悟 on 2020/12/09.
//

import Foundation

enum Area {
    case tyuo
    case omiya
    
    var fileName: String {
        switch self {
        case .tyuo:
            return "tyuo_shop_list_1206_with_coord"
        case .omiya:
            return "oomiya_shop_list_1208"
        }
    }
}
