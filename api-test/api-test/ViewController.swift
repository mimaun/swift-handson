//
//  ViewController.swift
//  api-test
//
//  Created by Misato Morino on 2016/07/03.
//  Copyright © 2016年 Misato Morino. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var photos : [Dictionary<String, String>] = []
    //    var config : NSURLSessionConfiguration!
    //    var session : NSURLSession!
    var collectionView : UICollectionView!
    var progressIndicator : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // collectionViewのLayout.
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSizeMake(100,30)
        
        // collectionView初期化.
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.registerClass(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.whiteColor()
        
        // インジケータ初期化.
        progressIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 100, 100))
        progressIndicator.center = self.view.center
        progressIndicator.hidesWhenStopped = true
        progressIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        progressIndicator.startAnimating()
        
        self.view.addSubview(collectionView)
        self.view.addSubview(progressIndicator)
        
        getPhotos()
        
    }
    
    func getPhotos() {
        
        let urlString = "https://api.photozou.jp/rest/search_public.json"
        let keyword = "あの花"
        let limit = "20"
        
        let params = "keyword=\(keyword)&limit=\(limit)"
        
        let url = NSURL(string: "\(urlString)?\(params)".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        
        /* 通信処理開始 */
        let config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        
        // 画像に関する情報を取得
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            // 受け取ったjsonを辞書型に変換, パース.
            var dict = NSDictionary()
            if let _data = data {
                do {
                    try dict = NSJSONSerialization.JSONObjectWithData(_data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                } catch {
                    print("error: \(error)")
                }
                
                if dict["info"]!["photo_num"] as! Int > 0 {
                    // 受け取ったデータから必要なデータを取り出し（title, image_url）
                    let tempPhotos = dict["info"]!["photo"] as! [NSDictionary]
                    for p in tempPhotos {
                        let temp: Dictionary<String, String> = [
                            "title" : p["photo_title"] as! String,
                            "url" : p["image_url"] as! String,
                            ]
                        self.photos.append(temp)
                    }
                } else {
                    let alert = UIAlertController(title: "No Result", message: "検索したkeywordに該当する写真はありませんでした", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) in
                        // インジケータが回っていたら止める.
                        if self.progressIndicator.isAnimating() {
                            self.progressIndicator.stopAnimating()
                        }
                    })
                    alert.addAction(okAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            
            // force main thread
            dispatch_async(dispatch_get_main_queue(), {
                // collectionViewのデータをリロード.
                self.collectionView.reloadData()
            })
        }
        
        // 通信開始
        task.resume()
        
    }
    
    /* cellのサイズを指定 */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let itemSize = CGSizeMake(100, 100)
        return itemSize
    }
    
    /* cellを選択した時に呼ばれる */
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // photoViewControllerを生成.
        let photoViewController = PhotoViewController()
        // 画像に関する情報を渡す.
        photoViewController.photoInfo = photos[indexPath.item]
        // photoViewControllerに遷移.
        presentViewController(photoViewController, animated: true, completion: nil)
    }
    
    /* cellいくついりますか */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    /* 各cellに情報を流し込む */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // photoCell生成.
        let photoCell : PhotoCell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        let photoInfo = photos[indexPath.item] as Dictionary
        
        // 画像URLから画像データを取得.
        let photoUrl = NSURL(string: photoInfo["url"]!)
        let data = NSData(contentsOfURL: photoUrl!)
        
        // dataが存在するなら画像をdataから取得.
        if let _data = data {
            let image = UIImage(data: _data)
            // 取得した画像をphotoCellのimageViewに乗せる.
            photoCell.photoImageView.image = image
            // 画像の透明度を0に（alphaを0に）
            photoCell.photoImageView.alpha = 0
            // 0.2秒かけて画像を表示（alphaを1.0に）
            UIView.animateWithDuration(0.5, animations: {
                photoCell.photoImageView.alpha = 1.0
            })
        }
        
        // インジケータが回っていたら止める.
        if progressIndicator.isAnimating() {
            progressIndicator.stopAnimating()
        }
        // 画像に関する情報を渡す.
        photoCell.photoInfo = photoInfo
        
        return photoCell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

