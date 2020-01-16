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
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    
    var totalOut = 0.0
    var totalIn = 0.0
    let currencyFormatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "refresh"), object: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        
        loadEntries()
    }
    
    // MARK: Custom functions
    
    func updateTotals() {
        totalOut = 0.0
        totalIn = 0.0
        
        for expense in EntryManager.expenses {
            totalOut += expense.amount
        }
        
        for income in EntryManager.incomes {
            totalIn += income.amount
        }
        
        let outPriceString = currencyFormatter.string(from: NSNumber(value: totalOut)) ?? " "
        let inPriceString = currencyFormatter.string(from: NSNumber(value: totalIn)) ?? " "
        
        moneyOut.text = "-\(outPriceString)"
        moneyIn.text = "+\(inPriceString)"
        limitSpent.text = "\(outPriceString) of $ spent"
    }
    
    @objc func refresh() {
        updateTotals()
        tableView.reloadData()
    }
    
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
            updateTotals()
        } catch let error as NSError {
            //showAlert(title: "Could not retrieve data", message: "\(error.userInfo)")
        }
    }

    // MARK: IBActions
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    
    @IBAction func addIncomeTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "addIncome", sender: Any?.self)
    }
    
    @IBAction func addExpensesTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "addExpense", sender: Any?.self)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return EntryManager.entries.count
        case 1:
            return EntryManager.incomes.count
        case 2:
            return EntryManager.expenses.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath) as! EntryTableViewCell
        
        var object: Entry
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            object = EntryManager.entries[indexPath.row]
        case 1:
            object = EntryManager.incomes[indexPath.row]
        case 2:
            object = EntryManager.expenses[indexPath.row]
        default:
            object = EntryManager.entries[indexPath.row]
        }
        
        cell.nameLabel.text = object.name
        let numberString = currencyFormatter.string(from: NSNumber(value: object.amount)) ?? " "
        
        switch object {
            case is Expense:
                cell.amountLabel.textColor = UIColor(red:0.65, green:0.00, blue:0.03, alpha:1.0)
                cell.amountLabel.text = "-\(numberString)"
            case is Income:
                cell.amountLabel.textColor = UIColor(red:0.05, green:0.65, blue:0.14, alpha:1.0)
                cell.amountLabel.text = "+\(numberString)"
        default:
            break
        }
        
        return cell
    }
}
