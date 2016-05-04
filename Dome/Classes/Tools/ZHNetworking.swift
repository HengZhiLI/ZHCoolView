//
//  ZHNetworking.swift
//  04-AFNetwork的封装
//
//  Created by 李智恒 on 16/4/28.
//  Copyright © 2016年 Zhli. All rights reserved.
//

import UIKit
import AFNetworking

class ZHNetworking: AFHTTPSessionManager {

    //将ZHNetworking设置成单例
    
    static let shareIntance : ZHNetworking = {
        
        let tools = ZHNetworking()
        
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        
        return tools
        
    }()
    
    
}

//封装AFN数据请求
extension ZHNetworking
{
    func request(requestType : RequestType,urlString : String,parameters : [String : AnyObject],finished : (request : AnyObject?,error : NSError?) -> ())
    {
        if requestType == .GET
        {
             GET(urlString, parameters: parameters, progress: nil, success: { (task : NSURLSessionDataTask, result : AnyObject?) -> Void in
                
                   finished(request: result, error: nil)
                
                }, failure: { (task : NSURLSessionDataTask?, error : NSError) -> Void in
                   
                    finished(request: nil, error: error)
             })
        }
        else
        {
           POST(urlString, parameters: parameters, progress: nil, success: { (task : NSURLSessionDataTask, result : AnyObject?) -> Void in
            
                finished(request: result, error: nil)
            
            
            }, failure: {(task : NSURLSessionDataTask?, error : NSError) -> Void in
            
               finished(request: nil, error: error)
            
           })
            
        }
    }

}

//请求首页数据
extension ZHNetworking
{
    func loadHomeData(offSet : Int,requestType : RequestType, url : String,parameters :[String : AnyObject], finished : (result : [[String : AnyObject]]?, error : NSError?) -> ())
   {
    
      //3.发送数据
     request(requestType, urlString: url, parameters: parameters) { (request, error) -> () in
        
        //1.判断是否有错误
        if error != nil
        {
           finished(result: nil, error: error)
        }
        //2.校验是否为空值
        guard let request = request as? [String : AnyObject]
           else
        {
            finished(result: nil , error: NSError(domain: "Code", code: -1001, userInfo: nil))
            return
        }
        
        //3.将结果回调
        finished(result: request["data"] as? [[String : AnyObject]], error: nil)
    }
    
  }
}