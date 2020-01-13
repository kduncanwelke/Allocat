//
//  ExpenseViewController.swift
//  Allocat
//
//  Created by Kate Duncan-Welke on 1/10/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class ExpenseViewController: UIViewController {

    // MARK: IBOutlets
    
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
    
    let typeNames = ["None", "Clothing", "Electronics", "Entertainment", "Food", "Fuel", "Health", "Home", "Housing", "Gifts", "Media", "Other", "Outdoor", "Personal", "Pet", "Services", "Subscriptions", "Tools", "Travel", "Utilities"]
    
    let sourceNames = ["None", "Bank", "Cash", "Check", "Credit", "Debit"]
    let dateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        dimView.isHidden = true
        pickerBackground.isHidden = true
        
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
    }
    
    @IBAction func selectTypePressed(_ sender: UIButton) {
        dimView.isHidden = false
        pickerBackground.isHidden = false
        
        datePicker.isHidden = true
        sourcePicker.isHidden = true
        typePicker.isHidden = false
    }
    
    @IBAction func selectSourcePressed(_ sender: UIButton) {
        dimView.isHidden = false
        pickerBackground.isHidden = false
        
        datePicker.isHidden = true
        sourcePicker.isHidden = false
        typePicker.isHidden = true
    }
    
    @IBAction func dimViewTapped(_ sender: UITapGestureRecognizer) {
        pickerBackground.isHidden = true
        dimView.isHidden = true
    }
    
    
    @IBAction func confirmPressed(_ sender: UIButton) {
        // check for essential fields then save entry
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
