//
//  IncomeViewController.swift
//  Allocat
//
//  Created by Kate Duncan-Welke on 1/13/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit
import CoreData
import CurrencyTextField

class IncomeViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var incomeAmount: CurrencyTextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var note: UITextField!
    
    @IBOutlet weak var chosenDate: UILabel!
    @IBOutlet weak var chosenCategory: UILabel!
    
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pickerBackground: UIView!
    
    // MARK: Variables
    
    let categories = ["None", "Allocation", "Dividends", "Freelance", "Gift", "Gig", "Other", "Sales", "Self Employment", "Wages"]

    let dateFormatter = DateFormatter()
    let formatter = NumberFormatter()
    var enteredNumber = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        incomeAmount.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        datePicker.maximumDate = Date()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        dimView.isHidden = true
        pickerBackground.isHidden = true
        
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        chosenDate.text = getStringDate(from: datePicker.date)
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
        incomeAmount.text = nil
        enteredNumber = 0.0
        name.text = nil
        chosenCategory.text = "None"
        datePicker.setDate(Date(), animated: false)
        categoryPicker.reloadAllComponents()
        note.text = nil
    }
    
    func getStringDate(from date: Date) -> String {
        let createdDate = dateFormatter.string(from: date)
        return createdDate
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        chosenDate.text = getStringDate(from: datePicker.date)
    }
    
    func saveIncome() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        
        let newIncome = SavedEntry(context: managedContext)
        
        guard let chosenName = name.text else { return }
        
        newIncome.name = chosenName
        newIncome.amount = enteredNumber
        newIncome.category = chosenCategory.text
        newIncome.date = datePicker.date
        newIncome.note = note.text ?? ""
        newIncome.type = nil
        newIncome.source = nil
        
        EntryManager.savedEntries.append(newIncome)
        
        do {
            try managedContext.save()
            print("saved")
        } catch {
            // this should never be displayed but is here to cover the possibility
            showAlert(title: "Save failed", message: "Notice: Data has not successfully been saved.")
        }
        
        resetForm()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)
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
    
    @IBAction func chooseDate(_ sender: UIButton) {
        dimView.isHidden = false
        pickerBackground.isHidden = false
        
        datePicker.isHidden = false
        categoryPicker.isHidden = true
        
        pickerBackground.popUp()
    }
    
    @IBAction func chooseCategory(_ sender: UIButton) {
        dimView.isHidden = false
        pickerBackground.isHidden = false
        
        datePicker.isHidden = true
        categoryPicker.isHidden = false
        
        pickerBackground.popUp()
    }
    
 
    @IBAction func dimViewTapped(_ sender: UITapGestureRecognizer) {
        pickerBackground.goDown()
        dimView.isHidden = true
    }
    
    @IBAction func confirmPressed(_ sender: UIButton) {
        if enteredNumber != 0.0 && name.text != nil && name.text != "" {
            saveIncome()
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

// MARK: Picker data source and delegates

extension IncomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosenCategory.text = categories[row]
    }
    
}
