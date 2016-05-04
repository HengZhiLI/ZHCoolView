//
//  ViewController.swift
//  Dome
//
//  Created by 李智恒 on 16/5/4.
//  Copyright © 2016年 Zhli. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置图片浏览器每行显示几列数据
        ZHHomeView.shareInstance.column = 3
        //设置图片浏览器每个Cell之间的行和列间距
        ZHHomeView.shareInstance.space = 5
        //设置网络请求URL(字符串类型)
//        ZHHomeView.shareInstance.url = ""
        //设置网络请求参数(字典类型)
//        ZHHomeView.shareInstance.parameters = []
        //设置网络请求方式(枚举类型)
//          ZHHomeView.shareInstance.requestType = RequestType.GET
        //创建图片浏览器,加进View中
        collView.addSubview(ZHHomeView.shareInstance)
        
    }
    
    override func viewDidLayoutSubviews() {
        //设置图片浏览器的Frame
        ZHHomeView.shareInstance.frame = collView.bounds
    }

}

