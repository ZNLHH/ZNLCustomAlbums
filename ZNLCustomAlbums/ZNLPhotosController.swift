//
//  ZNLPhotosController.swift
//  ZNLCustomAlbums
//
//  Created by 正能量 on 2017/6/10.
//  Copyright © 2017年 ZNL. All rights reserved.
//

import UIKit
import Photos

class ZNLPhotosController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var model = ZNLAlbumsListModel()
    var collectonView : UICollectionView?
    var img : UIImage?
    var photoClouse : ((_ image: UIImage) -> ())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if model.model.count == 0 {
            return
        }
        collectonView?.scrollToItem(at: IndexPath.init(row: model.model.count - 1, section: 0), at: .bottom, animated: false)
    }
    
    func initCollectionView() {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 1.5
        layout.minimumLineSpacing = 1.5
        let size = UIScreen.main.bounds.size
        layout.itemSize = CGSize(width: (size.width - 9) / 4, height: (size.width - 9) / 4)
        layout.sectionInset = UIEdgeInsetsMake(3, 0, 3, 0)
        collectonView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: layout)
        collectonView?.delegate = self
        collectonView?.dataSource = self
        collectonView?.backgroundColor = UIColor.white
        collectonView?.register(ZNLCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(ZNLCollectionViewCell.self))

        view.addSubview(collectonView!)
    }
    
    
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ZNLCollectionViewCell.initCollectionViewWithCell(collectionView: collectionView, indexPath: indexPath)
        
        cell.model = model.model[indexPath.row]

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ZNLPhotoManager.manager.requestImageForAsset(asset: model.model[indexPath.row].asset, size: PHImageManagerMaximumSize, resizeModel: .exact) { (image, info) in

            let VC = ZNLPhotoBrowserController(image: image, type: ZNLClipType.ZNLClipTypeArc)
            
            VC.imageClosure = { clipImage in
                if (self.photoClouse) != nil {
                    self.photoClouse!(clipImage)
                    self.navigationController?.popToRootViewController(animated: false)
                }
            }
            self.present(VC, animated: true, completion: nil)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("deinit")
    }


}
