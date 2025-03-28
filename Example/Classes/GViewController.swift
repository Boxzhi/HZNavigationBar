//
//  GViewController.swift
//  HZNavigationBar_Example
//
//  Created by 何志志 on 2019/4/10.
//  Copyright © 2019 何志志. All rights reserved.
//

import UIKit
import HZNavigationBar

class GViewController: BaseViewController {
    
    fileprivate lazy var collectionView: UICollectionView = {
        let rect = CGRect(x: 0, y: 44 + UIApplication.shared.statusBarFrame.size.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 44 - UIApplication.shared.statusBarFrame.size.height)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
//        layout.itemSize = CGSize(width: rect.width, height: rect.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let _collectiobView = UICollectionView(frame: rect, collectionViewLayout: layout)
        _collectiobView.backgroundColor = .white
        _collectiobView.isPagingEnabled = true
        _collectiobView.contentSize = CGSize(width: rect.width * 10.0, height: rect.height)
        _collectiobView.register(UINib(nibName: "GCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GCollectionViewCell")
        return _collectiobView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        nav?.title = "GViewController"
        nav?.hz.setBackgroundImage("https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.ivsky.com%2Fimg%2Ftupian%2Fpic%2F201707%2F17%2Fjinmendaqiao-009.jpg%3Fdownload&refer=http%3A%2F%2Fimg.ivsky.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1744870098&t=03c96106823506b17d85747b71e52a76", isNexwork: true)
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(HZCustomNavigationBar.statusNavigationBarHeight)
        }
        // Do any additional setup after loading the view.
    }
    
    override func orientationDidChange(_ notification: Notification) {
        super.orientationDidChange(notification)
        collectionView.reloadData()
    }

}

extension GViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: view.frame.size.height - HZCustomNavigationBar.statusNavigationBarHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GCollectionViewCell", for: indexPath) as? GCollectionViewCell
        cell?.currentLabel.text = "\(indexPath.row)"
        return cell!
    }
}
