//
//  ZNLAlbumsModel.swift
//  ZNLCustomAlbums
//
//  Created by hhgk on 2017/6/9.
//  Copyright © 2017年 ZNL. All rights reserved.
//

import UIKit
import Photos

class ZNLAlbumsListModel: NSObject {

    var title: String = ""
    
    var count: Int = 0
    
    var result = PHFetchResult<PHAsset>()
    
    var headImage = PHAsset()
    
    var model = Array<ZNLAblumsModel>()
    
}

class ZNLAblumsModel: NSObject {
    
    // asser对象
    var asset = PHAsset()
    
    var isSelected : Bool = false
    
    func modelWithAsset(asset: PHAsset) -> ZNLAblumsModel {
        let model = ZNLAblumsModel.init()
        model.asset = asset
        model.isSelected = false
        return model
    }
    
}
