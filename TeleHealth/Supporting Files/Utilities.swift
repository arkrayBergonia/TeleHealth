//
//  Utilities.swift
//  EmergencyCall_Swift
//
//  Created by Francis Jemuel Bergonia on 12/26/19.
//  Copyright © 2019 Arkray PHM. All rights reserved.
//

import UIKit
import Foundation

class Utilities {
 
    static func log(_ message: String) {
        print(message)
    }
    // This function is use for custom displaying Alert Box || この関数は、アラートボックスのカスタム表示に使用されます
    static func showAlert(_ viewController: UIViewController, title: String, message: String, animated: Bool, completion: (() -> Void)?, actions: [UIAlertAction]) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for action in actions {
            alertController.addAction(action)
        }
        
        viewController.present(alertController, animated: animated, completion: completion)
    }
    

}
