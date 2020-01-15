//
//  ExpenseViewController.swift
//  Allocat
//
//  Created by Kate Duncan-Welke on 1/10/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit
import CoreData

class ExpenseViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var sourcePicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var pickerBackground: UIView!
    @IBOutlet weak var dimView: UIView!
    
    @IBOutlet weak var selectedDate: UILabel!
    @IBOutlet weak var selectedType: UILabel!
    @IBOutlet weak var selectedSource: UILabel!
    
    @IBOutlet weak var noteTextField: UITextField!
    
    
    // MARK: Variables
    
    let typeNames = ["None", "Clothing", "Electronics", "Entertainment", "Food", "Fuel", "Health", "Home", "Housing", "Insurance", "Gifts", "Media", "Other", "Outdoor", "Personal", "Pet", "Services", "Subscriptions", "Taxes", "Tools", "Transportation", "Travel", "Utilities"]
    
    let sourceNames = ["None", "Bank", "Cash", "Check", "Credit", "Debit"]
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        dimView.isHidden = true
        pickerBackground.isHidden = true
        
        amount.delegate = self
        typePicker.dataSource = self
        typePicker.delegate = self
        sourcePicker.dataSource = self
        sourcePicker.delegate = self
        
        selectedDate.text = getStringDate(from: datePicker.date)
    }
    
    // MARK: Custom functions
    
    func getStringDate(from date: Date) -> String {
        let createdDate = dateFormatter.string(from: date)
        return createdDate
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
          selectedDate.text = getStringDate(from: datePicker.date)
    }
    
    func saveExpense() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        
        let newExpense = SavedEntry(context: managedContext)
        
        guard let chosenName = name.text, let text = amount.text else { return }
        
        newExpense.name = chosenName
      
        if let number = Double(text) {
            newExpense.amount = number
        }
        
        newExpense.type = selectedType.text
        newExpense.source = selectedSource.text
        newExpense.date = datePicker.date
        newExpense.note = noteTextField.text ?? ""
        newExpense.category = nil
        
        EntryManager.savedEntries.append(newExpense)
        
        if let selectedText = selectedType.text, let selectedSource = selectedSource.text,  let type = Type(rawValue: selectedText), let source = Source(rawValue: selectedSource) {
            
            let expense = Expense(name: chosenName, amount: newExpense.amount, date: datePicker.date, note: noteTextField.text ?? "", source: source, type: type)
            
            EntryManager.entries.append(expense)
            EntryManager.expenses.append(expense)
        }
        
        do {
            try managedContext.save()
            print("saved")
        } catch {
            // this should never be displayed but is here to cover the possibility
            //showAlert(title: "Save failed", message: "Notice: Data has not successfully been saved.")
        }
        
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getNextPage"), object: nil)
        //self.dismiss(animated: true, completion: nil)
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
    
    @IBAction func selectDatePressed(_ sender: UIButton) {
        dimView.isHidden = false
        pickerBackground.isHidden = false
        
        datePicker.isHidden = false
        sourcePicker.isHidden = true
        typePicker.isHidden = true
        
        pickerBackground.popUp()
    }
    
    @IBAction func selectTypePressed(_ sender: UIButton) {
        dimView.isHidden = false
        pickerBackground.isHidden = false
        
        datePicker.isHidden = true
        sourcePicker.isHidden = true
        typePicker.isHidden = false
        
        pickerBackground.popUp()
    }
    
    @IBAction func selectSourcePressed(_ sender: UIButton) {
        dimView.isHidden = false
        pickerBackground.isHidden = false
        
        datePicker.isHidden = true
        sourcePicker.isHidden = false
        typePicker.isHidden = true
        
        pickerBackground.popUp()
    }
    
    @IBAction func dimViewTapped(_ sender: UITapGestureRecognizer) {
        pickerBackground.goDown()
        dimView.isHidden = true
    }
    
    
    @IBAction func confirmPressed(_ sender: UIButton) {
        // check for essential fields then save entry
        if amount.text != nil && name.text != nil && name.text != "" && amount.text != "" {
            saveExpense()
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: Picker data source and delegates

extension ExpenseViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == typePicker {
            return typeNames.count
        } else {
            return sourceNames.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == typePicker {
            return typeNames[row]
        } else {
            return sourceNames[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == typePicker {
            selectedType.text = typeNames[row]
        } else {
            selectedSource.text = sourceNames[row]
        }
    }
    
}

// MARK: Text field delegate

extension ExpenseViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newCharacters = NSCharacterSet(charactersIn: string)
        let boolIsNumber = NSCharacterSet.decimalDigits.isSuperset(of: newCharacters as CharacterSet)
        
        if boolIsNumber == true {
            return true
        } else {
            if string == "." {
                let countdots = textField.text!.components(separatedBy:".").count - 1
                if countdots == 0 {
                    return true
                } else {
                    if countdots > 0 && string == "." {
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
