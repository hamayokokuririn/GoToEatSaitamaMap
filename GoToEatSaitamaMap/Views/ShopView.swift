//
//  ShopView.swift
//  GoToEatSaitamaMap
//
//  Created by 齋藤健悟 on 2020/12/07.
//

import Foundation
import UIKit

class ShopView: UIView {
    let name = UILabel()
    let address = UILabel()
    let genre = UILabel()
    let expectedTravelTime = UILabel()
    
    let lightFont = UIFont.italicSystemFont(ofSize: 18)
    lazy var walkImage: UIImageView = {
        let image = UIImage(systemName: "figure.walk.circle")
        image?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(font: lightFont))
        return UIImageView(image: image)
    }()
    
    lazy var blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .light)
        return UIVisualEffectView(effect: blur)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 3
        
        blurView.clipsToBounds = true
        blurView.layer.cornerRadius = 3
        addSubview(blurView)
        
        name.font = .boldSystemFont(ofSize: 24)
        name.lineBreakMode = .byTruncatingHead
        addSubview(name)
        
        address.lineBreakMode = .byTruncatingHead
        addSubview(address)
        
        genre.lineBreakMode = .byTruncatingHead
        addSubview(genre)
        
        expectedTravelTime.font = lightFont
        addSubview(expectedTravelTime)
        
        addSubview(walkImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateLayout()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        updateLayout()
        let height = walkImage.frame.maxY + 4
        return CGSize(width: size.width, height: height)
    }
    
    func selectedShop(_ shop: Shop) {
        name.text = shop.name
        address.text = shop.address
        genre.text = "ジャンル: \(shop.genre.rawValue)"
        expectedTravelTime.text = ""
        updateLayout()
    }
    
    func updateTravelTime(_ time: TimeInterval) {
        let minutes = Int(ceil((time / 60.0)))
        expectedTravelTime.text = "\(minutes.description) 分"
        updateLayout()
    }
    
    private func updateLayout() {
        blurView.frame.size = frame.size
        
        let horizontalMargin = CGFloat(8)
        name.frame.size.width = frame.width - horizontalMargin * 2
        name.sizeToFit()
        name.frame.origin.y = 4
        name.frame.origin.x = horizontalMargin
        
        address.sizeToFit()
        address.frame.size.width = frame.width - horizontalMargin * 2
        address.frame.origin.y = name.frame.maxY
        address.frame.origin.x = horizontalMargin
        
        genre.sizeToFit()
        genre.frame.size.width = frame.width - horizontalMargin * 2
        genre.frame.origin.y = address.frame.maxY
        genre.frame.origin.x = horizontalMargin
        
        walkImage.frame.origin.y = genre.frame.maxY
        walkImage.frame.origin.x = 8
        
        expectedTravelTime.sizeToFit()
        expectedTravelTime.frame.origin.y = genre.frame.maxY
        expectedTravelTime.frame.origin.x = walkImage.frame.maxX + 4
    }
}
