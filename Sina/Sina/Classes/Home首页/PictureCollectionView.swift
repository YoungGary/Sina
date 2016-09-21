//
//  PictureCollectionView.swift
//  Sina
//
//  Created by YOUNG on 16/9/13.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit

class PictureCollectionView: UICollectionView,UICollectionViewDataSource{
    
    var picUrls : [NSURL] = [NSURL](){
        didSet{
            self.reloadData()
        }
    }
    override func awakeFromNib() {
        dataSource = self
        
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










