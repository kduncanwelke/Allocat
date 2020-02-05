//
//  SetBudgetViewController.swift
//  Allocat
//
//  Created by Kate Duncan-Welke on 1/24/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit
import CurrencyTextField

class SetBudgetViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var amount: CurrencyTextField!
    @IBOutlet weak var monthAmount: UILabel!
    @IBOutlet weak var quarterAmount: UILabel!
    @IBOutlet weak var biannualAmount: UILabel!
    @IBOutlet weak var yearAmount: UILabel!
    @IBOutlet weak var duration: UISegmentedControl!
    @IBOutlet weak var selectedForDisplay: UISegmentedControl!
    
    // MARK: Variables
    
    let formatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        // if budget exists, load it into view so it can be edited
        if MoneyManager.loadedBudget != nil {
            let final: Double = {
                switch MoneyManager.budgetTime {
                case .month:
                    return MoneyManager.month
                case .quarter:
                    return MoneyManager.quarter
                case .biannual:
                    return MoneyManager.biannual
                case .year:
                    return MoneyManager.year
                default:
                    return 0
                }
            }()
            
            updateUI(index: MoneyManager.budgetTime.rawValue, final: final)
            amount.text = formatter.string(from: NSNumber(value: final))
            selectedForDisplay.selectedSegmentIndex = MoneyManager.budgetTime.rawValue
        }
        
        amount.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    // MARK: Custom functions
  
    // called when text field has content changed
    @objc func textFieldDidChange(_ textField: UITextField) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
            if let text = textField.text {
                
                guard let number = self.formatter.number(from: text), let final = Double(exactly: number) else { return }
               
                self.updateUI(index: self.duration.selectedSegmentIndex, final: final)
            }
        }
    }
    
    // show amounts properly for each possible range, etc
    func updateUI(index: Int, final: Double) {
        switch index {
        case 0: // month
            MoneyManager.month = Double(exactly: final) ?? 0
            MoneyManager.quarter = Double(exactly: final * 3) ?? 0
            MoneyManager.biannual = Double(exactly: final * 6) ?? 0
            MoneyManager.year = Double(exactly: final * 12) ?? 0
            
            let month = formatter.string(from: NSNumber(value: final))
            monthAmount.text = "\(month ?? "-")"
            
            let quarter = formatter.string(from: NSNumber(value: final * 3))
            quarterAmount.text = "\(quarter ?? "-")"
            
            let biannual = formatter.string(from: NSNumber(value: final * 6))
            biannualAmount.text = "\(biannual ?? "-")"
            
            let year = formatter.string(from: NSNumber(value: final * 12))
            yearAmount.text = "\(year ?? "-")"
        case 1: // quarter
            MoneyManager.month = Double(exactly: final / 3) ?? 0
            MoneyManager.quarter = Double(exactly: final) ?? 0
            MoneyManager.biannual = Double(exactly: final * 2) ?? 0
            MoneyManager.year = Double(exactly: final * 4) ?? 0
            
            let month = formatter.string(from: NSNumber(value: final / 3))
            monthAmount.text = "\(month ?? "-")"
            
            let quarter = formatter.string(from: NSNumber(value: final))
            quarterAmount.text = "\(quarter ?? "-")"
            
            let biannual = formatter.string(from: NSNumber(value: final * 2))
            biannualAmount.text = "\(biannual ?? "-")"
            
            let year = formatter.string(from: NSNumber(value: final * 4))
            yearAmount.text = "\(year ?? "-")"
        case 2: // biannual
            MoneyManager.month = Double(exactly: final / 6) ?? 0
            MoneyManager.quarter = Double(exactly: final / 2) ?? 0
            MoneyManager.biannual = Double(exactly: final) ?? 0
            MoneyManager.year = Double(exactly: final * 2) ?? 0
            
            let month = formatter.string(from: NSNumber(value: final / 6))
            monthAmount.text = "\(month ?? "-")"
            
            let quarter = formatter.string(from: NSNumber(value: final / 2))
            quarterAmount.text = "\(quarter ?? "-")"
            
            let biannual = formatter.string(from: NSNumber(value: final))
            biannualAmount.text = "\(biannual ?? "-")"
            
            let year = formatter.string(from: NSNumber(value: final * 2))
            yearAmount.text = "\(year ?? "-")"
        case 3: // annual
            MoneyManager.month = Double(exactly: final / 12) ?? 0
            MoneyManager.quarter = Double(exactly: final / 4) ?? 0
            MoneyManager.biannual = Double(exactly: final / 2) ?? 0
            MoneyManager.year = Double(exactly: final) ?? 0
            
            let month = formatter.string(from: NSNumber(value: final / 12))
            monthAmount.text = "\(month ?? "-")"
            
            let quarter = formatter.string(from: NSNumber(value: final / 4))
            quarterAmount.text = "\(quarter ?? "-")"
            
            let biannual = formatter.string(from: NSNumber(value: final / 2))
            biannualAmount.text = "\(biannual ?? "-")"
            
            let year = formatter.string(from: NSNumber(value: final))
            yearAmount.text = "\(year ?? "-")"
        default:
            return
        }
    }
    
    func saveBudget() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        
        // if budget does not exist, create new save
        guard let currentBudget = MoneyManager.loadedBudget else {
            let budget = Budget(context: managedContext)
            
            // check that values are not zero
            if MoneyManager.month != 0, MoneyManager.quarter != 0, MoneyManager.biannual != 0, MoneyManager.year != 0 {
                budget.month = MoneyManager.month
                budget.quarter = MoneyManager.quarter
                budget.biannual = MoneyManager.biannual
                budget.year = MoneyManager.year
                budget.display = Int16(selectedForDisplay.selectedSegmentIndex)
                
                do {
                    try managedContext.save()
                    print("saved")
                } catch {
                    // this should never be displayed but is here to cover the possibility
                    showAlert(title: "Save failed", message: "Notice: Data has not successfully been saved.")
                }
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBudget"), object: nil)
                self.dismiss(animated: true, completion: nil)
            }
            
            return
        }
        
        // resave existing budget with new values
        if MoneyManager.month != 0, MoneyManager.quarter != 0, MoneyManager.biannual != 0, MoneyManager.year != 0 {
            currentBudget.month = MoneyManager.month
            currentBudget.quarter = MoneyManager.quarter
            currentBudget.biannual = MoneyManager.biannual
            currentBudget.year = MoneyManager.year
            currentBudget.display = Int16(selectedForDisplay.selectedSegmentIndex)
            
            do {
                try managedContext.save()
                print("resaved")
            } catch {
                // this should never be displayed but is here to cover the possibility
                showAlert(title: "Save failed", message: "Notice: Data has not successfully been saved.")
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBudget"), object: nil)
            self.dismiss(animated: true, completion: nil)
        }
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
        textFieldDidChange(amount)
    }
    
    @IBAction func budgetDisplaySegmentChanged(_ sender: UISegmentedControl) {
        if let selected = BudgetTime(rawValue: selectedForDisplay.selectedSegmentIndex) {
            MoneyManager.budgetTime = selected
        }
    }
    
    @IBAction func confirmPressed(_ sender: UIButton) {
        saveBudget()
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

