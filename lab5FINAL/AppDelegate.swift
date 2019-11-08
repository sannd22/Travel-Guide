//
//  AppDelegate.swift
//  lab5FINAL
//
//  Created by David Sann on 5/5/19.
//  Copyright © 2019 David Sann. All rights reserved.
//
//
// The app works without crashing and has all tabs that will be in the final project
// The login screen and app messenger have appropraite viewers but have not been implemented yet
// At the map screen you MUST pick a US city or it will tell you to select a different location
// Since I have not populated the app with Guides yet, when you go the guide list for a specific city the json data for the list of US Cities is temporarily displayed, instead of a list of guides for that area. When a city (will be a guide) is clicked the user is sent to the soon to be messenger where they can contact the guide.


import UIKit

import Firebase
import GoogleSignIn
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder,  UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
   
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print("ERROR")
            return
        }

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                // ...
                return
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }
}
