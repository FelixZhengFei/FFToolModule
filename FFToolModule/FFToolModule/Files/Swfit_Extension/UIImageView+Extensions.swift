//
//  UIImageView+Extensions.swift
//  FliexBaseApp
//
//  Created by 郑强飞 on 2017/9/4.
//  Copyright © 2017年 郑强飞. All rights reserved.
//

import Foundation


extension UIImageView {
    
    //添加圆角 Bezier 不会导致离屏渲染
    //建议使用
    public func imageAddBezierCorner(radius: CGFloat) {
        self.image = self.image?.addImageRoundedCorner(radius: radius, self.bounds.size)
    }
    
    //添加圆角 导致离屏渲染
    public func imageAddCustumCorner(radius: CGFloat,borderColor:UIColor = UIColor.init(red: 203/255.0, green: 203/255.0, blue: 203/255.0, alpha: 1)) {
        self.layer.cornerRadius = radius
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth  = 0.5
    }
}
