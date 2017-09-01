//
//  UISearchBar+Extension.swift
//  FFToolModule
//
//  Created by 郑强飞 on 16/7/9.
//  Copyright © 2017年 郑强飞. All rights reserved.
//

import UIKit

extension UISearchBar {

    convenience init(searchGifdelegate: UISearchBarDelegate, backgroundColor: UIColor, backgroundImage: UIImage) {
        self.init()
        delegate = searchGifdelegate
        placeholder = "搜索商品或企业名称"
        tintColor = UIColor.white
        barStyle = UIBarStyle.blackTranslucent
        layer.masksToBounds = true
        layer.cornerRadius = 22.0
        self.backgroundImage = backgroundImage
        for subView in subviews {
            for subView1 in subView.subviews {
                if subView1 is UITextField {
                subView1.backgroundColor = backgroundColor

                }
            }
        }
    }
}
