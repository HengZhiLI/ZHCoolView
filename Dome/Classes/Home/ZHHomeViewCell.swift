//
//  ZHHomeViewCell.swift
//  03-PhotoBrowser(界面布局)
//
//  Created by 李智恒 on 16/4/28.
//  Copyright © 2016年 Zhli. All rights reserved.
//

import UIKit
import SDWebImage

class ZHHomeViewCell: UICollectionViewCell {
   
    //懒加载imageView
    lazy var imageView : UIImageView = UIImageView()
    
    var shop : Shop?
        {
          didSet{
            
            //1.nil值校验
            guard let urlString = shop?.q_pic_url else
            {
               return
            }
            
            //2.获取URL
            
           let url = NSURL(string: urlString)
            
            //3.设置图片
            
            imageView .sd_setImageWithURL(url, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
//设置UI界面相关
extension ZHHomeViewCell
{
    private func setUpUI()
    {
        //获取View的尺寸属性
        //获取View的Frame
        let frame  = ZHHomeView.shareInstance.frame
        //获取View中每行几列Cell
        let column = ZHHomeView.shareInstance.column
        //获取View中Cell之间的间距
        let space  = ZHHomeView.shareInstance.space
        
        //设置图片对象的位置和尺寸
        let imageViewX : CGFloat = 0.0
        let imageViewY : CGFloat = 0.0
        let imageViewWH : CGFloat = (frame.width - (column + 1) * space) / column
        
        //设置imageView的Frame
        imageView.frame = CGRect(x: imageViewX, y: imageViewY, width: imageViewWH, height: imageViewWH)
        
        // 1.添加子控件
        contentView.addSubview(imageView)
    }
}