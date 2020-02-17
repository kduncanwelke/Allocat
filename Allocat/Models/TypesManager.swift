//
//  TypesManager.swift
//  Allocat
//
//  Created by Kate Duncan-Welke on 2/14/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation

struct TypesManager {
    static var incomeCategories: [Category: PieObject] = [
        .none: PieObject(name: "None", quantity: 0),
        .allocation: PieObject(name: "Allocation", quantity: 0),
        .dividends: PieObject(name: "Dividends", quantity: 0),
        .freelance: PieObject(name: "Freelance", quantity: 0),
        .gift: PieObject(name: "Gift", quantity: 0),
        .gig: PieObject(name: "Gig", quantity: 0),
        .other: PieObject(name: "Other", quantity: 0),
        .sales: PieObject(name: "Sales", quantity: 0),
        .selfEmployment: PieObject(name: "Self Employment", quantity: 0),
        .wages: PieObject(name: "Wages", quantity: 0),
    ]
    
    static var expenseCategories: [Type: PieObject] = [
        .none: PieObject(name: "None", quantity: 0),
        .clothing: PieObject(name: "Clothing", quantity: 0),
        .electronics: PieObject(name: "Electronics", quantity: 0),
        .entertainment: PieObject(name: "Entertainment", quantity: 0),
        .food: PieObject(name: "Food", quantity: 0),
        .fuel: PieObject(name: "Fuel", quantity: 0),
        .health: PieObject(name: "Health", quantity: 0),
        .home: PieObject(name: "Home", quantity: 0),
        .housing: PieObject(name: "Housing", quantity: 0),
        .insurance: PieObject(name: "Insurance", quantity: 0),
        .gifts: PieObject(name: "Gifts", quantity: 0),
        .media: PieObject(name: "Media", quantity: 0),
        .other: PieObject(name: "Other", quantity: 0),
        .outdoor: PieObject(name: "Outdoor", quantity: 0),
        .personal: PieObject(name: "Personal", quantity: 0),
        .pet: PieObject(name: "Pet", quantity: 0),
        .services: PieObject(name: "Services", quantity: 0),
        .subscriptions: PieObject(name: "Subscriptions", quantity: 0),
        .tax: PieObject(name: "Taxes", quantity: 0),
        .tools: PieObject(name: "Tools", quantity: 0),
        .transportation: PieObject(name: "Transportation", quantity: 0),
        .travel: PieObject(name: "Travel", quantity: 0),
        .utilities: PieObject(name: "Utilities", quantity: 0)
    ]
}

struct PieObject {
    let name: String
    var quantity: Int
}

enum Selection {
    case income
    case expense
}
