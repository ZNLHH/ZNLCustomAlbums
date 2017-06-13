//
//  ZNLCollectionViewCell.swift
//  ZNLCustomAlbums
//
//  Created by 正能量 on 2017/6/11.
//  Copyright © 2017年 ZNL. All rights reserved.
//

import UIKit
import Photos

class ZNLCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView.init()
    
    static func initCollectionViewWithCell(collectionView: UICollectionView, indexPath: IndexPath) -> ZNLCollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ZNLCollectionViewCell.self), for: indexPath) as UICollectionViewCell!
        if cell == nil {
            cell = UICollectionViewCell.init(frame: .zero)
        }
        return cell as! ZNLCollectionViewCell
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    
    var model: ZNLAblumsModel? {
        didSet {
            ZNLPhotoManager.manager.requestImageForAsset(asset: model!.asset, size: contentView.bounds.size, resizeModel: .fast) { (image, info) in
                self.imageView.image = image
            }
        }
    }
    
    func setupUI() {

        imageView.frame = contentView.frame
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.red
        contentView.addSubview(imageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
