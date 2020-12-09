//
//  Extensions.swift
//  HomeworkAssignment
//
//  Created by Greg Hughes on 12/8/20.
//

import Foundation
import UIKit
extension UIAlertController {
    
    func show() {
        DispatchQueue.main.async {
            let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            
            if var topController = keyWindow?.rootViewController  {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                topController.present(self, animated: true, completion: nil)
            }
        }
    }
}
