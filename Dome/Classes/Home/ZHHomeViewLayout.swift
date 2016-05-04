//
//  ZHHomeCollectionViewLayout.swift
//  03-PhotoBrowser(界面布局)
//
//  Created by 李智恒 on 16/4/27.
//  Copyright © 2016年 Zhli. All rights reserved.
//

import UIKit

class ZHHomeViewLayout: UICollectionViewFlowLayout {

    override func prepareLayout() {
        
        super.prepareLayout()
        
        //获取View的Frame
        let frame  = ZHHomeView.shareInstance.frame
        //获取View中每行几列Cell
        let column = ZHHomeView.shareInstance.column
        //获取View中Cell之间的间距
        let space  = ZHHomeView.shareInstance.space
        
        let CellWH :CGFloat = (frame.width - (column + 1) * space ) / column
        
        itemSize = CGSize(width: CellWH, height: CellWH)
        
        minimumInteritemSpacing = space
        minimumLineSpacing = space
        
        collectionView?.contentInset = UIEdgeInsetsMake(space, space, space, space)
        
    }

    
}
