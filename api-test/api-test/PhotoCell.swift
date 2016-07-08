//
//  PhotoCell.swift
//  api-test
//
//  Created by Misato Morino on 2016/07/04.
//  Copyright © 2016年 Misato Morino. All rights reserved.
//

import Foundation
import UIKit

class PhotoCell: UICollectionViewCell {
    
    // 画像を乗せるためのimageView.
    var photoImageView: UIImageView!
    // 画像の情報を持つ辞書.
    var photoInfo : Dictionary<String, String>?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // imageView初期化.
        photoImageView = UIImageView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        photoImageView.image = nil
        // imageViewいっぱいに画像を表示する.
        photoImageView.contentMode = UIViewContentMode.ScaleToFill
        
        // cellの枠線設定.
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.grayColor().CGColor
        
        // cellにimageViewを追加.
        self.addSubview(photoImageView)
    }
    
    /* Performs any clean up necessary to prepare the view for use again. */
    /* cellを再利用する際にまず中身をこういう風に綺麗にしますよ */
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView = UIImageView()
        photoImageView.image = nil
        self.backgroundColor = UIColor.redColor()
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.grayColor().CGColor
        
        self.addSubview(photoImageView)
    }
}
