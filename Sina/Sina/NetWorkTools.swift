//
//  NetWorkTools.swift
//  封装AFN网络请求
//
//  Created by YOUNG on 16/9/8.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit

import AFNetworking

enum requestType : String {
    case GET  = "GET"
    case POST  = "POST"
}

class NetWorkTools: AFHTTPSessionManager {
   
    static let shareInstance : NetWorkTools = {
        let tools = NetWorkTools()
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return tools
    }()
    
    func request(type : requestType, url : String , parameters : [String:AnyObject] ,finished : (result : AnyObject? , error : NSError?)->()) {
        if type == .GET {
            GET(url, parameters: parameters, progress: nil, success: { (task : NSURLSessionDataTask, result : AnyObject?) in
                finished(result: result, error: nil)
                }, failure: {(task : NSURLSessionDataTask?, error : NSError) in
                  finished(result: nil, error: error)
            })
        }else{
            POST(url, parameters: parameters, progress: nil, success: { (task : NSURLSessionDataTask, result : AnyObject?) in
                finished(result: result, error: nil)
                }, failure: {(task : NSURLSessionDataTask?, error : NSError) in
                    finished(result: nil, error: error)
            })
        }
    }
    
}

extension NetWorkTools{
    func loadUserInfo(access_token : String,uid : String,finished : (result:[String : AnyObject]?,error : NSError?)->()) {
        let url = "https://api.weibo.com/2/users/show.json"
        let params = ["access_token" : access_token,"uid" : uid]
        request(.GET, url: url, parameters: params) { (result, error) in
            finished(result: result as? [String : AnyObject], error: error)
        }
    }
}

extension NetWorkTools  {//待图片发微博
    func sendStatusWithPic(text : String , image : UIImage, isSuccess : (isSuccess : Bool)->())  {
            let url = "https://api.weibo.com/2/statuses/upload.json"
            let params = ["access_token" : (UserAccountViewModel.sharedInstance.account?.access_token)!,"status" : text]
        
       
            POST(url, parameters: params, constructingBodyWithBlock: { (formData) in
                if let imageData = UIImageJPEGRepresentation(image, 0.5) {
                    formData.appendPartWithFileData(imageData, name: "pic", fileName: "123.png", mimeType: "image/png")
                }
                }, progress: nil, success: { (_, _) in
                    isSuccess(isSuccess: true)
                }) { (_, error) in
                    print(error)
            }
        
    }
}











