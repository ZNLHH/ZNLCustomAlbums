//
//  ZNLPhotoManager.swift
//  ZNLCustomAlbums
//
//  Created by 正能量 on 2017/6/11.
//  Copyright © 2017年 ZNL. All rights reserved.
//

import UIKit
import Photos

class ZNLPhotoManager: NSObject {

   static let manager = ZNLPhotoManager()

    private override init() {
        
    }
    
    //MARK: - 获取所有相册
    func getAblums() -> Array<ZNLAlbumsListModel> {
        let options = PHFetchOptions.init()
        options.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
        
        // 获取所有智能相册
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        
        let streamAblums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumMyPhotoStream, options: nil)
        
        let syncedAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumSyncedAlbum, options: nil)
        
        let shareAblums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumCloudShared, options: nil)
        
        let arrAll = [smartAlbums,streamAblums,syncedAlbums,shareAblums]
        
        var arrAblum = Array<ZNLAlbumsListModel>()
        for (_,e) in arrAll.enumerated() {
            
            e.enumerateObjects({ (collection, indexnt, stop) in
                
                //过滤PHCollectionList对象
                if !collection.isKind(of: PHCollection.self){
                    return
                }
                
                // 过滤最近删除
                
                guard (collection.assetCollectionSubtype.rawValue) <= 212 else {
                    return
                }
                
                
                let result = PHAsset.fetchAssets(in: collection, options: options)
                
                guard result.count != 0 else {
                    return
                }
                
                // 所有相片放置最前
                if collection.assetCollectionSubtype == .smartAlbumUserLibrary {
                    arrAblum.insert(self.getAlbumListModel(title: collection.localizedTitle!, result: result), at: 0)
                } else{
                    arrAblum.append(self.getAlbumListModel(title: collection.localizedTitle!, result: result))
                }
            })
            
        }
        return arrAblum
    }
    
    // MARK: - 提取每个相册的最后一个PHAsset
    func getAlbumListModel(title: String, result: PHFetchResult<PHAsset>) -> ZNLAlbumsListModel {
        let model = ZNLAlbumsListModel.init()
        model.title = title
        model.count = result.count
        model.result = result
        model.headImage = result.lastObject!
        model.model = getPhotoInResult(result: result)
        return model
    }

    // MARK: - 获取相册列表中每个PHAsset 存入模型
    func getPhotoInResult(result: PHFetchResult<PHAsset>) -> Array<ZNLAblumsModel> {
        var arrV = Array<ZNLAblumsModel>()
        result.enumerateObjects({ (obj, index, stop) in
            let model = ZNLAblumsModel.init()
            arrV.append(model.modelWithAsset(asset: obj))
        })
        return arrV
    }

    
    //MARK: - 通过asset获取image
    func requestImageForAsset(asset: PHAsset, size: CGSize, resizeModel: PHImageRequestOptionsResizeMode, completion:@escaping (_ image: UIImage, _ dict:[String: AnyObject]) ->()){
        let option = PHImageRequestOptions.init()
        
        option.resizeMode = resizeModel
        
        option.isNetworkAccessAllowed = true
        
        PHCachingImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: option) { (image, info) in
            //            let downloadFinished = (info?.index(forKey: PHImageCancelledKey))
            completion(image!, info as! [String : AnyObject])
        }
    }

}
