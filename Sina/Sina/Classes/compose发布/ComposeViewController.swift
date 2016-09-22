//
//  ComposeViewController.swift
//  Sina
//
//  Created by YOUNG on 16/9/19.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    
    var images : [UIImage] = [UIImage]()
    
    //懒加载标题view
    lazy var titleView : TitleView = TitleView()
    //xib属性
    @IBOutlet weak var textView: ComposeTextView!
    
    @IBOutlet weak var picAddCollectionView: PictureAddCollectionView!
    
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    
    @IBOutlet weak var addPicButton: UIButton!
   
    @IBOutlet weak var collectionViewHeightCons: NSLayoutConstraint!
    
    @IBOutlet weak var emotionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        //notificaiton
        setupNotifications()
       
    }
    
    //viewdidAppear 键盘弹出来
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}

//MARK:UI相关
extension ComposeViewController{
    
    private func setupUI(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .Plain, target: self, action: #selector(ComposeViewController.didClickCancelButton))
         navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .Plain, target: self, action: #selector(ComposeViewController.didClickComposeButton))
        navigationItem.rightBarButtonItem?.enabled = false
        navigationItem.titleView = titleView
        
        //监听toolbar的图片按钮
        addPicButton.addTarget(self, action: #selector(ComposeViewController.didClickAddPictureButton), forControlEvents: .TouchUpInside)
        //监听表情键盘按钮
        emotionButton.addTarget(self, action: #selector(ComposeViewController.didClickEmotionButton), forControlEvents: .TouchUpInside)
    }
    
    private func setupNotifications(){
        //键盘frame改变的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeViewController.keyboardDidChangeFrame(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        //collectionViewcell点击button的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeViewController.openImagePickerVC), name: "openImagePickerControllerNoti", object: nil)
        //监听删除图片的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector:       #selector(ComposeViewController.removeImage), name: "deleteImageNoti", object: nil)
    }
}

//MARK:监听点击事件
extension ComposeViewController{
    //取消
    @objc private func  didClickCancelButton(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    //发送微博
    @objc private func  didClickComposeButton(){
        //获取属性字符串
        let attrStr = NSMutableAttributedString(attributedString: textView.attributedText)
        
        let range  = NSRange(location: 0, length: attrStr.length)
        
        attrStr.enumerateAttributesInRange(range, options: []) { (dict, range, _) in
            if let textAttachment =  dict["NSAttachment"] as? EmotionTextAttachment{
                attrStr.replaceCharactersInRange(range, withString: textAttachment.chs!)
            }
        }
        print(attrStr.string)
        
        
        
    }
    //通知监听
    @objc private func  keyboardDidChangeFrame(noti:NSNotification){
        /*
         Optional([UIKeyboardFrameBeginUserInfoKey: NSRect: {{0, 736}, {414, 271}}, UIKeyboardCenterEndUserInfoKey: NSPoint: {207, 600.5}, UIKeyboardBoundsUserInfoKey: NSRect: {{0, 0}, {414, 271}}, UIKeyboardFrameEndUserInfoKey: NSRect: {{0, 465}, {414, 271}}, UIKeyboardAnimationDurationUserInfoKey: 0.25, UIKeyboardCenterBeginUserInfoKey: NSPoint: {207, 871.5}, UIKeyboardAnimationCurveUserInfoKey: 7, UIKeyboardIsLocalUserInfoKey: 1])
         */
        let duration = noti.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        
        let frame = (noti.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        let y = frame.origin.y
        
        let offset = UIScreen.mainScreen().bounds.height - y
        
        bottomCons.constant = offset
        
        UIView.animateWithDuration(duration) { 
            self.view.layoutIfNeeded()
        }
    }
    //点击添加图片按钮
    @objc private func  didClickAddPictureButton(){
        textView.resignFirstResponder()
        collectionViewHeightCons.constant = UIScreen.mainScreen().bounds.height * 0.6
        UIView.animateWithDuration(0.5) {
            self.view.layoutIfNeeded()
        }
    }
    //接收到通知后打开imagePicker的方法
    @objc private func  openImagePickerVC(){
        
        textView.resignFirstResponder()
        
        if !UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            return
        }
        let picker = UIImagePickerController()
        
        picker.sourceType = .PhotoLibrary
        
        presentViewController(picker, animated: true, completion: nil)
        
        picker.delegate = self
    }
    //接收到通知后删除所选图片的方法
    @objc private func  removeImage(noti:NSNotification){
        
        guard let image = noti.object as? UIImage else{
            return
        }
        guard let index = images.indexOf(image) else{
            return
        }
        images.removeAtIndex(index)
        //赋值
        picAddCollectionView.images = images
    }
    //表情键盘按钮 切换键盘
    @objc private func didClickEmotionButton(){
        
        textView.resignFirstResponder()
        //change keyboard
        let emotion = EmotionViewController { [weak self] (emotion) in
            self?.insertEmotion(emotion)//insert
            self?.textViewDidChange((self?.textView)!)
        }
        textView.inputView = textView.inputView != nil ? nil : emotion.view
        textView.becomeFirstResponder()
    }
    //插入表情
    private func insertEmotion(emotion : Emotion){
        //空表情
        if emotion.isEmpty {
            return
        }
        //删除键
        if emotion.isRemove {
            textView.deleteBackward()
            return
        }
        //emoji
        if emotion.emojiCode != nil {
            let textRange = textView.selectedTextRange!
            textView.replaceRange(textRange, withText: emotion.emojiCode!)
            return
        }
        //普通表情 图文混排
        let attach = EmotionTextAttachment()
        
        attach.chs = emotion.chs
        attach.image = UIImage(contentsOfFile: emotion.pngPath!)
        let font = textView.font
        attach.bounds = CGRect(x: 0, y: -4, width: (font?.lineHeight)!, height: (font?.lineHeight)!)
        let attrImage = NSAttributedString(attachment: attach)
        
        let mutaAttrStr = NSMutableAttributedString(attributedString: textView.attributedText)
        
        let range = textView.selectedRange
        
        mutaAttrStr.replaceCharactersInRange(range, withAttributedString: attrImage)
        
        textView.attributedText = mutaAttrStr
        
        textView.font = font
        
        textView.selectedRange = NSRange(location: range.location + 1, length: 0)
        
    }
}

//MARK:UITextView delegate
extension ComposeViewController : UITextViewDelegate{
    func textViewDidChange(textView: UITextView) {
        self.textView.placeHolderLabel.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}

//MARK:UIImagePickerController代理
extension ComposeViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    //拿到选中的照片
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        //拿到选择的图片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        //数组
        images.append(image)
        //赋值给collectionView
        picAddCollectionView.images = images
        //dismiss vc
        picker.dismissViewControllerAnimated(true, completion: nil)
       
    }
}






















