//
//  EmotionViewController.swift
//  Sina
//
//  Created by YOUNG on 16/9/21.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit

class EmotionViewController: UIViewController {
    
    private lazy var emoCollectionView : UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: EmoticonCollectionViewLayout())
    
    private lazy var toolBar : UIToolbar = UIToolbar()
    
    private lazy var manager : EmoticonManager = EmoticonManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}
//MARK: UI
extension EmotionViewController{
    private func setupUI(){
        view.addSubview(emoCollectionView)
        view.addSubview(toolBar)
        
        emoCollectionView.backgroundColor = UIColor.whiteColor()
        toolBar.backgroundColor = UIColor.darkGrayColor()
        
        //frame  VFL
        emoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let views = ["tBar" : toolBar, "cView" : emoCollectionView]
        var cons = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tBar]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[cView]-0-[tBar]-0-|", options: [.AlignAllLeft, .AlignAllRight], metrics: nil, views: views)
        view.addConstraints(cons)
        
        //setupCollectionView
        setupCollectionView()
        //setupToolBar
        setupToolBar()
    }
}

//MARK: collectionView and toolbar
extension EmotionViewController{
    private func setupCollectionView(){
        emoCollectionView.dataSource = self
        emoCollectionView.delegate = self
        emoCollectionView.registerClass(EmotionCollectionViewCell.self, forCellWithReuseIdentifier: "collectionViewCell")
    }
    
    private func setupToolBar(){
        // 1.定义toolBar中titles
        let titles = ["最近", "默认", "emoji", "浪小花"]
        
        // 2.遍历标题,创建item
        var index = 0
        var tempItems = [UIBarButtonItem]()
        for title in titles {
            let item = UIBarButtonItem(title: title, style: .Plain, target: self, action: #selector(EmotionViewController.itemClick(_:)))
            item.tag = index
            index += 1
            
            tempItems.append(item)
            tempItems.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil))
        }
        
        // 3.设置toolBar的items数组
        tempItems.removeLast()
        toolBar.items = tempItems
        toolBar.tintColor = UIColor.orangeColor()
    }
    
    @objc private func itemClick(item : UIBarButtonItem) {
        // 1.获取点击的item的tag
        let tag = item.tag
        
        // 2.根据tag获取到当前组
        let indexPath = NSIndexPath(forItem: 0, inSection: tag)
        print(indexPath)
        // 3.滚动到对应的位置
        emoCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: true)
    }
}

//MARK: collectionView dataSource delegate
extension EmotionViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return manager.packages.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let package = manager.packages[section]
        return package.emotions.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionViewCell", forIndexPath: indexPath) as! EmotionCollectionViewCell
        
        let package = manager.packages[indexPath.section]
        cell.emoticon = package.emotions[indexPath.item]
        
        return cell
    }
    
    //delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // 1.取出点击的表情
        let package = manager.packages[indexPath.section]
        let emoticon = package.emotions[indexPath.item]
        
        // 2.将点击的表情插入最近分组中
        insertRecentlyEmoticon(emoticon)
    }
    
    private func insertRecentlyEmoticon(emoticon : Emotion) {
        // 1.如果是空白表情或者删除按钮,不需要插入
        if emoticon.isRemove || emoticon.isEmpty {
            return
        }
        
        // 2.删除一个表情
        if manager.packages.first!.emotions.contains(emoticon) { // 原来有该表情
            let index = (manager.packages.first?.emotions.indexOf(emoticon))!
            manager.packages.first?.emotions.removeAtIndex(index)
        } else { // 原来没有这个表情
            manager.packages.first?.emotions.removeAtIndex(19)
        }
        
        // 3.将emoticon插入最近分组中
        manager.packages.first?.emotions.insert(emoticon, atIndex: 0)
    }

    
    
}
//MARK: 设置collectionViewFlowlayout
class EmoticonCollectionViewLayout : UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        
        // 1.计算itemWH
        let itemWH = UIScreen.mainScreen().bounds.width / 7
        
        // 2.设置layout的属性
        itemSize = CGSize(width: itemWH, height: itemWH)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = .Horizontal
        
        // 3.设置collectionView的属性
        collectionView?.pagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        let insetMargin = (collectionView!.bounds.height - 3 * itemWH) / 2
        collectionView?.contentInset = UIEdgeInsets(top: insetMargin, left: 0, bottom: insetMargin, right: 0)
    }
}








