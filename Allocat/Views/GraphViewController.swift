//
//  GraphViewController.swift
//  Allocat
//
//  Created by Kate Duncan-Welke on 2/12/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit
import Charts

class GraphViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var graph: LineChartView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var pieChart: PieChartView!
    
    var selection: Selection = .expense
    var expenseLoaded = false
    var incomeLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        graph.delegate = self
        updateChart()
        updatePieChart()
    }
    
    // MARK: Custom functions
    
    func updateChart() {
        var entries: [ChartDataEntry] = []
        
        var entryList: [[Entry]]
        var typeText: String
        var fillColor: UIColor
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            entryList = EntryManager.expenses
            typeText = "Expenses"
            fillColor = .red
        case 1:
            entryList = EntryManager.incomes
            typeText = "Income"
            fillColor = .green
        default:
            entryList = EntryManager.expenses
            typeText = "Expenses"
            fillColor = .red
        }
        
        guard let total = entryList.first?.count else { return }
        
        for i in 0..<total {
            var entry = ChartDataEntry(x: Double(i), y: entryList.first?[i].amount ?? 0)
            entries.append(entry)
        }
        
        let dataSet = LineChartDataSet(entries: entries, label: typeText)
        let data = LineChartData(dataSets: [dataSet])
        
        graph.xAxis.valueFormatter = DefaultAxisValueFormatter(block: {(index, _) in
            let title = entryList.first?[Int(index)].name ?? ""
            return title
        })
        
        graph.noDataText = "No history available"
        graph.data = data
        
        dataSet.valueFont = UIFont.systemFont(ofSize: 12.0)
        dataSet.drawValuesEnabled = false
        dataSet.mode = .cubicBezier
        dataSet.drawFilledEnabled = true
        dataSet.fillAlpha = 0.2
        dataSet.fill = Fill.fillWithColor(fillColor)
        dataSet.colors = ChartColorTemplates.joyful()
        dataSet.circleColors = ChartColorTemplates.joyful()
        
        graph.xAxis.labelFont = UIFont.systemFont(ofSize: 12.0)
        graph.xAxis.setLabelCount(entryList.first?.count ?? 0, force: true)
        graph.xAxis.labelPosition = .bottom
        graph.xAxis.granularity = 1.0
        graph.xAxis.granularityEnabled = true
        graph.xAxis.labelCount = entryList.first?.count ?? 0
        graph.xAxis.drawGridLinesEnabled = false
        graph.xAxis.labelTextColor = UIColor.label
        
        graph.leftAxis.labelTextColor = UIColor.label
        graph.rightAxis.labelTextColor = UIColor.label
        graph.legend.textColor = UIColor.label
        
        let emptyVals = [Highlight]()
        graph.highlightValues(emptyVals)
        graph.notifyDataSetChanged()
        graph.animate(yAxisDuration: 0.5)
    }

    func updatePieChart() {
        var entries: [ChartDataEntry] = []
        
        var entryList: [[Entry]]
    
        switch segmentControl.selectedSegmentIndex {
        case 0:
            entryList = EntryManager.expenses
        case 1:
            entryList = EntryManager.incomes
        default:
            entryList = EntryManager.expenses
        }
        
        guard let list = entryList.first else { return }
        
        for item in list {
            switch item {
            case is Expense:
                guard let expense = item as? Expense else { return }
                
                if expenseLoaded == false {
                switch expense.type {
                case .clothing:
                    TypesManager.expenseCategories[.clothing]?.quantity += 1
                case .electronics:
                    TypesManager.expenseCategories[.electronics]?.quantity += 1
                case .entertainment:
                    TypesManager.expenseCategories[.entertainment]?.quantity += 1
                case .food:
                    TypesManager.expenseCategories[.food]?.quantity += 1
                case .fuel:
                   TypesManager.expenseCategories[.fuel]?.quantity += 1
                case .health:
                    TypesManager.expenseCategories[.health]?.quantity += 1
                case .home:
                    TypesManager.expenseCategories[.home]?.quantity += 1
                case .housing:
                   TypesManager.expenseCategories[.housing]?.quantity += 1
                case .insurance:
                   TypesManager.expenseCategories[.insurance]?.quantity += 1
                case .gifts:
                    TypesManager.expenseCategories[.gifts]?.quantity += 1
                case .media:
                   TypesManager.expenseCategories[.media]?.quantity += 1
                case .none:
                    TypesManager.expenseCategories[.none]?.quantity += 1
                case .other:
                    TypesManager.expenseCategories[.other]?.quantity += 1
                case .outdoor:
                   TypesManager.expenseCategories[.outdoor]?.quantity += 1
                case .personal:
                    TypesManager.expenseCategories[.personal]?.quantity += 1
                case .pet:
                    TypesManager.expenseCategories[.pet]?.quantity += 1
                case .services:
                    TypesManager.expenseCategories[.services]?.quantity += 1
                case .subscriptions:
                   TypesManager.expenseCategories[.subscriptions]?.quantity += 1
                case .tax:
                   TypesManager.expenseCategories[.tax]?.quantity += 1
                case .tools:
                    TypesManager.expenseCategories[.tools]?.quantity += 1
                case .transportation:
                    TypesManager.expenseCategories[.transportation]?.quantity += 1
                case .travel:
                    TypesManager.expenseCategories[.travel]?.quantity += 1
                case .utilities:
                    TypesManager.expenseCategories[.utilities]?.quantity += 1
                }
                }
                
           case is Income:
                guard let income = item as? Income else { return }
                
                if incomeLoaded == false {
                switch income.category {
                case .allocation:
                    TypesManager.incomeCategories[.allocation]?.quantity += 1
                case .dividends:
                    TypesManager.incomeCategories[.dividends]?.quantity += 1
                case .freelance:
                    TypesManager.incomeCategories[.freelance]?.quantity += 1
                case .gift:
                    TypesManager.incomeCategories[.gift]?.quantity += 1
                case .gig:
                    TypesManager.incomeCategories[.gig]?.quantity += 1
                case .none:
                    TypesManager.incomeCategories[.none]?.quantity += 1
                case .other:
                    TypesManager.incomeCategories[.other]?.quantity += 1
                case .sales:
                    TypesManager.incomeCategories[.sales]?.quantity += 1
                case .selfEmployment:
                    TypesManager.incomeCategories[.selfEmployment]?.quantity += 1
                case .wages:
                    TypesManager.incomeCategories[.wages]?.quantity += 1
                }
                }
            default:
                break
            }
        }
        
        switch selection {
        case .expense:
            for (type, item) in TypesManager.expenseCategories {
                if item.quantity > 0 {
                    entries.append(PieChartDataEntry(value: Double(item.quantity), label: item.name))
                    print(type)
                    print(item.quantity)
                }
            }
            
            expenseLoaded = true
        case .income:
            for (type, item) in TypesManager.incomeCategories {
                if item.quantity > 0 {
                    entries.append(PieChartDataEntry(value: Double(item.quantity), label: item.name))
                    print(type)
                    print(item.quantity)
                }
            }
            
            incomeLoaded = true
        }
        
        let dataSet = PieChartDataSet(entries: entries, label: "")
        let data = PieChartData(dataSet: dataSet)
        pieChart.data = data
        pieChart.holeColor = UIColor.systemBackground
        dataSet.entryLabelColor = UIColor.gray
        pieChart.legend.textColor = UIColor.label
        dataSet.colors = ChartColorTemplates.joyful()
     
        pieChart.notifyDataSetChanged()
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
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        updateChart()
         
        if segmentControl.selectedSegmentIndex == 0 {
            selection = .expense
        } else {
            selection = .income
        }
        
        updatePieChart()
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: Chart delegate

extension GraphViewController: ChartViewDelegate {
    /*func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let index = Int(entry.x)
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.setLocalizedDateFormatFromTemplate("ddMMyyyy")
        let string = formatter.string(from: HealthDataManager.dates[index])
        
        tapDate.text = string
        let steps = Int(HealthDataManager.stepHistory[index])
        tapSteps.text = "\(steps) steps"
        tapDistance.text = "\(Int(HealthDataManager.distances[index])) \(Measures.preferred.rawValue)"
    }*/
}
