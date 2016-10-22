//
//  MsUIColorExtension.swift
//  MusicShare
//
//  Created by poleness on 15/12/6.
//  Copyright © 2015年 poleness. All rights reserved.
//

import UIKit

extension UIColor {
    
    /**
     全i局背景色
     
     - returns: return value description
     */
    class func msBackGroundColor() ->UIColor {
        return UIColor.colorWithHexString("eeeeee")
    }
    
    /**
     APP 基本色
     
     - returns: return value description
     */
    class func msCommonColor() ->UIColor {
        return UIColor.colorWithHexString("0091a0")
    }
    
    class func msLineColor()->UIColor {
        return UIColor.blackColor().colorWithAlphaComponent(0.15)
    }
    
    
    class func msPlaceholderColor()->UIColor {
        return UIColor.colorWithHexString("c7c7cd")
    }
    
    /**
     系统导航栏的默认蓝色
     
     - returns: return value description
     */
    class func systemNavBlue() ->UIColor {
        return UIColor.colorWithHexString("007aff")
    }
    
    class func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
        
    }
    
    
    //获取当前位置的颜色值
    class func colorOfPoint(point:CGPoint)->UIColor
    {
        var pixel:[CUnsignedChar] = [0,0,0,0]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)
        
        let context = CGBitmapContextCreate(&pixel, 1, 1, 8, 4, colorSpace, bitmapInfo.rawValue)
        
        CGContextTranslateCTM(context, -point.x, -point.y)
        
        let red:CGFloat = CGFloat(pixel[0])/255.0
        let green:CGFloat = CGFloat(pixel[1])/255.0
        let blue:CGFloat = CGFloat(pixel[2])/255.0
        let alpha:CGFloat = CGFloat(pixel[3])/255.0
        
        let color = UIColor(red:red, green: green, blue:blue, alpha:alpha)
        
        return color
    }
    
    //获取当前位置颜色对应的相反颜色：深色->白色；浅色->黑色；其他用模糊
    class func textAutoFitBackGroundColor(label:UILabel) {
//        var pixel:[CUnsignedChar] = [0,0,0,0]
        let pixel = UnsafeMutablePointer<CUnsignedChar>.alloc(4)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)
        
        let context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, bitmapInfo.rawValue)
        
        CGContextTranslateCTM(context, -label.originX() , -label.originY())

//        CGContextTranslateCTM(context, -5, 5)

        let red:CGFloat = CGFloat(pixel[0])/255.0
        let green:CGFloat = CGFloat(pixel[1])/255.0
        let blue:CGFloat = CGFloat(pixel[2])/255.0
        let alpha:CGFloat = CGFloat(pixel[3])/255.0
                
        if alpha < 0.5 {
            label.textColor = UIColor.blackColor()
        }else{
            if red<0.1 && green < 0.1 && blue < 0.1 {
                label.textColor = UIColor.whiteColor()
            }else if red > 0.9 && green > 0.9 && blue > 0.9 {
                label.textColor = UIColor.blackColor()
            }else{
                let blur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
                let blurView = UIVisualEffectView(effect: blur)
                blurView.frame = label.bounds
                label .addSubview(blurView)
            }

        }
    }
    
}