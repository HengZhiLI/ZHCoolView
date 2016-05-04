//
//  ZHPhotoViewController.swift
//  03-PhotoBrowser(界面布局)
//
//  Created by 李智恒 on 16/4/28.
//  Copyright © 2016年 Zhli. All rights reserved.
//

import UIKit

//定义协议

protocol ZHVearNBProtocol : class
{
    func ZHLastCount()
}

class ZHPhotoViewController: UIViewController {
    
    //定义属性
    var PhotoCell : String = "PhotoCell"
    var indexPath : NSIndexPath?
    var shops : [Shop]?
    
    //定义协议属性
    weak var zhvearnbDelegate : ZHVearNBProtocol?
    
    //懒加载控件
    private lazy var Collecttion : UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: ZHPhotoFlowLayout())
    private lazy var CloseBtn : UIButton = UIButton(title: "关闭", bjcolor: UIColor.grayColor(), founSize: 14.0)
    private lazy var SaveBtn : UIButton = UIButton(title: "保存", bjcolor: UIColor.grayColor(), founSize: 14.0)
    
    override func loadView() {
        super.loadView()
        
        //设置Cell之间的间距
        view.frame.size.width += 15
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       //设置UI界面
        setUpUI()
        
        //滚到对应的Cell
        Collecttion.scrollToItemAtIndexPath(indexPath!, atScrollPosition: .Left, animated: false)
    }

}

// MARK:- 实现dimissDelegat中的方法
extension ZHPhotoViewController : DismissDelegate {
    func currentIndexPath() -> NSIndexPath {
        // 1.获取正在显示的cell
        let cell = Collecttion.visibleCells().first!
        
        // 2.获取indexPath
        return Collecttion.indexPathForCell(cell)!
    }
    
    func imageView() -> UIImageView {
        // 1.创建UIImageView对象
        let imageView = UIImageView()
        
        // 2.设置对象的图片
        // 2.1.获取正在显示的cell
        let cell = Collecttion.visibleCells().first as! ZHPhotoCell
        
        // 2.2.取出图片
        imageView.image = cell.imageView.image
        
        // 3.设置imageView的属性
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
}


//设置UI界面相关
extension ZHPhotoViewController
{
   func setUpUI()
   {
     //把子控件加到控制器中
    view.addSubview(Collecttion)
    view.addSubview(CloseBtn)
    view.addSubview(SaveBtn)
    
    //设置子控件Frame
    Collecttion.frame = view.bounds
    Collecttion.dataSource = self
    Collecttion.delegate = self
    Collecttion.registerClass(ZHPhotoCell.self, forCellWithReuseIdentifier:PhotoCell)
    
    let btnW : CGFloat = 90
    let btnH : CGFloat = 32
    let btnY = UIScreen.mainScreen().bounds.height - btnH - 20
    CloseBtn.frame = CGRect(x: 20, y: btnY, width: btnW, height: btnH)
    let btnX = UIScreen.mainScreen().bounds.width - btnW - 20
    SaveBtn.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
    
    //监听按钮点击
    CloseBtn.addTarget(self, action: "CloseBtnClick", forControlEvents: .TouchUpInside)
    
    SaveBtn.addTarget(self, action: "SaveBtnClick", forControlEvents: .TouchUpInside)
    
   }
    
}
//按钮点击处理事件
extension ZHPhotoViewController
{
   @objc private func CloseBtnClick()
   {
        dismissViewControllerAnimated(true, completion: nil)
   }
    
    @objc private func SaveBtnClick()
    {
        let cell = Collecttion.visibleCells().first as! ZHPhotoCell
        
        let image = cell.imageView.image
        
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
    }
}

//实现数据源方法
extension ZHPhotoViewController :UICollectionViewDataSource,UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shops?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let Cell = Collecttion.dequeueReusableCellWithReuseIdentifier(PhotoCell, forIndexPath: indexPath) as! ZHPhotoCell
        
        //设置数据
        Cell.shop = shops?[indexPath.item]
        
        //判断当用户滑动到最后一张图片时,请求加载下一页数据
        if indexPath.item == (self.shops?.count)! - 1
        {
            zhvearnbDelegate?.ZHLastCount()
        }
        
        return Cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
         CloseBtnClick()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //刷新控件
        Collecttion.reloadData()
    }
}


