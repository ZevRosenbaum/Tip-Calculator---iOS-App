//
//  TipViewController.swift
//  Prework
//
//  Created by Zev Rosenbaum on 12/28/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billAmountTextField: UITextField!
    @IBOutlet weak var tipAmountLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var sliderLabel: UILabel!
    private var currencySymbol = "$"
    // For slider increments
    let step: Float = 0.01
    // Access UserDefaults
    let defaults = UserDefaults.standard
    
    @IBAction func sliderValueIncrement(sender: UISlider) {
        // Increment the slider by 1
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Sets the title in the Navigation Bar
        self.title = "Tip Calculator"
        // Set default values
        setDefaults()
        billAmountTextField.text = ""
    }
    
    func setDefaults() {
        // setDefaults() sets the default values based on the user-selected default options
        
        // Sets default value for Tip Slider label
        let percTip = defaults.string(forKey: "defaultTipLabel.text")
        sliderLabel.text = percTip
        let tipSlideVal = defaults.double(forKey: "defaultTipSlider.value")
        tipSlider.setValue(Float(tipSlideVal),animated: true)
        let defSegmentIndex = defaults.integer(forKey: "defaultSegmentIndex")
        tipControl.selectedSegmentIndex = defSegmentIndex
        
        // Default background color
        let isReset = defaults.bool(forKey: "defaultColorBool")
        // If the color wasn't reset, set the color
        if isReset == false {
            let bgColorSliderDefault = defaults.double(forKey: "bgColorSlider")
            let color = UIColor(hue: bgColorSliderDefault, saturation: 1.0, brightness: 1.0, alpha: 1.0)
            self.view.backgroundColor = color
        }
        // If the color was reset, set the color to default white
        else {
            self.view.backgroundColor = UIColor.white
        }
        
        // Get currency
        let pickerRow = defaults.integer(forKey: "pickerRow")
        if pickerRow == 1 {
            currencySymbol = "€"
        }
        else if pickerRow == 2 {
            currencySymbol = "£"
        }
        else if pickerRow == 3 {
            currencySymbol = "¥"
        }
        else {
            currencySymbol = "$"
        }
        
        calculateTipSlider(tipSlider)
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        // sliderValueChanged() sets the sliderLabel value and tipControl value
        // based on tipSlider value
        
        sliderLabel.text = "\(Int(tipSlider.value*100))"+"%"
        calculateTipSlider(tipSlider)
        if (Int(tipSlider.value*100) < 18) {
            tipControl.selectedSegmentIndex = 0
        }
        else if (Int(tipSlider.value*100) < 20) {
            tipControl.selectedSegmentIndex = 1
        }
        else {
            tipControl.selectedSegmentIndex = 2
        }
    }
    
    @IBAction func calculateTipSlider(_ sender: UISlider) {
        // Calculate Tip Amount and Total Amount based on the tip slider
        
        // Get bill amount from text field input
        let bill = Double(billAmountTextField.text!) ?? 0
        
        // Get Total tip by multiplying tip * tipPercentage
        let tip = bill * (Double(Int(tipSlider.value*100))/100)
        let total = bill + tip
        
        // Update Tip Amount Label
        tipAmountLabel.text = currencySymbol+String(format: "%.2f", tip)
        // Update Total Amount
        totalLabel.text = currencySymbol+String(format: "%.2f", total)
    }
    
    @IBAction func calculateTipControl(_ sender: Any) {
        // Calculate Tip Amount and Total Amount based on the segmented tip control
        
        // Get bill amount from text field input
        let bill = Double(billAmountTextField.text!) ?? 0
        
        let tipPercentages = [0.15,0.18,0.20]
        
        // Set tipSlider value based on Segment Bar
        if tipPercentages[tipControl.selectedSegmentIndex] == 0.15 {
            tipSlider.setValue(0.15,animated: true)
            sliderLabel.text = "15%"
        }
        if tipPercentages[tipControl.selectedSegmentIndex] == 0.18 {
            tipSlider.setValue(0.18,animated: true)
            sliderLabel.text = "18%"
        }
        if tipPercentages[tipControl.selectedSegmentIndex] == 0.20 {
            tipSlider.setValue(0.20,animated: true)
            sliderLabel.text = "20%"
        }
        
        // Get Total tip by multiplying tip * tipPercentage
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        
        // Update Tip Amount Label
        tipAmountLabel.text = currencySymbol+String(format: "%.2f", tip)
        // Update Total Amount
        totalLabel.text = currencySymbol+String(format: "%.2f", total)
    }

    @IBAction func resetVals(_ sender: Any) {
        // Reset default values after user clicks reset button
        
        // Update Bill Amount Text Field to blank
        billAmountTextField.text = String("")
        
        // Update Tip Amount Label to $0.00
        tipAmountLabel.text = String(format: "$%.2f", 0)
        
        // Update Total Amount to $0.00
        totalLabel.text = String(format: "$%.2f", 0)
        
        // Update Tip Control to default
        tipControl.selectedSegmentIndex = 0
        
        // Save default values to memory
        defaults.set("15%", forKey: "defaultTipLabel.text")
        defaults.set(0.15, forKey: "defaultTipSlider.value")
        defaults.set(1.0, forKey: "bgColorSlider")
        defaults.set(0, forKey: "pickerRow")
        defaults.set(0, forKey: "defaultSegmentIndex")
        defaults.synchronize()
        
        // Sets default value for Tip Slider label
        let percTip = defaults.string(forKey: "defaultTipLabel.text")
        sliderLabel.text = percTip
        let tipSlideVal = defaults.double(forKey: "defaultTipSlider.value")
        tipSlider.setValue(Float(tipSlideVal),animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Calls setDefaults() function after setting screen closes to implement changes
        
        print("view will appear")
        setDefaults()
    }
}
