//
//  ZHPhotoCell.swift
//  03-PhotoBrowser(界面布局)
//
//  Created by 李智恒 on 16/4/28.
//  Copyright © 2016年 Zhli. All rights reserved.
//

import UIKit
import SDWebImage

class ZHPhotoCell: UICollectionViewCell {
    
    //懒加载imageView
     lazy var imageView : UIImageView = UIImageView()
    
    var shop : Shop?
        {
          didSet
            {
                //获取小图片url
                guard let urlString : String = shop?.q_pic_url else
                 {
                   return
                 }
                
                //去缓存中获取小图
                let smallImage  = SDWebImageManager.sharedManager().imageCache.imageFromMemoryCacheForKey(urlString)
                
                //如果缓存没有图片,直接加载本地占位图片
                if smallImage == nil
                {
                    imageView.image = UIImage(named: "empty_picture")
                }
                //根据小图设置imageViewFrame
                else
                {
                 imageView.frame = calculateFrame(smallImage)
                }
                
                //获取大图url
                guard let bigurlString : String = shop?.z_pic_url else
                {
                  return
                }
                
                //获取本地大图缓存
                let bigImage  = SDWebImageManager.sharedManager().imageCache.imageFromMemoryCacheForKey(bigurlString)
                //如果缓存没有图片,加载大图数据
                if bigImage == nil
                {
                    //设置大图
                    let bigurl : NSURL = NSURL(string: bigurlString)!
                    
                    imageView .sd_setImageWithURL(bigurl, placeholderImage: UIImage(named: "empty_picture"), options: .RetryFailed) { (image, error, imageType, url) -> Void in
                        //计算大图Frame
                        self.imageView.frame = calculateFrame(image)
                        
                    }
                    
                }
                else
                {
                    self.imageView.image = bigImage
                    
                    self.imageView.frame = calculateFrame(bigImage)
                }
                    
                
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
extension ZHPhotoCell
{
  private func setUpUI()
   {
    // 1.添加子控件
    contentView.addSubview(imageView)
   }
}