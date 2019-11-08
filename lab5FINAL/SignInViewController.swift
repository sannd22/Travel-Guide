//
//  SignInViewController.swift
//  lab5FINAL
//
//  Created by David Sann on 6/5/19.
//  Copyright © 2019 David Sann. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseAuth
import GoogleMobileAds


@objc(SignInViewController)
class SignInViewController: UIViewController, GIDSignInUIDelegate {
    
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    @IBOutlet weak var signUpButton: GIDSignInButton!
    
    var userExists: Bool!
    
    @IBAction func signInGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        let user = Auth.auth().currentUser
        if let user = user {
            print(userExists)
            ref = Database.database().reference()
            let userReference = ref.child("users").child(Auth.auth().currentUser!.uid)
            let values = ["name": Auth.auth().currentUser?.displayName, "email": Auth.auth().currentUser?.email]
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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "loggedIn" {
            let user = Auth.auth().currentUser
            if user != nil {
                return true
            }
            else {
                return false
            }
        }
        return false
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        let SignIn = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        SignIn.center = view.center
    }
}
