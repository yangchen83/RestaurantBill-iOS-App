//
//  ViewController.swift
//  RestaurantBill
//
//  Created by Yang Chen on 6/27/15.
//  Copyright (c) 2015 Yang Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let bill = Bill()
    var servicePicker: [String] = []

    @IBOutlet weak var burgerNumber: UILabel!
    @IBOutlet weak var saladNumber: UILabel!
    @IBOutlet weak var cokeNumber: UILabel!
    
    @IBOutlet weak var burgerPrice: UITextField!
    @IBOutlet weak var saladPrice: UITextField!
    @IBOutlet weak var cokePrice: UITextField!
    
    @IBOutlet weak var baseTotal: UILabel!
    @IBOutlet weak var tip: UILabel!
    @IBOutlet weak var tax: UILabel!
    @IBOutlet weak var total: UILabel!
    
    @IBOutlet weak var servicePickerView: UIPickerView!
    @IBOutlet weak var serviceLevelButton: UIButton!
    
    @IBAction func serviceLevelChange(sender: AnyObject) {
        // show the picker view when the button is clicked
        servicePickerView.hidden = false
    }
    
    func updateSummery() {
        // reference: http://stackoverflow.com/questions/25339936/swift-double-to-string
        baseTotal.text = String(format:"%.2f", Double(bill.baseTotal)/100.0)
        tip.text = String(format:"%.2f", Double(bill.tip)/100.0)
        tax.text = String(format:"%.2f", Double(bill.tax)/100.0)
        total.text = String(format:"%.2f", Double(bill.finalTotal)/100.0)
    }
    
    // takes the user input of price from textField
    // return an Int of cents
    func textToIntInCent(price: UITextField) -> Int {
        return Int(floor(NSString(string: price.text).doubleValue * 100))
    }
    
    // when there is change on the textField, get the new values
    func textFieldDidChange(textField: UITextField) {
        var burgerPriceInCent = textToIntInCent(burgerPrice)
        var saladPriceInCent = textToIntInCent(saladPrice)
        var cokePriceInCent = textToIntInCent(cokePrice)
        if let i = bill.check[FoodAndDrink.Burger] {
            bill.check[FoodAndDrink.Burger]![1] = burgerPriceInCent
        }
        if let i = bill.check[FoodAndDrink.Salad] {
            bill.check[FoodAndDrink.Salad]![1] = saladPriceInCent
        }
        if let i = bill.check[FoodAndDrink.Coke] {
            bill.check[FoodAndDrink.Coke]![1] = cokePriceInCent
        }
        updateSummery()
    }
    
    // function for the plus button
    func uniformPlus(food: String, number: UILabel, price: UITextField) {
        var n = number.text?.toInt()
        // reference: http://stackoverflow.com/questions/24085665/convert-string-to-float-in-apples-swift
        var priceInCent = Int(floor((price.text as NSString).floatValue * 100))
        if let i = n {
            number.text = String(i+1)
            bill.addLineItem(food, quantity: 1, price: priceInCent)
            updateSummery()
        }
    }
    
    // function for the minus button
    func uniformMinus(food: String, number: UILabel, price: UITextField) {
        var n = number.text?.toInt()
        var priceInCent = textToIntInCent(price)
        if let i = n where i > 0 {
            // Only decrease the number if the current value is bigger than 0
            number.text = String(i - 1)
            bill.addLineItem(food, quantity: -1, price: priceInCent)
            updateSummery()
        }
    }

    @IBAction func burgerPlus(sender: AnyObject) {
        uniformPlus(FoodAndDrink.Burger, number: burgerNumber, price: burgerPrice)
    }
    
    @IBAction func burgerMinus(sender: AnyObject) {
        uniformMinus(FoodAndDrink.Burger, number: burgerNumber, price: burgerPrice)
    }
    
    @IBAction func saladPlus(sender: AnyObject) {
        uniformPlus(FoodAndDrink.Salad, number: saladNumber, price: saladPrice)
    }
    
    @IBAction func saladMinus(sender: AnyObject) {
        uniformMinus(FoodAndDrink.Salad, number: saladNumber, price: saladPrice)
    }
    
    @IBAction func cokePlus(sender: AnyObject) {
        uniformPlus(FoodAndDrink.Coke, number: cokeNumber, price: cokePrice)
    }
    
    @IBAction func cokeMinus(sender: AnyObject) {
        uniformMinus(FoodAndDrink.Coke, number: cokeNumber, price: cokePrice)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide the picker view at first
        servicePickerView.hidden = true
        
        // get the choices from the ServiceLevel enum
        servicePicker = ServiceLevel.allValues
        
        // set the default service level to be the first choice
        serviceLevelButton.setTitle(servicePicker[0], forState: UIControlState.Normal)
        
        // Monitor the price change in the textField
        // Reference: http://stackoverflow.com/questions/28394933/how-do-i-check-when-a-text-field-changes-in-swift
        burgerPrice.addTarget(self, action: "textFieldDidChange:", forControlEvents:UIControlEvents.EditingChanged)
        
        saladPrice.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        cokePrice.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // pickerView reference: https://www.youtube.com/watch?v=hqgp43s_B90
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return servicePicker.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return servicePicker[row]
    }
    
    // Reference: http://stackoverflow.com/questions/26819423/swift-show-uipickerview-text-field-is-selected-then-hide-after-selected
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // reference: http://stackoverflow.com/questions/26326296/changing-text-of-uibutton-programatically-swift
        serviceLevelButton.setTitle(servicePicker[row], forState: UIControlState.Normal)
        
        // link the picker view choice to the service level
        if row == 0 {
            bill.serviceLevel = ServiceLevel.Poor
        } else if row == 1 {
            bill.serviceLevel = ServiceLevel.Good
        } else {
            bill.serviceLevel = ServiceLevel.Excellent
        }
        
        // hide the picker view again after selection
        servicePickerView.hidden = true
        updateSummery()
    }
}
