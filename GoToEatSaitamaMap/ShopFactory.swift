//
//  ShopFactory.swift
//  GoToEatSaitamaMap
//
//  Created by 齋藤健悟 on 2020/12/04.
//

import Foundation

struct ShopFactory {
    func shopList(area: Area) -> [Shop] {
        let fileName = area.fileName
        let json = getJSONText(fileName: fileName).data(using: .utf8)!
        do {
            let data = try JSONDecoder().decode([Shop].self, from: json)
            return data
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func getJSONText(fileName: String) -> String {
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            fatalError("ファイルは存在しません")
        }
        guard let fileContents = try? String(contentsOf: fileURL) else {
            fatalError("ファイル読み込みエラー")
        }
        let shops = fileContents.trimmingCharacters(in: .newlines)
                
        return shops
    }
}
