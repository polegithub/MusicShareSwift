//
//  MsPhotoBrowseViewController.swift
//  MusicShare
//
//  Created by poleness on 15/12/18.
//  Copyright © 2015年 poleness. All rights reserved.
//

import UIKit

class MsPhotoBrowseViewController: MsBaseViewController,UIScrollViewDelegate {
    
    /// 大图图片路径
    var bigImageUrlString: String?
    var imageArray: NSArray?
    var currentIndex:Int = 0
    
    
    var scrollView:UIScrollView!
    var pageControl:UIPageControl!
    
    var indicator = UIActivityIndicatorView()
    var isOpen = true
    
    let height = kScreenHeight * 0.5
    
    
    //对外接口
    func initImageArray(array :NSArray){
        self.imageArray = array
        let count = self.imageArray?.count>0 ? self.imageArray?.count:1
        self.pageControl.numberOfPages = count!
        
        self.scrollView.contentSize = CGSizeMake(CGFloat(CGFloat(count!) * kScreenWidth), height)
        self.scrollView.pagingEnabled = true
        
        if self.imageArray != nil &&  self.imageArray?.count > 0 {
            var index:Int = 0
            
            for item in self.imageArray! {
                let initX = CGFloat(kScreenWidth * CGFloat(index))
                let imageView = UIImageView(frame: CGRectMake(initX, 0, kScreenWidth, height))
                imageView.image = item as? UIImage
                
                imageView.userInteractionEnabled = true
                imageView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
                let tap = UITapGestureRecognizer(target: self, action: "onTapImageView:")
                
                imageView.addGestureRecognizer(tap)
                
                let rotate = UIRotationGestureRecognizer(target: self, action: "onRotateImageView:")
                imageView.addGestureRecognizer(rotate)
                
                let pin = UIPinchGestureRecognizer(target: self, action: "onPinImageView:")
                imageView.addGestureRecognizer(pin)
                
                index++
                self.scrollView .addSubview(imageView)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "图片"
        self.view .backgroundColor = UIColor.blackColor()
        
        self.scrollView = UIScrollView(frame: CGRectMake(0,kScreenHeight / 2 - height / 2,kScreenWidth,height))
        self.scrollView.delegate = self
        
        self.pageControl = UIPageControl()
        self.pageControl.center = CGPointMake(kScreenWidth/2 , kScreenHeight - 50)
        
        self.view .addSubview(self.pageControl)
        self.view.addSubview(self.scrollView!)
        
        let tap = UITapGestureRecognizer(target: self, action: "onTapBackView:")
        self.view .addGestureRecognizer(tap)
        
        // indicator
        self.indicator.frame = CGRectMake((kScreenWidth - 80) / 2, (kScreenHeight - 64 - 80) / 2 , 80, 80)
        self.view.addSubview(self.indicator)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //展示动画
        self.showImage()
        
        //        self.indicator.startAnimating()
        //        self.imageView!.setImageWithURL(NSURL(string: self.bigImageUrlString!), completed: {
        //            (image, error, type, url) -> Void in
        //            self.imageView!.image = image
        //            self.indicator.stopAnimating()
        //        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 恢复原始状态
        //        self.imageView!.transform = CGAffineTransformIdentity
        
        //        if let root = self.tabBarController as? RootTabBarController {
        //            root.tabBarView?.hidden = false
    }
    
    
    func showImage(animation:Bool = true){
        
        self.pageControl.currentPage = self.currentIndex
        
        let offsetX = CGFloat(CGFloat(self.currentIndex) * kScreenWidth)
        self.scrollView .setContentOffset(CGPointMake(offsetX, 0), animated: true)
        
        self.scrollView?.transform = CGAffineTransformMakeScale(0.2, 0.2)
        UIView .animateWithDuration(0.5) { () -> Void in
            self.scrollView?.transform = CGAffineTransformMakeScale(1, 1)
        }
    }
    
    ///
    /// Event handle functions
    ///
    func onTapImageView(tap: UITapGestureRecognizer) {
        self.dismissView()
    }
    
    
    //消失
    func onTapBackView(tap:UITapGestureRecognizer){
        self.dismissView()
    }
    
    func dismissView(){
        UIView.animateWithDuration(0.5
            , animations: { () -> Void in
                self.view.alpha = 0.0
            }, completion: { (Bool) -> Void in
                self.view .removeFromSuperview()
                self.view.alpha = 1.0
        })
    }
    
    ///
    /// 旋转手势
    func onRotateImageView(rotate: UIRotationGestureRecognizer) {
        //        self.imageView!.transform = CGAffineTransformRotate(self.imageView!.transform, rotate.rotation)
        
        // 旋转完成后，必须重新设置成0，表示未旋转前
        rotate.rotation = 0
    }
    
    ///
    /// 放大或者缩小手势
    func onPinImageView(pin: UIPinchGestureRecognizer) {
        //        self.imageView!.transform = CGAffineTransformScale(self.imageView!.transform, pin.scale, pin.scale)
        
        // 放大或者缩小完成后，必须重新设置成1.0，表示未缩放前
        pin.scale = 1.0
    }
    
    
    /**
    *  Delegate
    */
    func scrollViewDidScroll(scrollView: UIScrollView) {
       let page = Int( scrollView.contentOffset.x / kScreenWidth);
        pageControl.currentPage = page as NSInteger;
    }
    
    
}
