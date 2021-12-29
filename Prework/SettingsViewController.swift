//
//  SettingsViewController.swift
//  Prework
//
//  Created by Zev Rosenbaum on 12/28/21.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private var currSelection = "$"
    private let dataSource = ["$","€","£","¥"]
    @IBOutlet weak var defaultTipLabel: UILabel!
    @IBOutlet weak var defaultTipSlider: UISlider!
    @IBOutlet weak var currency: UIPickerView!
    @IBOutlet weak var bgColorSlider: UISlider!
    @IBOutlet weak var defaultColorButton: UIButton!
    @IBOutlet weak var resetAll: UIButton!
    // For slider increments
    let step: Float = 0.01
    // Access UserDefaults
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets default value for Tip Slider label
        let percTip = defaults.string(forKey: "defaultTipLabel.text")
        defaultTipLabel.text = percTip
        let tipSlideVal = defaults.double(forKey: "defaultTipSlider.value")
        defaultTipSlider.setValue(Float(tipSlideVal),animated: true)
        
        // Currency Picker View
        currency.dataSource = self
        currency.delegate = self
        let pickerRow = defaults.integer(forKey: "pickerRow")
        currency.selectRow(pickerRow, inComponent: 0, animated: false)
        
        // Set background color
        backgroundColorSet()
    }
    
    func backgroundColorSet() {
        // Set the background color of the bgColorSlider
        
        // Set background color
        self.view.backgroundColor = UIColor.white
        
        // Set background color for color slider
        let isReset = defaults.bool(forKey: "defaultColorBool")
        // If the color wasn't reset, set the color
        if isReset == false {
            let bgColorSliderDefault = defaults.double(forKey: "bgColorSlider")
            let color = UIColor(hue: bgColorSliderDefault, saturation: 1.0, brightness: 1.0, alpha: 1.0)
            self.bgColorSlider.backgroundColor = color
            bgColorSlider.value = Float(bgColorSliderDefault)
        }
        // If the color was reset, set the color to default white
        else {
            bgColorSlider.backgroundColor = UIColor.white
            bgColorSlider.value = 1
        }
    }
    
    @IBAction func defaultColorClicked(_ sender: Any) {
        // Upon click of the defaultColorButton, the background color slider becomes white
        
        // Set background color for slider to white and value to 1
        bgColorSlider.value = 1
        bgColorSlider.backgroundColor = UIColor.white
        
        // Save these values to memory
        defaults.set(bgColorSlider.value, forKey: "bgColorSlider")
        defaults.set(true, forKey: "defaultColorBool")
        defaults.synchronize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func bgSliderValueChanged(_ sender: UISlider) {
        // bgSliderValueChanged() sets the bgColorSlider background color
        
        // color variable calculated based on bgColorSlider value
        let colorValue = CGFloat(bgColorSlider.value)
        let color = UIColor(hue: colorValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        // Background color set from slider value
        bgColorSlider.backgroundColor = color
        
        // Background color saved to memory for main page
        defaults.set(bgColorSlider.value, forKey: "bgColorSlider")
        defaults.set(false, forKey: "defaultColorBool")
        defaults.synchronize()
    }
    
    @IBAction func defaultSliderValueChanged(_ sender: Any) {
        // defaultSliderValueChanged() sets the default tip and defaultTipLabel
        
        defaultTipLabel.text = "\(Int(defaultTipSlider.value*100))"+"%"
        defaults.set(defaultTipLabel.text, forKey: "defaultTipLabel.text")
        defaults.set(defaultTipSlider.value, forKey: "defaultTipSlider.value")
        
        // segment_index is saved to memory and used to set the segmented tip control
        // based on default tip set by user
        var segment_index = 0
        if (Int(defaultTipSlider.value*100) < 18) {
            segment_index = 0
        }
        else if (Int(defaultTipSlider.value*100) < 20) {
            segment_index = 1
        }
        else {
            segment_index = 2
        }
        
        defaults.set(segment_index, forKey: "defaultSegmentIndex")
        defaults.synchronize()
    }
    
    @IBAction func resetAllDefaults(_ sender: Any) {
        // Reset all user settings to default app settings
        
        // Save default values
        defaults.set("15%", forKey: "defaultTipLabel.text")
        defaults.set(0.15, forKey: "defaultTipSlider.value")
        defaults.set(1.0, forKey: "bgColorSlider")
        defaults.set(true, forKey: "defaultColorBool")
        defaults.set(0, forKey: "defaultSegmentIndex")
        defaults.set(0, forKey: "pickerRow")
        defaults.synchronize()
        
        // Sets default value for Tip Slider label
        let percTip = defaults.string(forKey: "defaultTipLabel.text")
        defaultTipLabel.text = percTip
        let tipSlideVal = defaults.double(forKey: "defaultTipSlider.value")
        defaultTipSlider.setValue(Float(tipSlideVal),animated: true)
        
        // Default background color
        let bgColorSliderDefault = defaults.double(forKey: "bgColorSlider")
        bgColorSlider.value = Float(bgColorSliderDefault)
        self.view.backgroundColor = UIColor.white
        bgColorSlider.backgroundColor = UIColor.white
        
        // Set currency selector to the default '$' currency -- row 0.
        currency.selectRow(0, inComponent: 0, animated: false)
    }
    
    
    @IBAction func defaultSliderValueChanged(sender: UISlider) {
        // Increment the slider by 1
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currSelection = dataSource[row]
        defaults.set(row, forKey: "pickerRow")
        defaults.synchronize()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
}
