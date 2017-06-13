//
//  ZNLAlbumsListCell.swift
//  ZNLCustomAlbums
//
//  Created by hhgk on 2017/6/12.
//  Copyright © 2017年 ZNL. All rights reserved.
//

import UIKit

class ZNLAlbumsListCell: UITableViewCell {

    
    var imgView = UIImageView()
    var label = UILabel()
    var countLab = UILabel()
    
    
    
   static func albumsListWithCell(tableView: UITableView) -> ZNLAlbumsListCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ZNLAlbumsListCell.self))
        if cell == nil {
            cell = ZNLAlbumsListCell.init(style: .default, reuseIdentifier: NSStringFromClass(ZNLAlbumsListCell.self))
        }
        return cell as! ZNLAlbumsListCell
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    var model: ZNLAlbumsListModel? {
        didSet {
            let size = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)

            ZNLPhotoManager.manager.requestImageForAsset(asset: (model?.headImage)!, size: size, resizeModel: .fast) { (image, info) in
                self.imgView.image = image
            }
                        
            label.text = model?.title
            label.sizeToFit()
            countLab.frame.origin.x = label.frame.maxX + 12
            countLab.text = "(\(model!.count))"
            countLab.sizeToFit()

        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        imgView = UIImageView.init(frame: CGRect(x: 12, y: 12, width: 80, height: 80))
        imgView.contentMode = .scaleAspectFit
        contentView.addSubview(imgView)
        
        
        label = UILabel.init(frame: CGRect(x: imgView.frame.maxX + 12, y: 12, width: 20, height: 20))
        label.center.y = imgView.center.y
        contentView.addSubview(label)
        
        
        
        countLab = UILabel.init(frame: CGRect(x: label.frame.maxX + 12, y: 12, width: 20, height: 20))
        countLab.center.y = imgView.center.y
        contentView.addSubview(countLab)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
