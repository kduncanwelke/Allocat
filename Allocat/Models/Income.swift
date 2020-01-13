//
//  Income.swift
//  Allocat
//
//  Created by Kate Duncan-Welke on 1/10/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation

struct Income: Entry {
    var name: String
    let date: Date
    let amount: Double
    var note: String
    let category: Category
}

enum Category: String {
    case allocation = "Allocation"
    case dividends = "Dividends"
    case freelance = "Freelance"
    case gift = "Gift"
    case gig = "Gig"
    case none = "None"
    case other = "Other"
    case sales = "Sales"
    case selfEmployment = "Self Employment"
    case wages = "Wages"
}
