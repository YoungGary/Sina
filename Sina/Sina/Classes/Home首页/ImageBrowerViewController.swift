//
//  ImageBrowerViewController.swift
//  Sina
//
//  Created by YOUNG on 16/9/23.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit
import SnapKit
//collectionView-> scrollView-> imageView
class ImageBrowerViewController: UIViewController {
    
    
    //MARK:存储属性
    var indexPath : NSIndexPath
    var picUrls : [NSURL]
    
    //创建子控件
    lazy var photoCollectionView : UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: photoBrowerFlowLayout())
    
    lazy var closeButton : UIButton = UIButton()
    lazy var saveButton : UIButton = UIButton()
    
    //override init 存储属性
    init(indexPath : NSIndexPath , picUrls : [NSURL]){
        self.indexPath = indexPath
        self.picUrls = picUrls
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        
        setupUI()
        //滚到相应的图片
        photoCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: false)
    }
    
    override func loadView() {
        super.loadView()
        view.bounds.size.width += 20
    }
}

//MARK:UI
extension ImageBrowerViewController{
    private func setupUI(){
        
        view.addSubview(photoCollectionView)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
        
        
        //frame
        photoCollectionView.frame = view.bounds
        
        closeButton.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.bottom.equalTo(-20)
            make.size.equalTo(CGSize(width: 80, height: 30))
        }
        
        saveButton.snp_makeConstraints { (make) in
            make.right.equalTo(-20)
            make.bottom.equalTo(-20)
            make.size .equalTo(CGSize(width: 80, height: 30))
        }
        
        //设置button属性
        closeButton.setTitle("关 闭", forState: .Normal)
        closeButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        closeButton.backgroundColor = UIColor.lightGrayColor()
        closeButton.addTarget(self, action: #selector(ImageBrowerViewController.didClickCloseButton), forControlEvents: .TouchUpInside)
        
        saveButton.setTitle("保 存", forState: .Normal)
        saveButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        saveButton.backgroundColor = UIColor.lightGrayColor()
        saveButton.addTarget(self, action: #selector(ImageBrowerViewController.didClickSaveButton), forControlEvents: .TouchUpInside)
        
        //collectionView
        photoCollectionView.dataSource = self
        photoCollectionView.registerClass(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "photo")
        
    }
}
//MARK:事件监听
extension ImageBrowerViewController{
    @objc private func didClickCloseButton(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    @objc private func didClickSaveButton(){
        print("save")
    }
}

extension ImageBrowerViewController : UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photo", forIndexPath: indexPath) as! PhotoCollectionViewCell
        
        cell.picURL = picUrls[indexPath.item]
        
        return cell
    }
}


class photoBrowerFlowLayout : UICollectionViewFlowLayout{
    override func prepareLayout() {
        super.prepareLayout()
        itemSize = collectionView!.frame.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .Horizontal
        
        collectionView?.pagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator  = false
        
    }
}













