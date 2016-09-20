//
//  PictureAddCollectionView.swift
//  Sina
//
//  Created by YOUNG on 16/9/20.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit

private let PictureAddCollectionViewCell = "PictureAddCollectionViewCell"
private let margin : CGFloat = 15

class PictureAddCollectionView: UICollectionView {
    
    
    var images : [UIImage] = [UIImage](){
        didSet{
            reloadData()
        }
    }
    
    override func awakeFromNib() {
        
        self.backgroundColor = UIColor.lightGrayColor()
        
        dataSource = self
        
        //register cell
        let nib = UINib(nibName: "PicCollectionViewCell", bundle: nil)
        registerNib(nib, forCellWithReuseIdentifier: PictureAddCollectionViewCell)
        //layout
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidth = (UIScreen.mainScreen().bounds.width - 4 * margin)/3
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        contentInset = UIEdgeInsetsMake(margin, margin, 0, margin)
        
    }

}

extension PictureAddCollectionView : UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PictureAddCollectionViewCell, forIndexPath: indexPath) as! PicCollectionViewCell
        //cell.backgroundColor = UIColor.cyanColor()
        cell.image = indexPath.item <= images.count - 1 ? images[indexPath.item] : nil
        
        return cell
    }
}









