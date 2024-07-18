//
//  BaseVC.swift
//  iWord
//
//  Created by 何纪栋 on 2024/7/18.
//

import Foundation
import UIKit

class BaseVC: UIViewController{
    let backBtn = UIButton()
    let background = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    func setUI(){
        
        self.view.addSubview(background)
        background.image = UIImage(named: "Home_Bg")
        background.contentMode = .scaleAspectFit
        background.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(backBtn)
        backBtn.setImage(UIImage(named: "back_icon"), for: .normal)
        backBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
        backBtn.snp.makeConstraints { make in
            make.width.height.equalTo(64)
            make.left.equalTo(70)
            make.top.equalTo(56)
        }
        
        
    }
    @objc func back(){
        self.dismiss(animated: true)
    }
}
