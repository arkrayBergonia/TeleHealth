//
//  WelcomeViewController.swift
//  Flash Chat
//
//  Created by Francis Jemuel Bergonia on 3/9/20.
//  Copyright © 2020 Xi Apps. All rights reserved.
//
//  This is the welcome view controller - the first thign the user sees
//

import UIKit
import GoogleSignIn

class WelcomeViewController: UIViewController {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var textfieldStack: UIStackView!
    @IBOutlet weak var buttonStack: UIStackView!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var googleSignInBtn: RoundedButton!
    @IBOutlet weak var registerBtn: RoundedButton!
    @IBOutlet weak var loginBtn: RoundedButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.layoutImage()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self as? GIDSignInDelegate
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func googleSignInBtnPressed(_ sender: RoundedButton) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func registerBtnPressed(_ sender: RoundedButton) {
        
    }
    
    @IBAction func loginBtnPressed(_ sender: RoundedButton) {
        self.performSegue(withIdentifier: "goToChat", sender: self)
    }
    
}


extension WelcomeViewController {
    
    private func layoutImage() {
        self.iconImage.layer.borderWidth = 1
        self.iconImage.layer.masksToBounds = false
        self.iconImage.layer.borderColor = UIColor.systemGreen.cgColor
        self.iconImage.layer.cornerRadius = self.iconImage.frame.height/2
        self.iconImage.clipsToBounds = true
    }
    
}


extension WelcomeViewController {
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            self.performSegue(withIdentifier: "goToChat", sender: self)
            
            let user: GIDGoogleUser = GIDSignIn.sharedInstance()!.currentUser
            let fullName = user.profile.name
            let email = user.profile.email
            if user.profile.hasImage {
                let userDP = user.profile.imageURL(withDimension: 200)
            }
            print("GoogleUser \(fullName), email:\(email), and has image:\(user.profile.hasImage)")
            //            self.sampleImageView.sd_setImage(with: userDP, placeholderImage: UIImage(named: "default-profile"))
            //            } else {
            //            self.sampleImageView.image = UIImage(named: "default-profile")
            //            }
            
        } else {
            print("\(error.localizedDescription)")
        }
    }
}
