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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        graph.delegate = self
        updateChart()
    }
    
    // MARK: Custom functions
    
    func updateChart() {
        var entries: [ChartDataEntry] = []
        guard let total = EntryManager.expenses.first?.count else { return }
        
        for i in 0..<total {
            var entry = ChartDataEntry(x: Double(i), y: EntryManager.expenses.first?[i].amount ?? 0)
            entries.append(entry)
        }
        
        let dataSet = LineChartDataSet(entries: entries, label: "Expenses")
        let data = LineChartData(dataSets: [dataSet])
        
        graph.xAxis.valueFormatter = DefaultAxisValueFormatter(block: {(index, _) in
            let date = EntryManager.expenses.first?[Int(index)].date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EE"
            let currentDateString: String = dateFormatter.string(from: date ?? Date())
            
            return currentDateString
        })
        
        graph.noDataText = "No step history available"
        dataSet.valueFont = UIFont.systemFont(ofSize: 12.0)
        dataSet.drawValuesEnabled = false
        graph.data = data
        graph.xAxis.labelFont = UIFont.systemFont(ofSize: 12.0)
        graph.xAxis.setLabelCount(EntryManager.expenses.first?.count ?? 0, force: true)
        graph.xAxis.labelPosition = .bottom
        graph.xAxis.granularity = 1.0
        graph.xAxis.granularityEnabled = true
        graph.xAxis.labelCount = EntryManager.expenses.first?.count ?? 0
        graph.xAxis.drawGridLinesEnabled = false
        
        graph.rightAxis.enabled = false
        graph.leftAxis.enabled = false
        let emptyVals = [Highlight]()
        graph.highlightValues(emptyVals)
        
        dataSet.colors = ChartColorTemplates.joyful()
        graph.notifyDataSetChanged()
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.setLocalizedDateFormatFromTemplate("ddMMyyyy")
        let string = formatter.string(from: EntryManager.expenses.first?[0].date ?? Date())
        
        //let steps = Int(HealthDataManager.stepHistory[0])
        //tapSteps.text = "\(steps) steps"
        //tapDate.text = string
        //tapDistance.text = "\(Int(HealthDataManager.distances[0])) \(Measures.preferred.rawValue)"
        
        graph.animate(yAxisDuration: 0.5)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
