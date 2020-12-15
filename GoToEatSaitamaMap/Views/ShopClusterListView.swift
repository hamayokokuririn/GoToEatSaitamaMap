//
//  ShopClusterListView.swift
//  GoToEatSaitamaMap
//
//  Created by 齋藤健悟 on 2020/12/07.
//

import Foundation
import UIKit

protocol ShopClusterListViewDelegate: class {
    func didSelectShop(_ view: ShopClusterListView, shop: Shop)
}

class ShopClusterListView: UITableView {
    private let id = "cell"
    weak var listViewDelegate: ShopClusterListViewDelegate?
    
    var shopList = [Shop]() {
        didSet {
            self.reloadData()
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        dataSource = self
        delegate = self
        allowsSelection = true
        
        layer.cornerRadius = 3
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ShopClusterListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shopList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let shop = shopList[index]
        let name = shop.name
        let genre = shop.genre.rawValue
        if let cell = tableView.dequeueReusableCell(withIdentifier: id) {
            cell.textLabel?.text = name
            cell.detailTextLabel?.text = genre
            return cell
        }
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: id)
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = genre
        return cell
    }
    
}

extension ShopClusterListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        if shopList.indices.contains(index) {
            listViewDelegate?.didSelectShop(self, shop: shopList[index])
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
