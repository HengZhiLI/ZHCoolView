//
//  Common.swift
//  03-PhotoBrowser(界面布局)
//
//  Created by 李智恒 on 16/4/28.
//  Copyright © 2016年 Zhli. All rights reserved.
//

import UIKit
//计算imageView尺寸
      func calculateFrame(image : UIImage)->CGRect
    {
        let imageX : CGFloat = 0
        let imageW : CGFloat = UIScreen.mainScreen().bounds.width
        let imageH : CGFloat = imageW / image.size.width * image.size.height
        let imageY : CGFloat = (UIScreen.mainScreen().bounds.height - imageH) * 0.5
        
        return CGRect(x: imageX, y: imageY, width: imageW, height: imageH)
    }

