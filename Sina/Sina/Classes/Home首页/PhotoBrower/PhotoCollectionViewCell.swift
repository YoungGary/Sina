//
//  PhotoCollectionViewCell.swift
//  Sina
//
//  Created by YOUNG on 16/9/23.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoCollectionViewCell: UICollectionViewCell {
    
    //进度条
    lazy var progressView : ProgressView = ProgressView()
    
    // MARK:- 定义属性
    var picURL : NSURL? {
        didSet {
            // 1.nil值校验
            guard let picURL = picURL else {
                return
            }
            
            // 2.取出image对象
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(picURL.absoluteString)
            
            // 3.计算imageView的frame
            let width = UIScreen.mainScreen().bounds.width
            let height = width / image.size.width * image.size.height
            var y : CGFloat = 0
            if height > UIScreen.mainScreen().bounds.height {
                y = 0
            } else {
                y = (UIScreen.mainScreen().bounds.height - height) * 0.5
            }
            imageView.frame = CGRect(x: 0, y: y, width: width, height: height)
            
            //换成大图的url
            let urlStr = picURL.absoluteString
            let bigUrlstr = urlStr.stringByReplacingOccurrencesOfString("thumbnail", withString: "bmiddle")
            let bigUrl = NSURL(string: bigUrlstr)!
            
            // 设置imagView的图片
            progressView.hidden = false
            imageView.sd_setImageWithURL(bigUrl, placeholderImage: image, options: [], progress: { (current, total) in
                self.progressView.progress = CGFloat(current)/CGFloat(total)
                }) { (_, _, _, _) in
                self.progressView.hidden = true
            }
            
            //scrollVoew contentSize
            scrollView.contentSize = CGSize(width: 0, height: height)
        }
    }

    
    lazy var scrollView : UIScrollView = UIScrollView()
    lazy var imageView : UIImageView = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension PhotoCollectionViewCell{
    private func setupUI(){
        contentView.addSubview(scrollView)
        contentView.addSubview(progressView)
        scrollView.addSubview(imageView)
        
        //frame
        scrollView.frame = contentView.bounds
        //为了解决cell之间的距离
        scrollView.bounds.size.width -= 20
        
        progressView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        let screenSize = UIScreen.mainScreen().bounds.size
        progressView.center = CGPoint(x: screenSize.width/2, y:screenSize.height/2)
        
        progressView.backgroundColor = UIColor.clearColor()
        progressView.hidden = true
    }
}














