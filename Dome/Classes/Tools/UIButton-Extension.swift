//
//  UIButton-Extension.swift
//  03-PhotoBrowser(界面布局)
//
//  Created by 李智恒 on 16/4/28.
//  Copyright © 2016年 Zhli. All rights reserved.
//

import UIKit

extension UIButton{
  convenience init(title : String,bjcolor : UIColor,founSize : CGFloat)
  {
    self.init()
    
    setTitle(title, forState: .Normal)
    backgroundColor = bjcolor
    titleLabel?.font = UIFont.systemFontOfSize(founSize)
    
  }

}