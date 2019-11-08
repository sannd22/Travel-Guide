//
//  RegisterViewController.swift
//  lab5FINAL
//
//  Created by David Sann on 6/9/19.
//  Copyright © 2019 David Sann. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class RegisterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    
    @IBOutlet weak var typeControl: UISegmentedControl!
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var statePicker: UIPickerView!
    
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var displayName: UITextField!
    @IBOutlet weak var joinButton: UIButton!
    var name = false
    var last = false
    var display = false
    var type = "traveler"
    var pickerData: [String] = [String]()
    var row1 = 0;
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.statePicker.delegate = self
        self.statePicker.dataSource = self
        pickerData = ["Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","District of Columbia","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming"]
        statePicker.isHidden = true
        label1.isHidden = true
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let interestView = segue.destination as? InterestViewController else {
            fatalError("Unexpected destination")
        }
        interestView.type = type
        interestView.location = pickerData[row1]
    }
    
    func saveUser() {
        let user = Auth.auth().currentUser
        if let user = user {
            ref = Database.database().reference()
            let userReference = ref.child("users").child(Auth.auth().currentUser!.uid)
            let values = ["imageURL": Auth.auth().currentUser!.photoURL?.absoluteString ,"displayName": displayName.text, "first": firstName.text, "last": lastName.text, "email": Auth.auth().currentUser?.email, "location": pickerData[row1], "type": type] as [String : Any]
            userReference.updateChildValues(values as [String : Any], withCompletionBlock: { (err, ref)
                in
                
                if err != nil {
                    print(err)
                    return
                }
                print("Saved User")
            })
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        row1 = row;
    }
    
    @IBAction func firstEdit(_ sender: Any) {
        if firstName.text != "" {
            name = true
        }
        checkifDone()
    }
    
    @IBAction func lastEdit(_ sender: Any) {
        if lastName.text != "" {
            last = true
        }
        checkifDone()
    }
    
    @IBAction func displayEdit(_ sender: Any) {
        if displayName.text != "" {
            display = true
        }
        checkifDone()
    }
    
    func checkifDone() {
        if (name && last && display) {
            joinButton.backgroundColor = UIColor(red: 0.88, green: 0.37, blue: 0.59, alpha: 1.0)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func checkType(_ sender: Any) {
        switch typeControl.selectedSegmentIndex
        {
        case 0:
            type = "travelers"
            statePicker.isHidden = true
            label1.isHidden = true
        case 1:
            type = "guides"
            statePicker.isHidden = false
            label1.isHidden = false
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        saveUser()
        return true
    }

}
