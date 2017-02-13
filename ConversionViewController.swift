//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Jackson Inchalik on 1/28/17.
//  Copyright © 2017 Jackson Inchalik. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet var celsiusLabel: UILabel!
    var fahrenheitValue: Measurement<UnitTemperature>? {
        didSet {
            updateCelsiusLabel()
        }
    }
    
    var celsiusValue: Measurement<UnitTemperature>?{
        if let fahrenheitValue = fahrenheitValue{
            return fahrenheitValue.converted(to: .celsius)
        } else{
            return nil
        }
    }
    @IBOutlet var textField: UITextField!
    
    @IBAction func fahrenheitFieldEditingChanged(_ textField:  UITextField){
        if let text = textField.text, let value = Double(text) {
            fahrenheitValue = Measurement(value: value, unit: .fahrenheit)
        } else {
            fahrenheitValue = nil
        }
    }
    
    @IBAction func dismissKeyBoard(_ sender: UITapGestureRecognizer){
        textField.resignFirstResponder()
    }
    
    func updateCelsiusLabel() {
        if let celsiusValue = celsiusValue {
            celsiusLabel.text =
                numberFormatter.string(from: NSNumber(value: celsiusValue.value))
        } else {
            celsiusLabel.text = "???"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ConversionViewController loaded its view.")
        
        updateCelsiusLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //var today = Date()
        let hour = Calendar.current.component(.hour, from: Date())
        
        //print(today)
        print(hour)
        
        if(hour >= 18 || hour <= 6)
        {
            self.view.backgroundColor = UIColor.black
        } else
        {
            self.view.backgroundColor = UIColor.blue.withAlphaComponent(0.6)
        }
        
    }
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) ->  Bool{
        
        let existingTextHasDecimalSeperator = textField.text?.range(of: ".")
        let replacementTextHasDecimalSeperator = string.range(of: ".")
        
        let letters = NSCharacterSet.letters
        let specialChars = NSMutableCharacterSet()
        specialChars.addCharacters(in: "!@#--------$%^&*(/><';:])[-}=\\{_.|,?~`\"+")

        if(string.rangeOfCharacter(from: letters) != nil || string.rangeOfCharacter(from: specialChars as CharacterSet) != nil)
        {
            return false
        } else
            if existingTextHasDecimalSeperator != nil,
                replacementTextHasDecimalSeperator != nil {
                return false
            } else {
                return true
            }
    }
    
}
