//
//  ViewController.swift
//  Allocat
//
//  Created by Kate Duncan-Welke on 1/9/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var moneyIn: UILabel!
    @IBOutlet weak var moneyOut: UILabel!
    @IBOutlet weak var limitSpent: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: IBActions
    
    @IBAction func addIncomeTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "addIncome", sender: Any?.self)
    }
    
    @IBAction func addExpensesTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "addExpense", sender: Any?.self)
    }
}

