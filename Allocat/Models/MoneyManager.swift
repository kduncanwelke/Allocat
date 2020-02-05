//
//  MoneyManager.swift
//  Allocat
//
//  Created by Kate Duncan-Welke on 1/29/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation

struct MoneyManager {
    static var loadedBudget: Budget?
    static var month = 0.0
    static var quarter = 0.0
    static var biannual = 0.0
    static var year = 0.0
    static var budgetTime: BudgetTime = .none
}

enum BudgetTime: Int {
    case month
    case quarter
    case biannual
    case year
    case none
}
