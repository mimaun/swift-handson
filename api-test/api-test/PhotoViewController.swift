//
//  PhotoViewController.swift
//  api-test
//
//  Created by Misato Morino on 2016/07/04.
//  Copyright © 2016年 Misato Morino. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    var photoInfo : Dictionary<String, String>!
    var photoImageView : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景を黒色に.
        self.view.backgroundColor = UIColor.blackColor()
        
        // imageView初期化.
        photoImageView = UIImageView(frame: self.view.frame)
        // 画像の縦横比保つ.
        photoImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        // urlから取得した画像をimageViewに乗せる.
        let photoUrl = NSURL(string: photoInfo["url"]!)
        let data = NSData(contentsOfURL: photoUrl!)
        
        // dataがあれば画像を表示.
        if let _data = data {
            // dataから画像を取得.
            let image = UIImage(data: _data)
            self.photoImageView.image = image
        }
            // dataが見つからなければimageViewの背景をgrayに
        else {
            self.photoImageView.backgroundColor = UIColor.grayColor()
        }
        
        // 画像のタイトルを表示するlabel.
        let titleLabel = UILabel(frame: CGRectMake(50, 10, 250, 30))
        titleLabel.text = photoInfo["title"]
        titleLabel.textColor = UIColor.whiteColor()
        
        // このViewControllerを閉じる☓ボタン.
        let cancelButton = UIButton(frame: CGRectMake(0, 0, 50, 50))
        cancelButton.setTitle("☓", forState: UIControlState.Normal)
        cancelButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        //        cancelButton.addTarget(self, action: "cancel:", forControlEvents: UIControlEvents.TouchUpInside)
        // cancelButtonを押した時にcancelメソッドを呼ぶ.
        cancelButton.addTarget(self, action: #selector(PhotoViewController.cancel(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        // viewにimageView, titleLabel, cancelButtonを追加.
        self.view.addSubview(photoImageView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(cancelButton)
    }
    
    /* cancelButtonが押された時に呼ばれる */
    func cancel(sender: UIButton) {
        // このviewControllerを閉じる.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    } 
    
}
