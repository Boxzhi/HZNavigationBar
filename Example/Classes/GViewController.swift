//
//  GViewController.swift
//  HZNavigationBar_Example
//
//  Created by 何志志 on 2019/4/10.
//  Copyright © 2019 何志志. All rights reserved.
//

import UIKit

class GViewController: BaseViewController {
    
    fileprivate lazy var collectionView: UICollectionView = {
        let rect = CGRect(x: 0, y: 44 + UIApplication.shared.statusBarFrame.size.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 44 - UIApplication.shared.statusBarFrame.size.height)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: rect.width, height: rect.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let _collectiobView = UICollectionView(frame: rect, collectionViewLayout: layout)
        _collectiobView.backgroundColor = .red
        _collectiobView.isPagingEnabled = true
        _collectiobView.contentSize = CGSize(width: rect.width * 10.0, height: rect.height)
        _collectiobView.register(UINib(nibName: "GCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GCollectionViewCell")
        return _collectiobView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        nav.title = "GViewController"
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }

}

extension GViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GCollectionViewCell", for: indexPath) as? GCollectionViewCell
        cell?.currentLabel.text = "\(indexPath.row)"
        print("\(indexPath.row)")
        return cell!
    }
}
