//
//  ZNLAlbumsController.swift
//  ZNLCustomAlbums
//
//  Created by hhgk on 2017/6/9.
//  Copyright © 2017年 ZNL. All rights reserved.
//

import UIKit
import Photos


class ZNLAlbumsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView.init(frame: .zero, style: .plain)
    
    final var ablumsArr = Array<ZNLAlbumsListModel>()
    
    /// 裁剪获取的图片回调
    public var albumsClouse : ((_ clipImage: UIImage) -> ())?
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
        
        ablumsArr = ZNLPhotoManager.manager.getAblums()
        
        initTableView()
    
    }
    
    func initTableView() {
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 95
        view.addSubview(tableView)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ablumsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ZNLAlbumsListCell.albumsListWithCell(tableView: tableView)
        
        cell.model = ablumsArr[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ZNLPhotosController()
        vc.model = ablumsArr[indexPath.row]
        vc.photoClouse = { image in
            if self.albumsClouse != nil {
                self.albumsClouse!(image)
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
