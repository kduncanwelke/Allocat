//
//  SetBudgetViewController.swift
//  Allocat
//
//  Created by Kate Duncan-Welke on 1/24/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class SetBudgetViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var monthAmount: UILabel!
    @IBOutlet weak var quarterAmount: UILabel!
    @IBOutlet weak var biannualAmount: UILabel!
    @IBOutlet weak var yearAmount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        amount.delegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: IBActions
    
    @IBAction func durationSegmentChanged(_ sender: UISegmentedControl) {
        // TODO: show quantities based on selection
    }
    
    @IBAction func budgetDisplaySegmentChanged(_ sender: UISegmentedControl) {
    }
    
    @IBAction func confirmPressed(_ sender: UIButton) {
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

// MARK: Text field delegate

extension SetBudgetViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newCharacters = NSCharacterSet(charactersIn: string)
        let boolIsNumber = NSCharacterSet.decimalDigits.isSuperset(of: newCharacters as CharacterSet)
        
        if boolIsNumber == true {
            return true
        } else {
            if string == "." {
                let countDots = textField.text!.components(separatedBy:".").count - 1
                if countDots == 0 {
                    return true
                } else {
                    if countDots > 0 && string == "." {
                        return false
                    } else {
                        return true
                    }
                }
            } else if string == "," {
                let countCommas = textField.text!.components(separatedBy:",").count - 1
                if countCommas == 0 {
                    return true
                } else {
                    if countCommas > 0 && string == "," {
                        return false
                    } else {
                        return true
                    }
                }
            } else {
                return false
            }
        }
    }
}
