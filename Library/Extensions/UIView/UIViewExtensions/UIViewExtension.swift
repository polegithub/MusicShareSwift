//
//  UIViewExtension.swift
//  JokerMost
//
//  Created by huangyibiao on 14-10-9.
//  Copyright (c) 2014年 uni2uni. All rights reserved.
//

import Foundation
import UIKit

///
/// @brief UIView的扩展方法，方便工程全局使用扩展方法来创建或者使用所有继承于UIView的控件
/// @date  2014-10-09
/// @author huangyibiao
///
extension UIView {
    ///
    /// 获取或设置origin.x
    ///
    func originX() ->CGFloat {
        return self.frame.origin.x
    }
    
    func originX(let originX: CGFloat) {
        var rect = self.frame
        rect.origin.x = originX
        self.frame = rect
    }
    
    ///
    /// 获取或设置origin.y
    ///
    func originY() ->CGFloat {
        return self.frame.origin.y
    }
    
    func originY(let originY: CGFloat) {
        var rect = self.frame
        rect.origin.y = originY
        self.frame = rect
    }
    
    ///
    /// 获取或设置origin
    ///
    func origin() ->CGPoint {
        return self.frame.origin
    }
    
    func origin(let origin: CGPoint) {
        var rect = self.frame
        rect.origin = origin
        self.frame = rect
    }
    
    ///
    /// 获取或设置width
    ///
    func width() ->CGFloat {
        return self.frame.size.width
    }
    
    func width(let width: CGFloat) {
        var rect = self.frame
        rect.size.width = width
        self.frame = rect
    }
    
    ///
    /// 获取或设置height
    ///
    func height() ->CGFloat {
        return self.frame.size.height
    }
    
    func height(let height: CGFloat) {
        var rect = self.frame
        rect.size.height = height
        self.frame = rect
    }
    
    ///
    /// 获取rightX
    ///
    func rightX() ->CGFloat {
        return originX() + width()
    }
    
    ///
    /// 获取或设置bottomY
    ///
    func bottomY() ->CGFloat {
        return originY() + height()
    }
    
    func bottomY(let bottomY: CGFloat) {
        var rect = self.frame
        rect.origin.y = bottomY - height()
        self.frame = rect
    }
    
    
    /**
    * Removes all subviews.
    */
    func removeAllSubviews(){
        
        for item in self.subviews{
            if item .isKindOfClass(UIView){
                item .removeFromSuperview()
            }
        }
    }
    
    /**
    * Calculates the offset of this view from another view in screen coordinates.
    *
    * otherView should be a parent view of this view.
    */
//    func offsetFromView(let otherView:UIView) -> CGPoint{
//        var x = 0.0
//        var y = 0.0
//        
//        for (UIView *view = self; view && view != otherView; view = view.superview) {
//            x += view.left;
//            y += view.top;
//        }
//        return CGPointMake(x, y);
//    }
    
    
    //获取常用subvie
    class  func getLine(initY:CGFloat)->UIView{
        let line = UIView(frame: CGRectMake(0,initY,kScreenWidth,0.5))
        line.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.15)
        
        return line
    }
    
   
    

}
