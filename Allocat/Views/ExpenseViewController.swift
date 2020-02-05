//
//  ExpenseViewController.swift
//  Allocat
//
//  Created by Kate Duncan-Welke on 1/10/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit
import CoreData
import CurrencyTextField

class ExpenseViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var expenseAmount: CurrencyTextField!
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
    let formatter = NumberFormatter()
    var enteredNumber = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        expenseAmount.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        datePicker.maximumDate = Date()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        dimView.isHidden = true
        pickerBackground.isHidden = true
        
        typePicker.dataSource = self
        typePicker.delegate = self
        sourcePicker.dataSource = self
        sourcePicker.delegate = self
        
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        selectedDate.text = getStringDate(from: datePicker.date)
    }
    
    // MARK: Custom functions
    
    // called when text field has content changed
    @objc func textFieldDidChange(_ textField: UITextField) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
            if let text = textField.text {
                
                guard let number = self.formatter.number(from: text), let final = Double(exactly: number) else { return }
                
                self.enteredNumber = final
            }
        }
    }
    
    func resetForm() {
        expenseAmount.text = nil
        enteredNumber = 0.0
        name.text = nil
        selectedSource.text = "None"
        selectedType.text = "None"
        datePicker.setDate(Date(), animated: false)
        typePicker.reloadAllComponents()
        sourcePicker.reloadAllComponents()
        noteTextField.text = nil
    }
    
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
        
        guard let chosenName = name.text else { return }
        
        newExpense.name = chosenName
        newExpense.amount = enteredNumber
        newExpense.type = selectedType.text
        newExpense.source = selectedSource.text
        newExpense.date = datePicker.date
        newExpense.note = noteTextField.text ?? ""
        newExpense.category = nil
        
        EntryManager.savedEntries.append(newExpense)
        
        do {
            try managedContext.save()
            print("saved")
        } catch {
            // this should never be displayed but is here to cover the possibility
            showAlert(title: "Save failed", message: "Notice: Data has not successfully been saved.")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)
        resetForm()
      
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
        if enteredNumber != 0.0 && name.text != nil && name.text != "" {
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
