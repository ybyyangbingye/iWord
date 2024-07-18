//
//  RecentVC.swift
//  iWord
//
//  Created by 何纪栋 on 2024/7/18.
//

import Foundation
import UIKit

class RecentVC: BaseVC{
     let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setUI() {
        super.setUI()
    
        view.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(WordCell.self, forCellWithReuseIdentifier: "WordCell")
        collectionView.showsVerticalScrollIndicator = false
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.itemSize = CGSize(width: 220, height: 230) // 设置每个单元格的大小
            flowLayout.minimumLineSpacing = 36
            flowLayout.minimumInteritemSpacing = 36
        }

        collectionView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.82)
            make.height.equalToSuperview().multipliedBy(0.6)
        }
    }
    
}
extension RecentVC: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return kFruit.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordCell", for: indexPath) as! WordCell
        cell.config(kFruit[indexPath.row])
        return cell
    }
    
    
}
