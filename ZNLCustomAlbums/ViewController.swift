//
//  ViewController.swift
//  ZNLCustomAlbums
//
//  Created by hhgk on 2017/6/9.
//  Copyright © 2017年 ZNL. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {

    let imageView = UIImageView.init(frame: CGRect(x: (KWIDTH - 140) / 2, y: 100, width: 100, height: 100))

    override func viewDidLoad() {
        super.viewDidLoad()

        let btn = UIButton(type: .custom)
        btn.frame.size = CGSize(width: 100, height: 100)
        btn.center = view.center
        btn.setTitle("相册", for: .normal)
        btn.backgroundColor = UIColor.black
        btn.addTarget(self, action: #selector(pushAblumsVC), for: .touchUpInside)
        view.addSubview(btn)
        
        
        imageView.backgroundColor = UIColor.brown
        view.addSubview(imageView)
        
    }
    
    func pushAblumsVC() {

        let vc = ZNLAlbumsController()
        
        // 闭包返回图片
        vc.albumsClouse = { clipImage in

            self.imageView.image = clipImage
            
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

