//
//  HomeTableViewCell.swift
//  Sina
//
//  Created by YOUNG on 16/9/13.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit
import SDWebImage

private let edgeMargin : CGFloat = 10

class HomeTableViewCell: UITableViewCell {
    //MARK:contentLabel的宽度的constant
    @IBOutlet weak var contentLabelWidth: NSLayoutConstraint!
    //MARK:cell中的控件
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var screenName: UILabel!
    
    @IBOutlet weak var created_at: UILabel!//time
    
    @IBOutlet weak var verifiedImage: UIImageView!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var source: UILabel!//来源
    
    @IBOutlet weak var vipImage: UIImageView!
    //MARK:set model
    var model : StatusViewModel?{
        didSet{
            guard let viewModel = model else{
                return
            }
            // set icon image
            let iconUrl = NSURL(string: (viewModel.status?.user?.profile_image_url)!)
            let placeHolderImage = UIImage(named: "avatar_default_small")
            iconImage.sd_setImageWithURL(iconUrl, placeholderImage: placeHolderImage)
            //set screen name
            screenName.text = viewModel.status?.user?.screen_name
            //  set created_at
            created_at.text = viewModel.createText
            //set 认证图片
            verifiedImage.image = viewModel.verifiedImage
            //正文label
            contentLabel.text = viewModel.status?.text
            // set 来源
            source.text = viewModel.sourceText
            //vip
            vipImage.image = viewModel.vipImage
            //会员显示橙色
            screenName.textColor = viewModel.vipImage == nil ? UIColor.blackColor() : UIColor.orangeColor()
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentLabelWidth.constant = UIScreen.mainScreen().bounds.width - 2 * edgeMargin
    }

   

}





