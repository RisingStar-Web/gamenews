//
//  WriteNewsViewController.swift
//  gamenews
//
//  Created by Maxim Skorynin on 08/01/2019.
//  Copyright © 2019 Maxim Skorynin. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class WriteNewsViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleNews: UITextField!
    @IBOutlet weak var descriptionNews: UITextView!
    @IBOutlet weak var pictureNews: UIImageView!
    @IBOutlet weak var sendNews: UIButton!
    
    @IBOutlet weak var titleHint: UILabel!
    @IBOutlet weak var newsHint: UILabel!
    @IBOutlet weak var pictureHint: UILabel!
    @IBOutlet weak var charsCount: UILabel!
    
    var isImageLoaded = false
    
    @IBAction func swipeUp(_ sender: Any) {
        self.endEditing()
    }
    
    @IBAction func swipeDown(_ sender: Any) {
        self.endEditing()
    }
    @IBAction func sendNewsClick(_ sender: Any) {
        
        if (titleNews.text?.isEmpty)! {
            self.showAlertOk(title: "Заголовок", message: "Введите заголовок новости")
            return
        }
        
        if descriptionNews.text.isEmpty {
            self.showAlertOk(title: "Описание", message: "Введите описание новости")
            return
        }
        
        if !isImageLoaded {
            self.showAlertOk(title: "Изображение", message: "Выберите изображение для новости")
            return
        }
        
        if !Connectivity.isConnectedToInternet {
            self.showAlertOk(title: "Отправка новости", message: "Подключение к сети отсутствует")
            return
        }
        
        let _ = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            MBProgressHUD.hide(for: self.view, animated: true)
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = .customView
            hud.label.text = "Успешно"
            
            hud.customView = UIImageView(image: #imageLiteral(resourceName: "Checkmark"))
            hud.hide(animated: true, afterDelay: 2)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        
        let tapper = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tapper.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapper)
        
        let uploadTap = UITapGestureRecognizer(target: self, action: #selector(uploadImage))
        uploadTap.cancelsTouchesInView = true
        self.pictureNews.isUserInteractionEnabled = true
        self.pictureNews.addGestureRecognizer(uploadTap)
        
        descriptionNews.delegate = self
        
        setLayouOptions()
    }
    
    @objc func endEditing() {
        self.view.endEditing(true)
    }
    
    @objc func uploadImage() {
        let photoPicker = UIImagePickerController()
        photoPicker.allowsEditing = true
        photoPicker.delegate = self
        photoPicker.sourceType = .photoLibrary
        
        DispatchQueue.main.async {
            self.present(photoPicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            var resizeImage = UIImage()
            let widthPixel = image.size.width * image.scale

            if widthPixel < 256 {
                return
            }
            if widthPixel > 512 {
                resizeImage = image.resizeWithWidth(width: 512)!
            } else {
                resizeImage = image
            }
            pictureNews.image = resizeImage
            isImageLoaded = true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.charsCount.text = "\(textView.text.count)/2000"
    }
    
    func setLayouOptions() {
        
        self.view.backgroundColor = UIColor.Default.background
        self.titleNews.textColor = UIColor.Default.text
        self.descriptionNews.textColor = UIColor.Default.text

        self.titleNews.backgroundColor = UIColor.Default.cell
        self.descriptionNews.backgroundColor = UIColor.Default.cell
        self.titleHint.textColor = UIColor.Default.text
        self.newsHint.textColor = UIColor.Default.text
        self.pictureHint.textColor = UIColor.Default.text
        self.titleHint.alpha = 0.5
        self.newsHint.alpha = 0.5
        self.pictureHint.alpha = 0.5
        self.charsCount.alpha = 0.5

        self.charsCount.textColor = UIColor.Default.text
        if User.shared.isNightMode {
            self.pictureNews.image = UIImage(named: "UploadImageNight")
        }
        
         titleNews.font = titleNews.font?.withSize((titleNews.font?.pointSize)! + CGFloat(User.shared.fontSize))
         titleHint.font = titleNews.font?.withSize((titleNews.font?.pointSize)! + CGFloat(User.shared.fontSize))
         newsHint.font = titleNews.font?.withSize((titleNews.font?.pointSize)! + CGFloat(User.shared.fontSize))
         descriptionNews.font = titleNews.font?.withSize((titleNews.font?.pointSize)! + CGFloat(User.shared.fontSize))
        pictureHint.font = titleNews.font?.withSize((titleNews.font?.pointSize)! + CGFloat(User.shared.fontSize))
         sendNews.titleLabel?.font = titleNews.font?.withSize((titleNews.font?.pointSize)! + CGFloat(User.shared.fontSize))

    }
}

extension UIImage {
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let image = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        image.contentMode = .scaleAspectFit
        image.image = self
        UIGraphicsBeginImageContextWithOptions(image.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        image.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}
