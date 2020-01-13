//
//  Expense.swift
//  Allocat
//
//  Created by Kate Duncan-Welke on 1/9/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation

struct Expense: Entry {
    var name: String
    let amount: Double
    let date: Date
    var note: String
    let source: Source
    let type: Type
}

enum Type: String {
    case clothing = "Clothing"
    case electronics = "Electronics"
    case entertainment = "Entertainment"
    case food = "Food"
    case fuel = "Fuel"
    case health = "Health"
    case home = "Home"
    case housing = "Housing"
    case gifts = "Gifts"
    case media = "Media"
    case none = "None"
    case other = "Other"
    case outdoor = "Outdoor"
    case personal = "Personal"
    case pet = "Pet"
    case services = "Services"
    case subscriptions = "Subscriptions"
    case tools = "Tools"
    case travel = "Travel"
    case utilities = "Utilities"
}

enum Source: String {
    case bank = "Bank"
    case cash = "Cash"
    case check = "Check"
    case credit = "Credit"
    case debit = "Debit"
    case none = "None"
    // add paypal? venmo?
}
