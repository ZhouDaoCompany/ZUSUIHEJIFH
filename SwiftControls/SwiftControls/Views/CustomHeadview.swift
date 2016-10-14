//
//  CustomHeadview.swift
//  SwiftControls
//
//  Created by cqz on 16/10/13.
//  Copyright © 2016年 cqz. All rights reserved.
//


import UIKit

class CustomHeadview: UIView ,UIScrollViewDelegate {


    var timer           : TimeInterval!
    var currentIndex    : Int = 0
    var imageArrays     : [String] = ["000.jpg","001.jpg","002.jpg","003.jpg","004.jpg"]
    var scrollView      : UIScrollView!
    var previousImgView : UIImageView!
    var currentImgView  : UIImageView!
    var nextImgView     : UIImageView!

    let myTimer : String = "myTimer"
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        initUI()

    }
    // MARK: methods
    
    func initUI()  {
        
        let rect = CGRect(x: 0, y: 0, width: ViewWidth(view: self), height: ViewHeight(view: self))
        scrollView = UIScrollView(frame: rect)
        scrollView.backgroundColor = UIColor.red
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: ViewWidth(view: self) * 3, height: ViewHeight(view: self))
        scrollView.bounces = false;

         previousImgView = UIImageView(frame: rect)
        previousImgView.contentMode = UIViewContentMode.scaleAspectFill
        
        let rect1 = CGRect(x: ViewWidth(view: self), y: 0, width: ViewWidth(view: self), height: ViewHeight(view: self))
         currentImgView = UIImageView(frame: rect1)
        currentImgView.contentMode = UIViewContentMode.scaleAspectFill

        let rect2 = CGRect(x: ViewWidth(view: self) * 2, y: 0, width: ViewWidth(view: self), height: ViewHeight(view: self))
        nextImgView = UIImageView(frame: rect2)
        nextImgView.contentMode = UIViewContentMode.scaleAspectFill

        self.addSubview(self.scrollView)
        scrollView.addSubview(self.previousImgView)
        scrollView.addSubview(self.currentImgView)
        scrollView.addSubview(self.nextImgView)
        
        reloadImageView()
    }
    
    // MARK: -取值
    func reloadImageView()  {
        
        if currentIndex >= imageArrays.count {
        
            currentIndex = 0
        }
        if currentIndex < 0  {
            
            currentIndex = imageArrays.count - 1
        }
        
        var pre = currentIndex - 1
        var next = currentIndex + 1
        
        if pre < 0 {
            pre = imageArrays.count - 1
        }
        if next > imageArrays.count - 1 {
            next = 0
        }
        
        let preImage = imageArrays[pre]
        let currImage = imageArrays[currentIndex]
        let nextImage = imageArrays[next]

        previousImgView.image = UIImage(named: preImage)
        currentImgView.image = UIImage(named: currImage)
        nextImgView.image = UIImage(named: nextImage)
        
        let rect = CGRect(x: ViewWidth(view: self), y: 0, width: ViewWidth(view: self), height: ViewHeight(view: self))
        
        scrollView.scrollRectToVisible(rect, animated: false)
        startTimerPlay()
    }
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        JX_GCDTimerManager.sharedInstance().cancelTimer(withName: myTimer)
        if scrollView.contentOffset.x >= ViewWidth(view: self) * 2 {
            
            currentIndex += 1
        } else if scrollView.contentOffset.x < ViewWidth(view: self) {
           
            currentIndex -= 1
        }
        reloadImageView()
    }
    
    func startTimerPlay() {
        
        JX_GCDTimerManager.sharedInstance().scheduledDispatchTimer(withName: myTimer, timeInterval: 3, queue: nil, repeats: true, actionOption: AbandonPreviousAction) {[weak self] in
            
            self?.doTextGoDisplay()
        }
    }
    // MARK: 定时器开启轮播
    func doTextGoDisplay() {
        let rect = CGRect(x: ViewWidth(view: self) * 2, y: 0, width: ViewWidth(view: self), height: ViewHeight(view: self))
        
        scrollView.scrollRectToVisible(rect, animated: false)
        currentIndex += 1

        GCD_Delay(seconds: 0.3) { [weak self] in
   
            self?.reloadImageView()
        }
    }
    
//    override func layoutSubviews() {
//        
//        super.layoutSubviews()
//        previousImgView.frame =  CGRect(x: 0, y: 0, width: ViewWidth(view: self), height: ViewHeight(view: self))
//        currentImgView.frame = CGRect(x: ViewWidth(view: self), y: 0, width: ViewWidth(view: self), height: ViewHeight(view: self))
//        nextImgView.frame =  CGRect(x: ViewWidth(view: self), y: 0, width: ViewWidth(view: self), height: ViewHeight(view: self))
//        
//    }
    
    // MARK: setter and getter
//    private var scrollView : UIScrollView {
//        
//        let rect = CGRect(x: 0, y: 0, width: ViewWidth(view: self), height: ViewHeight(view: self))
//        let scrollView = UIScrollView(frame: rect)
//        scrollView.backgroundColor = UIColor.red
////        scrollView.showsHorizontalScrollIndicator = false
////        scrollView.showsVerticalScrollIndicator = false
//        scrollView.isPagingEnabled = true
//        scrollView.contentSize = CGSize(width: ViewWidth(view: self) * 3, height: ViewHeight(view: self))
//        
//        return scrollView
//    }
    
    
//    private var previousImgView : UIImageView {
//        
//        let rect = CGRect(x: 0, y: 0, width: ViewWidth(view: self), height: ViewHeight(view: self))
//        let previousImgView = UIImageView(frame: rect)
//        previousImgView.contentMode = UIViewContentMode.scaleAspectFit
//        
//        return previousImgView
//    }
//   private var currentImgView : UIImageView {
//        
//        let rect = CGRect(x: ViewWidth(view: self), y: 0, width: ViewWidth(view: self), height: ViewHeight(view: self))
//        let currentImgView = UIImageView(frame: rect)
//        currentImgView.contentMode = UIViewContentMode.scaleAspectFit
//        return currentImgView
//    }
//    private var nextImgView : UIImageView {
//        
//        let rect = CGRect(x: ViewWidth(view: self) * 2, y: 0, width: ViewWidth(view: self), height: ViewHeight(view: self))
//        let nextImgView = UIImageView(frame: rect)
//        nextImgView.contentMode = UIViewContentMode.scaleAspectFit
//        return nextImgView
//    }

//    var nameString : String? {
//        
//        get {
//            return self.nameString
//        }
//        set{
//            
//            self.nameString = newValue
//        }
//    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
}
