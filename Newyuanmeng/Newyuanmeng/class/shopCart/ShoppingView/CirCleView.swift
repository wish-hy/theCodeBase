//
//  CirCleView.swift
//  GLCircleScrollVeiw
//
//  Created by god、long on 15/7/3.
//  Copyright (c) 2015年 ___GL___. All rights reserved.
//

import UIKit
//import Haneke

let TimeInterval = 3.0       //全局的时间间隔

class CirCleView: UIView, UIScrollViewDelegate {
    /*********************************** Property ****************************************/
    //MARK:- Property

    var contentScrollView: UIScrollView!
    
    var imageArray: [UIImage?]! {
        //监听图片数组的变化，如果有变化立即刷新轮转图中显示的图片
        willSet(newValue) {
            self.imageArray = newValue
        }
        
        /**
        *  如果数据源改变，则需要改变scrollView、分页指示器的数量
        */
        didSet {
            self.picCount = self.imageArray.count
            
            contentScrollView.isScrollEnabled = !(self.picCount == 1)
            self.pageIndicator.frame = CGRect(x: (self.frame.size.width - 20 * CGFloat(self.picCount))/2, y: self.frame.size.height - 30, width: 20 * CGFloat(self.picCount), height: 20)
            self.pageIndicator?.numberOfPages = self.picCount
            self.setScrollViewOfImage()
        }
    }
    
    var urlImageArray: [String]! {
        willSet(newValue) {
            self.urlImageArray = newValue
        }
        
        didSet {
            //这里用了强制拆包，所以不要把urlImageArray设为nil
            for urlStr in self.urlImageArray! {
                let urlImage = URL(string: urlStr)
                if urlImage == nil { break }
                urlImageNSURLArray.append(urlImage)
            }
            self.picCount = self.urlImageNSURLArray.count
            contentScrollView.isScrollEnabled = !(self.picCount == 1)
            self.pageIndicator.frame = CGRect(x: (self.frame.size.width - 20 * CGFloat(self.picCount))/2, y: self.frame.size.height - 30, width: 20 * CGFloat(self.picCount), height: 20)
            self.pageIndicator?.numberOfPages = self.picCount
            self.setScrollViewOfImage()
        }
    }
    
    var urlImageNSURLArray:[URL?] = []

    var delegate: CirCleViewDelegate?
    
    var indexOfCurrentImage: Int!  {                // 当前显示的第几张图片
        //监听显示的第几张图片，来更新分页指示器
        didSet {
            self.pageIndicator.currentPage = indexOfCurrentImage
        }
    }
    
    var currentImageView:   UIImageView!
    var lastImageView:      UIImageView!
    var nextImageView:      UIImageView!
    
    var pageIndicator:      UIPageControl!          //页数指示器
    
    var timer:              Timer?                //计时器
    
    var picResourceType:Int! //图片来源类型，1:本地图片，2:网络图片
    var picCount:Int = 0 //图片数量
    
    /*********************************** Begin ****************************************/
    //MARK:- Begin
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, resouceType: Int) {
        self.init(frame: frame)
        
        self.picResourceType = resouceType
        
        self.imageArray = []

        // 默认显示第一张图片
        self.indexOfCurrentImage = 0
        self.setUpCircleView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /********************************** Privite Methods ***************************************/
    //MARK:- Privite Methods
    fileprivate func setUpCircleView() {
        self.contentScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        contentScrollView.contentSize = CGSize(width: self.frame.size.width * 3, height: 0)
        contentScrollView.delegate = self
        contentScrollView.bounces = false
        contentScrollView.isPagingEnabled = true
//        contentScrollView.backgroundColor = UIColor.greenColor()
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.isScrollEnabled = !(self.picCount == 1)
        self.addSubview(contentScrollView)
        
        self.currentImageView = UIImageView()
        currentImageView.frame = CGRect(x: self.frame.size.width, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        currentImageView.isUserInteractionEnabled = true
        currentImageView.contentMode = UIViewContentMode.scaleAspectFill
        currentImageView.clipsToBounds = true
        contentScrollView.addSubview(currentImageView)
        
        //添加点击事件
        let imageTap = UITapGestureRecognizer(target: self, action: Selector("imageTapAction:"))
        currentImageView.addGestureRecognizer(imageTap)
        
        self.lastImageView = UIImageView()
        lastImageView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        lastImageView.contentMode = UIViewContentMode.scaleAspectFill
        lastImageView.clipsToBounds = true
        contentScrollView.addSubview(lastImageView)
        
        self.nextImageView = UIImageView()
        nextImageView.frame = CGRect(x: self.frame.size.width * 2, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        nextImageView.contentMode = UIViewContentMode.scaleAspectFill
        nextImageView.clipsToBounds = true
        contentScrollView.addSubview(nextImageView)
        
        self.setScrollViewOfImage()
        contentScrollView.setContentOffset(CGPoint(x: self.frame.size.width, y: 0), animated: false)
        
        //设置分页指示器
        self.pageIndicator = UIPageControl(frame: CGRect(x: (self.frame.size.width - 20 * CGFloat(self.picCount))/2, y: self.frame.size.height - 30, width: 20 * CGFloat(self.picCount), height: 20))
        pageIndicator.hidesForSinglePage = true
        pageIndicator.numberOfPages = self.picCount
        pageIndicator.backgroundColor = UIColor.clear
        self.addSubview(pageIndicator)
        
        //设置计时器
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval, target: self, selector: "timerAction", userInfo: nil, repeats: true)
    }
    
    //MARK: 设置图片
    fileprivate func setScrollViewOfImage(){
        if picResourceType == 1 {
            if self.imageArray.isEmpty {
                return
            }
            self.currentImageView.image = self.imageArray[self.indexOfCurrentImage]
            self.nextImageView.image = self.imageArray[self.getNextImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)]
            self.lastImageView.image = self.imageArray[self.getLastImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)]
        }else if picResourceType == 2 {
            if self.urlImageNSURLArray.isEmpty {
                return
            }
            self.currentImageView.hnk_setImageFromURL(URL: urlImageNSURLArray[self.indexOfCurrentImage]! as NSURL)
            self.nextImageView.hnk_setImageFromURL(URL: urlImageNSURLArray[self.getNextImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)]! as NSURL)
            self.lastImageView.hnk_setImageFromURL(URL: urlImageNSURLArray[self.getLastImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)]! as NSURL)
        }
    }
    
    // 得到上一张图片的下标
    fileprivate func getLastImageIndex(indexOfCurrentImage index: Int) -> Int{
        let tempIndex = index - 1
        if tempIndex == -1 {
            return self.picCount - 1
        }else{
            return tempIndex
        }
    }
    
    // 得到下一张图片的下标
    fileprivate func getNextImageIndex(indexOfCurrentImage index: Int) -> Int
    {
        let tempIndex = index + 1
        return tempIndex < self.picCount ? tempIndex : 0
    }
    
    //事件触发方法
    func timerAction() {
//        print("timer", terminator: "")
        contentScrollView.setContentOffset(CGPoint(x: self.frame.size.width*2, y: 0), animated: true)
    }

    
    /********************************** Public Methods  ***************************************/
    //MARK:- Public Methods
    func imageTapAction(_ tap: UITapGestureRecognizer){
        self.delegate?.clickCurrentImage!(indexOfCurrentImage)
    }
    
    
    /********************************** Delegate Methods ***************************************/
    //MARK:- Delegate Methods
    //MARK: UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.invalidate()
        timer = nil
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //如果用户手动拖动到了一个整数页的位置就不会发生滑动了 所以需要判断手动调用滑动停止滑动方法
        if !decelerate {
            self.scrollViewDidEndDecelerating(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let offset = scrollView.contentOffset.x
        if offset == 0 {
            self.indexOfCurrentImage = self.getLastImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)
        }else if offset == self.frame.size.width * 2 {
            self.indexOfCurrentImage = self.getNextImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)
        }
        // 重新布局图片
        self.setScrollViewOfImage()
        //布局后把contentOffset设为中间
        scrollView.setContentOffset(CGPoint(x: self.frame.size.width, y: 0), animated: false)
        
        //重置计时器
        if timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval, target: self, selector: "timerAction", userInfo: nil, repeats: true)
        }
    }
    
    //时间触发器 设置滑动时动画true，会触发的方法
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        print("animator", terminator: "")
        self.scrollViewDidEndDecelerating(contentScrollView)
    }

}

/********************************** Protocol Methods ***************************************/
//MARK:- Protocol Methods 


@objc protocol CirCleViewDelegate {
    /**
    *  点击图片的代理方法
    *  
    *  @para  currentIndxe 当前点击图片的下标
    */
    @objc optional func clickCurrentImage(_ currentIndxe: Int)
}










