//
//  PicCollectionViewCell.swift
//  Sina
//
//  Created by YOUNG on 16/9/20.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit

class PicCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var picPickerButton: UIButton!
    
    var image : UIImage?{
        didSet{
            if image != nil {
                imageView.image = image
                picPickerButton.userInteractionEnabled = false
                closeButton.hidden = false
            }else{
                imageView.image = nil
                picPickerButton.userInteractionEnabled = true
                closeButton.hidden = true
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //选择照片
        picPickerButton.addTarget(self, action: #selector(PicCollectionViewCell.didClickPicPickerButton), forControlEvents: .TouchUpInside)
        //删除照片
        closeButton.addTarget(self, action: #selector(PicCollectionViewCell.didClickCloseButton), forControlEvents: .TouchUpInside)
    }
}


extension PicCollectionViewCell{
    @objc private func didClickPicPickerButton(){
    NSNotificationCenter.defaultCenter().postNotificationName("openImagePickerControllerNoti", object: nil)
    }
    @objc private func didClickCloseButton(){
    NSNotificationCenter.defaultCenter().postNotificationName("deleteImageNoti", object: imageView.image)
    }
}















