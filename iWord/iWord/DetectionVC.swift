//
//  DetectionBtn.swift
//  iWord
//
//  Created by 何纪栋 on 2024/7/18.
//

import Foundation
import UIKit

class DetectionVC: BaseVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    let detectionView = UIImageView()
    let contentLabel = UILabel()
    
    override func viewDidLoad() {
           super.viewDidLoad()

       }
    override func setUI(){
        super.setUI()
        self.view.addSubview(detectionView)
        detectionView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(400)
        }
        detectionView.contentMode = .scaleAspectFit
        
        self.view.addSubview(contentLabel)
        contentLabel.font = UIFont.systemFont(ofSize: 32,weight: .bold)
        contentLabel.textColor = .white
        contentLabel.textAlignment = .center
        contentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(detectionView.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        
        
    }


}
