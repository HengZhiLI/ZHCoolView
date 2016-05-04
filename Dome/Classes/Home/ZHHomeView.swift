//
//  ZHHomeViewController.swift
//  03-PhotoBrowser(界面布局)
//
//  Created by 李智恒 on 16/4/27.
//  Copyright © 2016年 Zhli. All rights reserved.
//

import UIKit
///定义网络请求方式枚举
enum RequestType
{
    case GET
    case POST
}
private let CellID = "HomeCell"
class ZHHomeView: UIView {
    
    //定义单列对象
    static let shareInstance = ZHHomeView()
    
    ///向外提供的接口
    ///定义View共有多少列属性
    var column : CGFloat = 3
    ///定义View中Cell之间的间距
    var space : CGFloat = 5
    ///定义获取图片数据URL属性
    var url : String = "http://mobapi.meilishuo.com/2.0/twitter/popular.json"
    ///定义获取图片数据参数
    var parameters : [String : AnyObject] = ["offset" :30, "limit" : "30", "access_token" : "b92e0c6fd3ca919d3e7547d446d9a8c2"]
    ///定义请求方式(GET/POST)
    var requestType : RequestType = .GET
    
    ///懒加载存储数据的数据
    // 把创建图片浏览器的控制器定义成外部属性,因为需要传值给ZHPhotoViewController
    var photoBrowserVc : ZHPhotoViewController?
    
    //储存最新的Y值偏移量变量属性
    ///记录是否第一次点击属性
    var isdownoffect : Bool = false
    ///储存偏移量
    var offectY : CGFloat = 0.0
    ///储存新的偏移量属性
    var newdownoffectY : CGFloat = 0.0
    
    ///懒加载存储数据的数据
    private lazy var results : [Shop] = [Shop]()
    
    private lazy var photoBrowserAnimator = ZHPhotoBrowserAnimator()
    
    private lazy var collectionView : UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: ZHHomeViewLayout())
    
    private lazy var cell : ZHHomeViewCell = ZHHomeViewCell()

    
    override init(frame: CGRect) {
    
       super.init(frame: frame)
        
        //请求数据
        loadData(0, requestType:requestType, url: url, parameters:parameters)
        
        collectionView.registerClass(ZHHomeViewCell.self, forCellWithReuseIdentifier: CellID)
        //设置collectionView代理和数据源属性
        //        collectionView.frame = bounds
        collectionView.delegate = self
        collectionView.dataSource = self
        //把collectionView加到View中
        addSubview(collectionView)
        backgroundColor = UIColor.redColor()
        
    }

    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //设置collectionView的Frame
       collectionView.frame = bounds
    }

}

// MARK:- 实现presentDelegate中的方法
extension ZHHomeView : PresentDelegate {
    func homeRect(indexPath: NSIndexPath) -> CGRect {
        // 1.取出cell
       if let cell = (collectionView.cellForItemAtIndexPath(indexPath))
       {
        //设置单行偏移量(让用户点击的图片始终保持在可视范围内)
        setUpUniline(indexPath)
        
        // 2.将cell的frame转成cell如果是在window中坐标
        let homeFrame = collectionView.convertRect(cell.frame, toCoordinateSpace: UIApplication.sharedApplication().keyWindow!)
        return homeFrame
       }
        else
       {
         //设置多行偏移量(让用户点击的图片始终保持在可视范围内)
        return setUpMultiline(indexPath)
        
       }
    }
    
    func photoBrowserRect(indexPath: NSIndexPath) -> CGRect {
        // 1.取出cell
         let cell = (collectionView.cellForItemAtIndexPath(indexPath) as? ZHHomeViewCell)
    
        // 2.取出cell中显示的图片
        let image = cell?.imageView.image
        
        if image == nil{
        
            return  CGRectZero
        }
        else
        {
            // 3.计算image放大之后的frame
            return calculateFrame(image!)
        }
    
    }
    
    func imageView(indexPath: NSIndexPath) -> UIImageView {
        // 1.创建imageView对象
        let imageView = UIImageView()
        
        // 2.设置显示的图片
        // 2.1.取出cell
        let cell = (collectionView.cellForItemAtIndexPath(indexPath))! as! ZHHomeViewCell
        
        // 2.2.取出cell中显示的图片
        let image = cell.imageView.image
        
        // 2.3.设置图片
        imageView.image = image
        
        // 3.设置imageView的属性
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
}


//发送网络请求
extension ZHHomeView
{
    
    func loadData(offset:Int, requestType: RequestType, url: String, parameters: [String : AnyObject])
    {
        ZHNetworking.shareIntance.loadHomeData(offset,requestType: requestType,url: url, parameters: parameters) { (result, error) -> () in
        
            //1.错误校验
            if error != nil
            {
                print(error)
                return
            }
            
            //2.获取结果
            guard let resultArray = result
                else
            {
                print("获取结果不正确")
                return
            }
            
            
            //3.遍历数据
            for resultDict in resultArray
            {
                let shop = Shop(dict: resultDict)
                
                self.results.append(shop)
            }
            
            //4.刷新表格
            self.collectionView.reloadData()
        
        //5.重新赋值给ZHPhotoViewController的数组
        guard let photoBrowserVc = self.photoBrowserVc
            else
        {
            return
        }
           photoBrowserVc.shops = self.results
        
        }
    }
}

// MARK:- 自定义的函数
extension ZHHomeView  {
    /// 展示图片浏览器
    private func showPhotoBrowser(indePath : NSIndexPath) {
        // 1.创建图片浏览器的控制器
        photoBrowserVc = ZHPhotoViewController()
        
        // 2.给photoBrowserVc设置属性
        photoBrowserVc!.indexPath = indePath
        photoBrowserVc!.shops = results
        photoBrowserVc!.modalPresentationStyle = .Custom
        photoBrowserVc!.transitioningDelegate = photoBrowserAnimator
        
        photoBrowserVc!.zhvearnbDelegate = self
        
        // 3.弹出图片浏览器
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(photoBrowserVc!, animated: true, completion: nil)
        
        // 4.给photoBrowserAnimator设置值
        photoBrowserAnimator.indexPath = indePath
        photoBrowserAnimator.presentDelegate = self
        photoBrowserAnimator.dismissDelegate = photoBrowserVc
    }
}

//实现代理方法相关
extension ZHHomeView :ZHVearNBProtocol,UICollectionViewDataSource,UICollectionViewDelegate
{
    
    //设置CollectionView Cell的总数
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return results.count
    }
    
    //设置CollectionView Cell的内容
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let Cell = (collectionView.dequeueReusableCellWithReuseIdentifier(CellID, forIndexPath: indexPath) as? ZHHomeViewCell)!
        
        Cell.shop = results[indexPath.item]
        
        // 3.判断是否是最后一个cell出现在屏幕
        if indexPath.item == self.results.count - 1 {
            loadData(self.results.count, requestType:requestType, url: url, parameters:parameters)
        }
        
        return Cell
    }
    
     func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
       showPhotoBrowser(indexPath)
    }
    
    func ZHLastCount() {
        //当前用户滑动到倒数第三个Cell时(相对于 "数组" 而言),当前collectionView会加载下一页的数据
        loadData(self.results.count, requestType:requestType, url: url, parameters:parameters)
    }
    
     func scrollViewDidScroll(scrollView: UIScrollView)
     {
        //获取最新的Y值偏移量
        offectY = scrollView.contentOffset.y
        
     }
    
}

//设置偏移量相关
extension ZHHomeView
{
    //设置单行偏移量函数
    private func setUpUniline(indexPath : NSIndexPath)
   {
    //获取布局Frame
    let layout = collectionView.collectionViewLayout as! ZHHomeViewLayout
    //获取Cell的Frame
    let frame = layout.layoutAttributesForItemAtIndexPath(indexPath)?.frame
    //储存临时Cell的Frame属性
    let tempOffectY : CGFloat = (frame?.origin.y)!
    
    //判断要显示的Cell是否超出顶部
    if ((frame?.origin.y)! - offectY) < (frame?.size.height)! && ((frame?.origin.y)! - offectY) != 0
    {
        //让CollectionView向下偏移
        collectionView.contentOffset.y = (frame?.origin.y)! - ZHHomeView.shareInstance.space
    }
    //判断要显示的Cell是否在超出底部
    else if ((frame?.origin.y)! - offectY) > (frame?.size.height)! && ((frame?.origin.y)! - offectY) != 0 && ((frame?.origin.y)! - tempOffectY) > 0
    {
        //让CollectionView向上偏移
        collectionView.contentOffset.y = (frame?.origin.y)! - (ZHHomeView.shareInstance.frame.size.height) + (frame?.height)! + ZHHomeView.shareInstance.space
    }

   }

    //设置多行偏移量函数
    private func setUpMultiline(indexPath : NSIndexPath) ->CGRect
    {
        //获取布局Frame
        let layout = collectionView.collectionViewLayout as! ZHHomeViewLayout
        //获取布局Frame
        let frame = layout.layoutAttributesForItemAtIndexPath(indexPath)?.frame
        
        //计算要显示的Cell是否在屏幕显示范围内
        if (frame?.origin.y)! - offectY > 0
        {
            //要显示的Cell超出底部
            //Cell在下方
            var tempoffectY : CGFloat = 0.0 //定义变量储存Cell临时偏移量
            //判断是否第一次点击Cell
            if isdownoffect
            {    //当第一次点击Cell时,记录Cell的Frame
                tempoffectY = (frame?.origin.y)! - newdownoffectY + ZHHomeView.shareInstance.space
            }
            //获取tempoffectY保存的Frame Cell的Y值
            newdownoffectY = (frame?.origin.y)!
            
            //判断是否第一次点击
            if isdownoffect
            {
                //不是第一次点击Cell
                //让Cell向上偏移
                let maxY : CGFloat = ((frame?.origin.y)! + (frame?.size.height)! + ZHHomeView.shareInstance.space) - (ZHHomeView.shareInstance.frame.size.height)  - offectY
                
                collectionView.contentOffset.y += maxY
            }
            else
            {
                //第一次点击Cell
                //让Cell向上偏移
                let maxY : CGFloat = ((frame?.origin.y)! + (frame?.size.height)! + ZHHomeView.shareInstance.space) - (ZHHomeView.shareInstance.frame.size.height) - tempoffectY - offectY
                
                collectionView.contentOffset.y += maxY
            }
            //记录已经点击过Cell
            isdownoffect = true

        }
        else //Cell
        {
            //要显示的Cell超出顶部
            //Cell在上方
            //让Cell向下偏移
            collectionView.contentOffset.y = (frame?.origin.y)! - ZHHomeView.shareInstance.space
        }
        
        // 2.将cell的frame转成cell如果是在window中坐标
        let homeFrame = collectionView.convertRect(frame!, toCoordinateSpace: UIApplication.sharedApplication().keyWindow!)

        return homeFrame
    
    }
    
}

