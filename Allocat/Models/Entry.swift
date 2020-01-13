//
//  Entry.swift
//  Allocat
//
//  Created by Kate Duncan-Welke on 1/10/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation

protocol Entry {
    var name: String { get set }
    var amount: Double { get }
    var date: Date { get }
    var note: String { get set }
}
