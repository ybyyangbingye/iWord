//
//  HomeVc.swift
//  iWord
//
//  Created by 何纪栋 on 2024/7/18.
//
import Foundation
import UIKit
import SnapKit
import Alamofire

struct ResponseData: Decodable {
    let content: String
}

class HomeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let startDetectionBtn = UIButton()
    let recentBtn = UIButton()
    let btnBgView = UIImageView()
    let background = UIImageView()
    let ideal = UIImageView()
    let diologue = UIImageView()
    let testIcon = UIView()
    
    var isTest: Bool = false
    var session: Session!  // 将 Session 提升为类属性
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        // 初始化 session
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30 // 超时时间30秒
        configuration.timeoutIntervalForResource = 60 // 超时时间60秒
        session = Alamofire.Session(configuration: configuration)
    }
    
    func setUI() {
        self.view.addSubview(background)
        background.image = UIImage(named: "Home_Bg")
        background.contentMode = .scaleAspectFit
        background.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(btnBgView)
        btnBgView.image = UIImage(named: "Home_Btn_Group_Bg")
        btnBgView.isUserInteractionEnabled = true
        btnBgView.snp.makeConstraints { make in
            make.width.equalTo(615)
            make.height.equalTo(414)
            make.right.equalTo(-98)
            make.bottom.equalTo(-145)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(testMode))
        self.view.addSubview(ideal)
        ideal.image = UIImage(named: "ideal")
        ideal.contentMode = .scaleAspectFit
        ideal.snp.makeConstraints { make in
            make.width.equalTo(419)
            make.height.equalTo(575)
            make.centerY.equalToSuperview()
            make.left.equalTo(45)
        }
        ideal.isUserInteractionEnabled = true
        ideal.addGestureRecognizer(tap)
        
        btnBgView.addSubview(recentBtn)
        btnBgView.addSubview(startDetectionBtn)
        startDetectionBtn.setImage(UIImage(named: "Home_Start_Btn"), for: .normal)
        startDetectionBtn.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
        startDetectionBtn.snp.makeConstraints { make in
            make.left.equalTo(50)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.465)
            make.height.equalToSuperview().multipliedBy(0.845)
        }
        
        recentBtn.setImage(UIImage(named: "Home_Recent_Btn"), for: .normal)
        recentBtn.addTarget(self, action: #selector(toRecentVC), for: .touchUpInside)
        recentBtn.contentMode = .scaleAspectFit
        recentBtn.snp.makeConstraints { make in
            make.bottom.equalTo(startDetectionBtn)
            make.right.equalTo(-45)
            make.width.equalTo(500)
            make.height.equalTo(245)
        }
        
        self.view.addSubview(testIcon)
        testIcon.backgroundColor = .yellow
        testIcon.snp.makeConstraints { make in
            make.width.height.equalTo(4)
            make.right.bottom.equalTo(-5)
        }
        testIcon.layer.cornerRadius = 2
        testIcon.layer.masksToBounds = true
        testIcon.isHidden = !isTest
    }
    
    @objc func toRecentVC() {
        let vc = RecentVC()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc func testMode() {
        self.isTest.toggle()
        print("testing")
        testIcon.isHidden = !isTest
    }
    
    @objc func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera is not available")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            if let imageData = image.jpegData(compressionQuality: 0.5) {
                let base64String = imageData.base64EncodedString()
                if isTest {
                    presentPhotoViewController(with: image, content: "Mouse")
                } else {
                    fetchPhoto(base64: base64String, originalImage: image)
                }
            }
        }
    }
    
    func fetchPhoto(base64: String, originalImage: UIImage) {
        let param: [String: String] = ["image_base64": base64]
        let url = "https://pre-prompt-sage.alibaba-inc.com/process_image_iwords"
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Accept": "application/json"]
        
        session.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).response { response in
            // 打印响应状态码和头部信息
            if let httpResponse = response.response {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                print("HTTP Headers: \(httpResponse.allHeaderFields)")
            }
            
            // 打印完整的响应数据（若有）
            if let data = response.data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON String: \(jsonString)")
                } else {
                    print("Failed to convert data to JSON String")
                }
            } else {
                print("No response data")
            }
            
            switch response.result {
            case .success(let data):
                guard let data = data else {
                    print("No data received")
                    return
                }
                // 尝试解码数据
                do {
                    let responseData = try JSONDecoder().decode(ResponseData.self, from: data)
                    print("Content: \(responseData.content)")
                    DispatchQueue.main.async {
                        self.presentPhotoViewController(with: originalImage, content: responseData.content)
                    }
                } catch {
                    print("Error decoding response: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Request error: \(error.localizedDescription)")
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func presentPhotoViewController(with image: UIImage, content: String) {
        let vc = DetectionVC()
        vc.modalPresentationStyle = .fullScreen
        vc.detectionView.image = image
        vc.contentLabel.text = "This is \(content)"
        self.present(vc, animated: true, completion: nil)
    }
}
