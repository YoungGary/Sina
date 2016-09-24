//
//  PictureCollectionView.swift
//  Sina
//
//  Created by YOUNG on 16/9/13.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit
import SDWebImage

class PictureCollectionView: UICollectionView,UICollectionViewDataSource,UICollectionViewDelegate{
    
    var picUrls : [NSURL] = [NSURL](){
        didSet{
            self.reloadData()
        }
    }
    override func awakeFromNib() {
        dataSource = self
        delegate = self
    }

}

extension PictureCollectionView{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collection", forIndexPath: indexPath) as! picCollectionViewCell
        
        cell.picURL = picUrls[indexPath.item]
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //通知HomeVc 去弹出控制器
        let userInfo = ["indexPath" : indexPath , "picUrls" : picUrls]
        NSNotificationCenter.defaultCenter().postNotificationName("openImageBrowerControllerNoti", object: self, userInfo: userInfo)
    }
    
}


class picCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    
    var picURL : NSURL? {
        didSet{
            guard let picURL = picURL else{
                return
            }
            iconView.sd_setImageWithURL(picURL, placeholderImage: UIImage(named:"empty_picture"))
        }
    }
    
    
    
}

//MARK:实现转场动画的协议
extension PictureCollectionView : AnimationPresentedDelegate {
    func startRect(indexPath: NSIndexPath) -> CGRect {
        // 1.获取cell
        let cell = self.cellForItemAtIndexPath(indexPath)!
        
        // 2.获取cell的frame
        let startFrame = self.convertRect(cell.frame, toCoordinateSpace: UIApplication.sharedApplication().keyWindow!)
        
        return startFrame
    }
    
    func endRect(indexPath: NSIndexPath) -> CGRect {
        // 1.获取该位置的image对象
        let picURL = picUrls[indexPath.item]
        let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(picURL.absoluteString)
        
        // 2.计算结束后的frame
        let w = UIScreen.mainScreen().bounds.width
        let h = w / image.size.width * image.size.height
        var y : CGFloat = 0
        if h > UIScreen.mainScreen().bounds.height {
            y = 0
        } else {
            y = (UIScreen.mainScreen().bounds.height - h) * 0.5
        }
        
        return CGRect(x: 0, y: y, width: w, height: h)
    }
    
    func imageView(indexPath: NSIndexPath) -> UIImageView {
        // 1.创建UIImageView对象
        let imageView = UIImageView()
        
        // 2.获取该位置的image对象
        let picURL = picUrls[indexPath.item]
        let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(picURL.absoluteString)
        
        // 3.设置imageView的属性
        imageView.image = image
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
}








