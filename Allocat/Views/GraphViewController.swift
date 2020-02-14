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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        graph.delegate = self
        updateChart()
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
        var categories: [String: Int]
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            entryList = EntryManager.expenses
            categories = TypesManager.expenseCategories
        case 1:
            entryList = EntryManager.incomes
            categories = TypesManager.incomeCategories
        default:
            entryList = EntryManager.expenses
            categories = TypesManager.expenseCategories
        }
        
        guard let list = entryList.first else { return }
        
        for item in list {
            switch item {
            case is Expense:
                guard let expense = item as? Expense else { return }
              
                var clothing = 0
                var electronics = 0
                
                switch expense.type {
                case .clothing:
                    clothing += 1
                case .electronics:
                    electronics += 1
                case .entertainment:
                    <#code#>
                case .food:
                    <#code#>
                case .fuel:
                    <#code#>
                case .health:
                    <#code#>
                case .home:
                    <#code#>
                case .housing:
                    <#code#>
                case .insurance:
                    <#code#>
                case .gifts:
                    <#code#>
                case .media:
                    <#code#>
                case .none:
                    <#code#>
                case .other:
                    <#code#>
                case .outdoor:
                    <#code#>
                case .personal:
                    <#code#>
                case .pet:
                    <#code#>
                case .services:
                    <#code#>
                case .subscriptions:
                    <#code#>
                case .tax:
                    <#code#>
                case .tools:
                    <#code#>
                case .transportation:
                    <#code#>
                case .travel:
                    <#code#>
                case .utilities:
                    <#code#>
                @unknown default:
                    <#code#>
                }
            case is Income:
            default:
                break
            }
        }
        
         var entry1 = PieChartDataEntry(value: 0, label: "Gift")
     
        let entry1 = PieChartDataEntry(value: Double(number1.value), label: "#1")
        let entry2 = PieChartDataEntry(value: Double(number2.value), label: "#2")
        let entry3 = PieChartDataEntry(value: Double(number3.value), label: "#3")
        
        let dataSet = PieChartDataSet(entries: entries, label: "Widget Types")
        let data = PieChartData(dataSet: dataSet)
        pieChart.data = data
        pieChart.chartDescription?.text = "Share of Widgets by Type"
        
     
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
