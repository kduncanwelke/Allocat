//
//  Extensions.swift
//  Allocat
//
//  Created by Kate Duncan-Welke on 1/14/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

// add reusable alert functionality
extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIView {
    func goDown() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }, completion: { [unowned self] _ in
            self.isHidden = true
        })
    }
    
    func popUp() {
        UIView.animate(withDuration: 0.2, animations: {
            self.isHidden = false
            self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: { [unowned self] _ in
            self.transform = CGAffineTransform.identity
        })
    }
}

extension Date {
    func monthAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMM")
        return df.string(from: self)
    }
    
    func yearAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("YYYY")
        return df.string(from: self)
    }
}
