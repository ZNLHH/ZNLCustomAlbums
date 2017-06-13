//
//  ZNLClipView.swift
//  ZNLCustomAlbums
//
//  Created by 正能量 on 2017/6/11.
//  Copyright © 2017年 ZNL. All rights reserved.
//

import UIKit

enum ZNLClipType : Int {
    case ZNLClipTypeRect
    case ZNLClipTypeArc
}

class ZNLClipView: UIView {

    var clipType : ZNLClipType?
    var clipRect : CGRect?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    


    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        if clipType == ZNLClipType.ZNLClipTypeArc {
            context?.addEllipse(in: clipRect!)
            
        }else {
            context?.addRect(clipRect!)
        }
        context?.addRect(rect)
        
        UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4).setFill()
        
        context?.drawPath(using: .eoFill)

    }
    
    func clipRect(rect: CGRect, type: ZNLClipType) {
        clipType = type
        clipRect = rect
        self.setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
