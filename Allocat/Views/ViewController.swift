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
    
    // MARK: Variables
    
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
    
    func groupEntries(entries: [Entry]) -> [[Entry]] {
        var arrayedEntries: [[Entry]] = [[]]
        var index = 0
        var previousDate = Date()
        
        for entry in entries {
            print(entry.date)
            
            print(Calendar.current.isDate(entry.date, equalTo: previousDate, toGranularity: .year))
            print(Calendar.current.isDate(entry.date, equalTo: previousDate, toGranularity: .month))
            
            // if item is of current month and date, add to first place in array
            if Calendar.current.isDate(entry.date, equalTo: Date(), toGranularity: .year) &&  Calendar.current.isDate(entry.date, equalTo: Date(), toGranularity: .month) {
                arrayedEntries[index].append(entry)
                
                switch entry {
                case is Income:
                    if let income = entry as? Income {
                        EntryManager.incomes[index].append(income)
                    }
                case is Expense:
                    if let expense = entry as? Expense {
                        EntryManager.expenses[index].append(expense)
                    }
                default:
                    break
                }
                previousDate = entry.date
                print(index)
            } else {
                print(index)
                var incomeIndex = 0
                var expenseIndex = 0
                
                // if entry belongs in same group with previous
                if Calendar.current.isDate(entry.date, equalTo: previousDate, toGranularity: .year) &&  Calendar.current.isDate(entry.date, equalTo: previousDate, toGranularity: .month) {
                    arrayedEntries[index].append(entry)
                    
                    switch entry {
                    case is Income:
                        if let income = entry as? Income {
                            EntryManager.incomes[incomeIndex].append(income)
                            incomeIndex += 1
                        }
                    case is Expense:
                        if let expense = entry as? Expense {
                            EntryManager.expenses[expenseIndex].append(expense)
                            expenseIndex += 1
                        }
                    default:
                        break
                    }
                    
                    previousDate = entry.date
                } else {
                    index += 1
                    arrayedEntries.append([])
                    arrayedEntries[index].append(entry)
                    
                    switch entry {
                    case is Income:
                        EntryManager.incomes.append([])
                        if let income = entry as? Income {
                            EntryManager.incomes[index].append(income)
                        }
                    case is Expense:
                        EntryManager.expenses.append([])
                        if let expense = entry as? Expense {
                            EntryManager.expenses[index].append(expense)
                        }
                    default:
                        break
                    }
                    previousDate = entry.date
                }
            }
        }
        
        updateTotals()
        print(arrayedEntries)
        return arrayedEntries
    }
    
    func updateTotals() {
        totalOut = 0.0
        totalIn = 0.0
        
        if let expenses = EntryManager.expenses.first, let incomes = EntryManager.incomes.first {
            for expense in expenses  {
                totalOut += expense.amount ?? 0
            }
            
            for income in incomes {
                totalIn += income.amount ?? 0
            }
        }
    
        let netAmount = totalIn - totalOut
        
        let outPriceString = currencyFormatter.string(from: NSNumber(value: totalOut)) ?? " "
        let inPriceString = currencyFormatter.string(from: NSNumber(value: totalIn)) ?? " "
        let netPriceString = currencyFormatter.string(from: NSNumber(value: netAmount)) ?? " "
        
        moneyOut.text = "-\(outPriceString)"
        moneyIn.text = "+\(inPriceString)"
        
        limitSpent.text = "\(outPriceString) of $ spent"
    }
    
    @objc func refresh() {
        EntryManager.entries.removeAll()
        
        EntryManager.all.removeAll()
        EntryManager.all.append([])
        
        EntryManager.expenses.removeAll()
        EntryManager.expenses.append([])
        
        EntryManager.incomes.removeAll()
        EntryManager.incomes.append([])
        
        EntryManager.savedEntries.removeAll()
        loadEntries()
        
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
                    }
                } else {
                    if let name = entry.name, let date = entry.date, let note = entry.note, let typeText = entry.type, let type = Type(rawValue: typeText), let sourceText = entry.source, let source = Source(rawValue: sourceText) {
                      
                        let newExpense = Expense(name: name, amount: entry.amount, date: date, note: note, source: source, type: type)
                        EntryManager.entries.append(newExpense)
                    }
                }
            }
            
            EntryManager.entries = EntryManager.entries.sorted(by: {$0.date > $1.date})
            print(EntryManager.entries)
        
            EntryManager.all = groupEntries(entries: EntryManager.entries)
        } catch let error as NSError {
            //showAlert(title: "Could not retrieve data", message: "\(error.userInfo)")
        }
    }

    // MARK: IBActions
    
    @IBAction func setBudgetPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "setBudget", sender: Any?.self)
    }
    
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
    func numberOfSections(in tableView: UITableView) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return EntryManager.all.count
        case 1:
            return EntryManager.incomes.count
        case 2:
            return EntryManager.expenses.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return EntryManager.all[section].count
        case 1:
            return EntryManager.incomes[section].count
        case 2:
            return EntryManager.expenses[section].count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            if let item = EntryManager.all[section].first {
                let month = item.date.monthAsString()
                let year = item.date.yearAsString()
                return "\(month) \(year)"
            } else {
                return nil
            }
        case 1:
            if let item = EntryManager.incomes[section].first {
                let month = item.date.monthAsString()
                let year = item.date.yearAsString()
                return "\(month) \(year)"
            } else {
                return nil
            }
        case 2:
            if let item = EntryManager.expenses[section].first {
                let month = item.date.monthAsString()
                let year = item.date.yearAsString()
                return "\(month) \(year)"
            } else {
                return nil
            }
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath) as! EntryTableViewCell
        
        var object: Entry
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            object = EntryManager.all[indexPath.section][indexPath.row]
        case 1:
            object = EntryManager.incomes[indexPath.section][indexPath.row]
        case 2:
            object = EntryManager.expenses[indexPath.section][indexPath.row]
        default:
            object = EntryManager.all[indexPath.section][indexPath.row]
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
