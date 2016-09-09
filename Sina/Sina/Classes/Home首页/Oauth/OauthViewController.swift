//
//  OauthViewController.swift
//  Sina
//
//  Created by YOUNG on 16/9/8.
//  Copyright © 2016年 Young. All rights reserved.
//

//获取accessToken : webview加载授权网址,然后拦截加载 截取出code 然后通过code请求accessToken

import UIKit
import SVProgressHUD

class OauthViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        setupNaviBar()
        //加载webview
        loadWeb()
    }
}
//navibar
extension OauthViewController{
    private func setupNaviBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: #selector(OauthViewController.dismiss))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .Plain, target:self, action: #selector(OauthViewController.fill))
        title = "登录"
    }
    @objc private func dismiss(){//关闭
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func fill(){//填充
        //js
        let jscode = "document.getElementById('userId').value = '18855525365'; document.getElementById('passwd').value = 'gaoyang666';"
        webView.stringByEvaluatingJavaScriptFromString(jscode)
    }
}
//load webVIew
extension OauthViewController{
    private func loadWeb(){
        guard  let url : NSURL = NSURL(string: "https://api.weibo.com/oauth2/authorize?client_id=122711537&redirect_uri=www.baidu.com") else{
            return;
        }
        
        let request : NSURLRequest = NSURLRequest(URL: url)
        webView.loadRequest(request)
    }
}
//webview delegate
extension OauthViewController : UIWebViewDelegate{
    
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
   
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        SVProgressHUD.showErrorWithStatus("加载失败")
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        guard let url = request.URL else{
            return true
        }
        let absolute = url.absoluteString
        guard absolute.containsString("code=") else{
            return true
        }
        let result = absolute.componentsSeparatedByString("code=").last!
        
        loadAccessToken(result)
        
        return false
    }
}


extension OauthViewController{
    private func loadAccessToken(code : String){
        
        let baseurl = "https://api.weibo.com/oauth2/access_token"
        let app_key = "122711537"
        let app_secret = "adf5c65bbeb223b613997c8b1df75918"
        let redirect_uri = "http://www.baidu.com"
        let parameters = ["client_id" : app_key, "client_secret" : app_secret, "grant_type" : "authorization_code", "redirect_uri" : redirect_uri, "code" : code]
        
        NetWorkTools.shareInstance.request(.POST, url: baseurl, parameters: parameters) { (result, error) in
            if error != nil{
                print(error)
                return
            }
                //print(result)
            guard let resultDict = result else{
                print("no result")
                return
            }
            let useraccount  = UserAccount(dict: resultDict as! [String : AnyObject])
            //print(userAccount)
            //获取用户信息
            self.loadUesrInfo(useraccount)
        }
    }
     //获取用户信息
    private func loadUesrInfo(useraccount:UserAccount){
        guard let token = useraccount.access_token else{
            return
        }
        guard let u_id = useraccount.uid else{
            return
        }
        
        NetWorkTools.shareInstance.loadUserInfo(token, uid: u_id) { (result, error) in
            if error != nil{
                print (error)
                return
            }
            //print (result)
            guard let userInfoDict = result else{
                    return
            }
            useraccount.screen_name = userInfoDict["screen_name"] as? String
            useraccount.avatar_large = userInfoDict["avatar_large"] as? String
            print(useraccount)
        }
    }
}







