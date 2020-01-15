//
//  ViewController.swift
//  Allocat
//
//  Created by Kate Duncan-Welke on 1/9/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var moneyIn: UILabel!
    @IBOutlet weak var moneyOut: UILabel!
    @IBOutlet weak var limitSpent: UILabel!
    
    var totalOut = 0.0
    var totalIn = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadEntries()
    }
    
    // MARK: Custom functions
    
    func loadEntries() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        var fetchRequest = NSFetchRequest<SavedEntry>(entityName: "SavedEntry")
        
        do {
            EntryManager.savedEntries = try managedContext.fetch(fetchRequest)
            print("entries loaded")
            
            for entry in EntryManager.savedEntries {
                if entry.source == nil {
                    if let name = entry.name, let date = entry.date, let note = entry.note, let categoryText = entry.category, let category = Category(rawValue: categoryText) {
                       
                        let newIncome = Income(name: name, date: date, amount: entry.amount, note: note, category: category)
                        EntryManager.entries.append(newIncome)
                        EntryManager.incomes.append(newIncome)
                    }
                } else {
                    if let name = entry.name, let date = entry.date, let note = entry.note, let typeText = entry.type, let type = Type(rawValue: typeText), let sourceText = entry.source, let source = Source(rawValue: sourceText) {
                      
                        let newExpense = Expense(name: name, amount: entry.amount, date: date, note: note, source: source, type: type)
                        EntryManager.entries.append(newExpense)
                        EntryManager.expenses.append(newExpense)
                    }
                }
            }
            
          
            EntryManager.entries = EntryManager.entries.sorted(by: {$0.date > $1.date})
            
            for expense in EntryManager.expenses {
                totalOut += expense.amount
            }
            
            for income in EntryManager.incomes {
                totalIn += income.amount
            }
            
            moneyOut.text = "\(totalOut)"
            moneyIn.text = "\(totalIn)"
            limitSpent.text = "\(totalOut) of $ spent"
            
            //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)
        } catch let error as NSError {
            //showAlert(title: "Could not retrieve data", message: "\(error.userInfo)")
        }
    }

    // MARK: IBActions
    
    @IBAction func addIncomeTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "addIncome", sender: Any?.self)
    }
    
    @IBAction func addExpensesTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "addExpense", sender: Any?.self)
    }
}

