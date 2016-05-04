//
//  ZHPhotoFlowLayout.swift
//  03-PhotoBrowser(界面布局)
//
//  Created by 李智恒 on 16/4/28.
//  Copyright © 2016年 Zhli. All rights reserved.
//

import UIKit

class ZHPhotoFlowLayout: UICollectionViewFlowLayout {

    override func prepareLayout() {
        //设置collectionView的尺寸
        itemSize = (collectionView?.bounds.size)!
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = .Horizontal
        
        //设置collectionView的属性
        collectionView?.pagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        
    }
}

