//
//  DashboardViewController.swift
//  MrATest
//
//  Created by Kevin Fachal on 16/11/20.
//

import UIKit

class DashboardViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    
    var categoryPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryField.attributedPlaceholder = NSAttributedString(string: "Choose Category here",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        findButton.isEnabled = false
        findButton.layer.cornerRadius = 8
        
        categoryPicker = UIPickerView()
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        categoryField.inputView = categoryPicker
    }

    @IBAction func categoryEnd(_ sender: Any) {
        if categoryField.text?.isEmpty == true {
            findButton.isEnabled = false
        } else {
            findButton.isEnabled = true
        }
    }
    
    
    @IBAction func findAction(_ sender: Any) {
        performSegue(withIdentifier: "toList", sender: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view?.endEditing(true)
        return false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view?.endEditing(true)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var stringRows = ""
        if pickerView == categoryPicker {
            stringRows = categoryList[row]
        }
        
        return stringRows
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if pickerView == categoryPicker {
            categoryField.text! = categoryList[row]
            UserDefaults.standard.set(categoryList[row], forKey: "category")
            self.view.endEditing(true)
        }
    }

}

