//
//  ZNLPhotoBrowserController.swift
//  ZNLCustomAlbums
//
//  Created by 正能量 on 2017/6/11.
//  Copyright © 2017年 ZNL. All rights reserved.
//

import UIKit
import Photos

let KWIDTH = UIScreen.main.bounds.width
let KHEIGHT = UIScreen.main.bounds.height

let drawRect = CGRect(x: (KWIDTH - 300) * 0.5, y: (KHEIGHT - 300) * 0.5, width: 300, height: 300)


class ZNLPhotoBrowserController: UIViewController, UIScrollViewDelegate {
    
    var imageView : UIImageView?
    let scrollerView = UIScrollView.init(frame: UIScreen.main.bounds)
    let clipView = ZNLClipView.init(frame: UIScreen.main.bounds)
    var clipType : ZNLClipType?
    
    var clipRect = CGRect()
    var img : UIImage?
    
    var imageClosure :((_ image: UIImage) -> ())?
    
    
      init(image: UIImage, type: ZNLClipType?) {
        super.init(nibName: nil, bundle: nil)
        self.clipType = type ?? ZNLClipType.ZNLClipTypeArc
        self.img = scaleImageSize(image: image)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black

        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 蒙层
        clipView.clipRect(rect: clipRect, type: clipType!)
        calculateScale()
    }
    
    
    func setupUI() {
        imageView = UIImageView.init(image: img)
        scrollerView.addSubview(imageView!)
        
        scrollerView.delegate = self
        scrollerView.backgroundColor = UIColor.black
        scrollerView.maximumZoomScale = 1.5
        scrollerView.minimumZoomScale = 0.8
        scrollerView.contentSize = (imageView?.frame.size)!
        view.addSubview(scrollerView)
        
        
        clipView.isUserInteractionEnabled = false
        clipRect = drawRect
        view.addSubview(clipView)
        
        let confirmBtn = UIButton.init(frame: CGRect(x: KWIDTH - 80, y: KHEIGHT - 40, width: 60, height: 30))
        confirmBtn.setTitle("确认", for: .normal)
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        confirmBtn.setTitleColor(UIColor.white, for: .normal)
        confirmBtn.addTarget(self, action: #selector(confirmAction(sender:)), for: .touchUpInside)
        view.addSubview(confirmBtn)
        
        let cancelBtn = UIButton.init(frame: CGRect(x: 20, y: KHEIGHT - 40, width: 60, height: 30))
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(UIColor.white, for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelBtn.addTarget(self, action: #selector(cancelAction(sender:)), for: .touchUpInside)
        view.addSubview(cancelBtn)

    }
    
    //MARK: - 缩放图片适应屏幕大小
    func scaleImageSize(image: UIImage) -> UIImage {
        
        var w = KWIDTH
        var h = image.size.height / image.size.width * w
        
        if h < KWIDTH {
            h = KWIDTH
            w = image.size.width / image.size.height * h
        }
        
        UIGraphicsBeginImageContext(CGSize(width: w, height: h))
        image.draw(in: CGRect(x: 0, y: 0, width: w, height: h))
        let currentImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return currentImage!
    }
    
    //MARK : - 计算缩放
    func calculateScale() {
        
        let top = clipRect.origin.y
        let left = clipRect.origin.x
        let bottom = KHEIGHT - top - (clipRect.size.height)
        let right = KWIDTH - left - (clipRect.size.width)
        
        
        
        if Float((imageView?.image?.size.height)!) > Float((imageView?.image?.size.width)!) {
            scrollerView.minimumZoomScale = (clipRect.width) / (imageView?.bounds.width)!
        } else {
            scrollerView.minimumZoomScale = (clipRect.height) / (imageView?.bounds.height)!
        }
        scrollerView.contentInset = UIEdgeInsetsMake(top, left, bottom, right)
        
        scrollToCenter()
    }
    
    //MARK: - 滚动到中心
    func scrollToCenter() {
        let x = ((imageView?.frame.width)! - KWIDTH) / 2
        
        let y = ((imageView?.frame.height)! - KHEIGHT) / 2
        
        scrollerView.contentOffset = CGPoint(x: x, y: y)
    }
    
    //MARK: - UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    //MARK: - 裁剪图片
    func clipImage() -> UIImage {
        
        
        let scale = (imageView?.image?.size.height)! / (imageView?.frame.size.height)!
        
        let width = clipRect.size.width * scale
        
        let height = clipRect.size.height * scale
        
        let x = (clipRect.origin.x + scrollerView.contentOffset.x) * scale
        
        let y = (clipRect.origin.y + scrollerView.contentOffset.y) * scale
        
        let image = CGImage.cropping((img?.cgImage)!)(to: CGRect(x: x, y: y, width: width, height: height))
        
        var currentImage = UIImage.init(cgImage: image!)
        
        //MARK: - 裁剪圆形图片
        if clipType == ZNLClipType.ZNLClipTypeArc {
            
            let rect = CGRect(x: 0, y: 0, width: currentImage.size.width, height: currentImage.size.height)
            
            
            let path = UIBezierPath.init(roundedRect: rect, cornerRadius: currentImage.size.width * 0.5)
            
            // 背景不透明
            UIGraphicsBeginImageContextWithOptions(currentImage.size, true, scale)
            
            // 不显示黑色背景 手动绘制白色背景
            let bgRect = UIBezierPath.init(rect: rect)
            UIColor.white.setFill()
            bgRect.fill()
            
            path.addClip()
            currentImage.draw(in: CGRect(x: 0, y: 0, width: currentImage.size.width, height: currentImage.size.height))
            currentImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()

        }
        return currentImage
    }
    
    
    //MARK: - 确认事件
    func confirmAction(sender: UIButton) {
        
            if self.imageClosure != nil {
            self.imageClosure!(self.clipImage())
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func cancelAction(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("deinit")
    }

}
