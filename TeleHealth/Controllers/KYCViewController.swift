//
//  KYCViewController.swift
//  TeleHealth
//
//  Created by Francis Jemuel Bergonia on 3/11/20.
//  Copyright © 2020 Xi Apps. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

enum UserProcess {
    case Register
    case Login
    case GoogleSignin
}

class KYCViewController: UIViewController {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var iconTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var textfieldStack: UIStackView!
    @IBOutlet weak var buttonStack: UIStackView!
    @IBOutlet weak var fullNameTextfield: RoundedTextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var registerBtn: RoundedButton!
    @IBOutlet weak var loginBtn: RoundedButton!
    @IBOutlet weak var cancelBtn: RoundedButton!
    
    var userProcess = UserProcess.Login
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.layoutImage()
        self.setDelegate()
        self.showHideElements(userProcess: self.userProcess)
        self.addImageEditor()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func registerBtnPressed(_ sender: RoundedButton) {
        //self.performSegue(withIdentifier: "goToChat", sender: self)
        if self.userProcess == UserProcess.Register {
            if checkTextfieldsAreValid() {
                SVProgressHUD.show()

                Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!, completion: { (user, error) in
                    if error != nil {
                        print(error!)
                    } else {
                        print ("Registration Successful!")
                        SVProgressHUD.dismiss()
                        self.performSegue(withIdentifier: "goToChat", sender: self)
                    }
                })
            }
        }
    }
    
    @IBAction func loginBtnPressed(_ sender: RoundedButton) {
        //self.performSegue(withIdentifier: "goToChat", sender: self)
        if self.userProcess == UserProcess.Login {
            if checkTextfieldsAreValid() {
                SVProgressHUD.show()
                Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!, completion: { (user, error) in
                    if error != nil {
                        print(error!)
                    } else {
                        SVProgressHUD.dismiss()
                        print("login successful")
                        self.performSegue(withIdentifier: "goToChat", sender: self)
                    }
                })
            }
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: RoundedButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension KYCViewController {
    
    private func layoutImage() {
        self.iconImage.layer.borderWidth = 1
        self.iconImage.layer.masksToBounds = false
        self.iconImage.layer.borderColor = UIColor.systemGreen.cgColor
        self.iconImage.layer.cornerRadius = self.iconImage.frame.height/2
        self.iconImage.clipsToBounds = true
    }
    
    private func showHideElements(userProcess: UserProcess) {
        let registerInProcess = userProcess == UserProcess.Register
        let btn = registerInProcess ? self.loginBtn : self.registerBtn
        self.fullNameTextfield.isHidden = !registerInProcess
        btn?.isHidden = true
        self.cancelBtn.isHidden = false
    }
    
    private func reusableAlertBox(title: String, message: String) {
        let action = [UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)]
        Utilities.showAlert(self, title: title, message: message, animated: true, completion: nil, actions: action)
    }
    
    private func addImageEditor() {
        if self.userProcess == UserProcess.Register {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(bottomActionSheetPressed))
            self.iconImage.addGestureRecognizer(tapGesture)
        } else {
            self.iconImage.image = UIImage(named: "iconImage")
        }
    }
}


extension KYCViewController: UITextFieldDelegate {
    
    private func setDelegate() {
        self.fullNameTextfield.delegate = self
        self.emailTextfield.delegate = self
        self.passwordTextfield.delegate = self
        
        self.fullNameTextfield.inputAccessoryView = self.addDoneBtnViewForKeyboard()
        self.emailTextfield.inputAccessoryView = self.addDoneBtnViewForKeyboard()
        self.passwordTextfield.inputAccessoryView = self.addDoneBtnViewForKeyboard()
    }
    
    private func addDoneBtnViewForKeyboard() -> UIButton {
        let bgColor = userProcess == UserProcess.Register ? UIColor.systemGreen : UIColor.systemBlue
        let doneBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
        doneBtn.backgroundColor = bgColor
        doneBtn.setTitle("Done", for: .normal)
        doneBtn.setTitleColor(UIColor.white, for: .normal)
        doneBtn.contentHorizontalAlignment = .right
        doneBtn.autoresizingMask = .flexibleRightMargin
        doneBtn.addTarget(self, action: #selector(KYCViewController.hideKeyboard), for: .touchUpInside)
        return doneBtn
    }
    
    @objc func hideKeyboard() {
        self.fullNameTextfield.resignFirstResponder()
        self.emailTextfield.resignFirstResponder()
        self.passwordTextfield.resignFirstResponder()
    }
    
    private func checkTextfieldsAreValid() -> Bool {
        if self.emailTextfield.text != "" && self.passwordTextfield.text != "" {
            if self.emailTextfield.text!.isValidEmail() {
                return true
            }
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.fullNameTextfield:
            self.emailTextfield.becomeFirstResponder()
        case self.emailTextfield:
            self.passwordTextfield.becomeFirstResponder()
        case self.passwordTextfield:
            self.passwordTextfield.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return false
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.userProcess == UserProcess.Register {
            UIView.animate(withDuration: 0.5) {
                self.iconTopConstraint.constant = -self.iconImage.frame.size.height
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.userProcess == UserProcess.Register {
            UIView.animate(withDuration: 0.5) {
                self.iconTopConstraint.constant = 60
                self.view.layoutIfNeeded()
            }
        }
    }
    
}

extension KYCViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //PhotoLibrary Functions
    private func selectFromGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    //Camera Functions
    private func getAnImage() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraImagePickerController = UIImagePickerController()
            cameraImagePickerController.sourceType = .camera
            cameraImagePickerController.delegate = self
            present(cameraImagePickerController, animated: true, completion: nil)
        }
    }
    
    // PhotoLibrary Functions
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.iconImage.contentMode = .scaleAspectFill
            self.iconImage.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //Bottom ActionSheet
    @objc func bottomActionSheetPressed() {
        let alert = UIAlertController(title: "Select an image for your profile", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Select from Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.selectFromGallery()}))
        alert.addAction(UIAlertAction(title: "Capture an image", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.getAnImage()}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil

    }
}
