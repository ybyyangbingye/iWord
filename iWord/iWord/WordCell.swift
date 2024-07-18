//
//  WordCell.swift
//  iWord
//
//  Created by 何纪栋 on 2024/7/18.
//

import Foundation
import UIKit
class WordCell: UICollectionViewCell {
  
    var word: String!
    
    var wordImageView = UIImageView()
    var wordLabel = UILabel()
    
    func config(_ with: String) {
        self.word = with
        setUI()
    }
    func setUI(){
        backgroundColor = .white.withAlphaComponent(0.3)
        contentView.addSubview(wordImageView)
        wordImageView.image = UIImage(named: word)
        wordImageView.contentMode = .scaleAspectFit
        wordImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        contentView.addSubview(wordLabel)
        wordLabel.font = UIFont.systemFont(ofSize: 35,weight: .medium)
        wordLabel.textColor = .black
        wordLabel.text = word
        wordLabel.textAlignment = .center
        wordLabel.backgroundColor = .white
        wordLabel.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.3)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        contentView.layer.cornerRadius = 30
        contentView.layer.masksToBounds = true
    }
}




