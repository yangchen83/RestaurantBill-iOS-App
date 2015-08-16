//
//  Bill.swift
//  RestaurantBill
//
//  Created by Yang Chen on 6/28/15.
//  Copyright (c) 2015 Yang Chen. All rights reserved.
//

import Foundation

class Bill {
    var serviceLevel: ServiceLevel = ServiceLevel.Poor

    // i should not hard code the check here, but if I put an empty dict here and try to set the check in the ViewController, I get errors, didn't figure out why
    var check = [FoodAndDrink.Burger: [0,0], FoodAndDrink.Salad: [0,0], FoodAndDrink.Coke: [0,0]]
    var baseTotal: Int {
        get {
            var total = 0
            for (key, value) in check {
                total += value[0] * value[1]
            }
            return total
        }
    }
    
    var tip: Int {
        get {
            return Int(round(Double(baseTotal) * serviceLevel.rawValue))
        }
    }
    var tax: Int {
        get {
            return Int(round(Double(baseTotal) * Tax.taxRate))
        }
    }
    var finalTotal: Int {
        get {
            return baseTotal + tip + tax
        }
    }
    
    func addLineItem(description: String, quantity: Int, price: Int){
        if let i = check[description] {
            check[description]![0] += quantity
            check[description]![1] = price
        } else {
            check[description] = [quantity, price]
        }
        //baseTotal += quantity * price
    }
}

struct Tax {
    static let taxRate = 0.07
}

struct FoodAndDrink {
    static let Burger = "Burger"
    static let Salad = "Salad"
    static let Coke = "Coke"
}

enum ServiceLevel: Double {
    case Poor = 0.15
    case Good = 0.18
    case Excellent = 0.20
    
    static let allValues = ["Poor", "Good", "Excellent"]
}
