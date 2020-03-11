//
//  KYCViewController.swift
//  TeleHealth
//
//  Created by Francis Jemuel Bergonia on 3/11/20.
//  Copyright © 2020 Xi Apps. All rights reserved.
//

import UIKit

class KYCViewController: UIViewController {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var textfieldStack: UIStackView!
    @IBOutlet weak var buttonStack: UIStackView!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var registerBtn: RoundedButton!
    @IBOutlet weak var loginBtn: RoundedButton!
    @IBOutlet weak var cancelBtn: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.layoutImage()
        self.userStartProcess(btn: self.loginBtn)
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
        
    }
    
    @IBAction func loginBtnPressed(_ sender: RoundedButton) {
        //self.performSegue(withIdentifier: "goToChat", sender: self)
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
    
    private func showHideElements(btn:UIButton, toHide: Bool) {
        btn.isHidden = toHide
        self.cancelBtn.isHidden = !toHide
        self.textfieldStack.isHidden = !toHide
        self.emailTextfield.isHidden = !toHide
        self.passwordTextfield.isHidden = !toHide
        self.view.layoutIfNeeded()
    }
    
    private func userStartProcess(btn:UIButton) {
        self.showHideElements(btn: btn, toHide: true)
    }
    
    private func cancelUserProcess(btn:UIButton) {
        self.showHideElements(btn: btn, toHide: false)
    }
}
