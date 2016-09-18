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
private let imageMargin : CGFloat = 10

class HomeTableViewCell: UITableViewCell {
    //MARK:contentLabel的宽度的constant
    @IBOutlet weak var contentLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var collectionWidth: NSLayoutConstraint!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var collection2bottom: NSLayoutConstraint!
    @IBOutlet weak var retweed2content: NSLayoutConstraint!
    //MARK:cell中的控件
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var screenName: UILabel!
    
    @IBOutlet weak var created_at: UILabel!//time
    
    @IBOutlet weak var verifiedImage: UIImageView!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var source: UILabel!//来源
    
    @IBOutlet weak var vipImage: UIImageView!
    
    @IBOutlet weak var picCollectionView: PictureCollectionView!
    
    @IBOutlet weak var retweed_label: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    
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
            
            //处理collection的height和width
            let collectionSize = calculateCollectionSizeWithImageCount(viewModel.picUrls.count)
            collectionWidth.constant = collectionSize.width
            collectionHeight.constant = collectionSize.height
            
            //传递collectionView的数据
            picCollectionView.picUrls = viewModel.picUrls
            //转发weibo的正文
            if viewModel.status?.retweeted_status != nil {
                if let screenname = viewModel.status?.retweeted_status?.user?.screen_name, retweed_text = viewModel.status?.retweeted_status?.text {
                    retweed_label.text = "@ \(screenname) :" + retweed_text;
                }
                //设置背景
                bgView.hidden = false
                //设置constant
                retweed2content.constant = 15
            }else{
                    retweed_label.text = nil
                    bgView.hidden = true
                //设置constant
                retweed2content.constant = 0

            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //根据屏幕的宽来确定正文的宽度
        contentLabelWidth.constant = UIScreen.mainScreen().bounds.width - 2 * edgeMargin
    }
}

//处理collectionVIEW的size
extension HomeTableViewCell{
    private func calculateCollectionSizeWithImageCount(count : Int) ->CGSize{
        //计算image的宽高
        let imageWidthHeight = (UIScreen.mainScreen().bounds.width - 2 * imageMargin - 2 * edgeMargin)/3
        
        //取到collectionView 的flow layout
        let layout = picCollectionView.collectionViewLayout as! UICollectionViewFlowLayout

        //没有图
        if count == 0 {
            //constant
            collection2bottom.constant = 0
            return CGSizeZero
        }
        //constant
        collection2bottom.constant = 10
        
        //单张图要返回图片的真实宽高
        if count == 1{
            let picUrlstr = model?.picUrls.first?.absoluteString
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(picUrlstr)
            //sdwebImage默认讲下载的图片压缩了
            let imageSize = CGSize(width: image.size.width * 2, height: image.size.height * 2)
            //设置itemsize
            layout.itemSize = imageSize
            return imageSize
        }
        
        //其他count的itemsize
        layout.itemSize = CGSize(width: imageWidthHeight, height: imageWidthHeight)
        
        //4个图
        if count == 4 {
            let collectionWidthHeight = 2 * imageWidthHeight + imageMargin
            return CGSize(width: collectionWidthHeight, height: collectionWidthHeight)
        }
        
        //其他
        let rows = CGFloat((count - 1)/3 + 1)
        let viewWidth = UIScreen.mainScreen().bounds.width - 2 * edgeMargin
        let viewHeight : CGFloat = rows * imageWidthHeight + (rows - 1) * imageMargin
        return CGSize(width: viewWidth, height: viewHeight)
    }
}



















