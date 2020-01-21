//
//  EntryManager.swift
//  Allocat
//
//  Created by Kate Duncan-Welke on 1/14/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation

struct EntryManager {
    static var entries: [Entry] = []
    static var savedEntries: [SavedEntry] = []

    static var expenses: [[Expense]] = [[]]
    static var incomes: [[Income]] = [[]]
    static var all: [[Entry]] = [[]]
}
