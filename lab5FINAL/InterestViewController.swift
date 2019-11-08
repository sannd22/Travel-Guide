//
//  InterestViewController.swift
//  lab5FINAL
//
//  Created by David Sann on 6/9/19.
//  Copyright © 2019 David Sann. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import GoogleSignIn

class InterestViewController: UIViewController {

    @IBOutlet weak var selectLabel: UILabel!
    
    @IBOutlet weak var Sports: UIButton!
    @IBOutlet weak var Hiking: UIButton!
    @IBOutlet weak var wine: UIButton!
    @IBOutlet weak var dining: UIButton!
    @IBOutlet weak var surf: UIButton!
    @IBOutlet weak var fish: UIButton!
    @IBOutlet weak var museums: UIButton!
    @IBOutlet weak var resturant: UIButton!
    @IBOutlet weak var boutiques: UIButton!
    @IBOutlet weak var biking: UIButton!
    @IBOutlet weak var camping: UIButton!
    @IBOutlet weak var sightseeing: UIButton!
    
    @IBOutlet weak var finish: UIButton!
    
    var select = 5;
    var interests: [String]!
    
    var type: String?
    var location: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeRound(button: Sports)
        makeRound(button: Hiking)
        makeRound(button: wine)
        makeRound(button: dining)
        makeRound(button: surf)
        makeRound(button: fish)
        makeRound(button: museums)
        makeRound(button: resturant)
        makeRound(button: boutiques)
        makeRound(button: camping)
        makeRound(button: sightseeing)
        makeRound(button: biking)
        interests = []
        // Do any additional setup after loading the view.
    }
    
    func makeRound(button: UIButton) {
        button.backgroundColor = .clear
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        //button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderColor = UIColor(red: 0.88, green: 0.37, blue: 0.59, alpha: 1.0).cgColor
        button.setTitleColor(UIColor(red: 0.88, green: 0.37, blue: 0.59, alpha: 1.0), for: .normal)
        button.backgroundColor = UIColor.white
    }
    
    @IBAction func finish(_ sender: Any) {
        let user = Auth.auth().currentUser
        if let user = user {
            ref = Database.database().reference()
            let userReference = ref.child("users").child(Auth.auth().currentUser!.uid).child("interests")
            var values = ["Travel": "Travel"]
            for index in 0...interests.count - 1 {
                let item: [String: Any] = [
                    interests[index]: interests[index]
                ]
                values[interests[index]] = interests[index]
            }
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
    
    func click(button: UIButton) {
        select -= 1
        button.backgroundColor = UIColor(red: 0.88, green: 0.37, blue: 0.59, alpha: 1.0)
        button.setTitleColor(UIColor.white, for: .normal)
    }
    func unClick(button: UIButton) {
        select += 1
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor(red: 0.88, green: 0.37, blue: 0.59, alpha: 1.0), for: .normal)
    }
    func checkEnd() {
        if (select == 0) {
            finish.backgroundColor = UIColor(red: 0.88, green: 0.37, blue: 0.59, alpha: 1.0)
        }
        if (select <= 0) {
            selectLabel.text = "Select 0 Interests"
        } else {
            selectLabel.text = "Select " + String(select) + " Interests"
        }
    }
    @IBAction func bout(_ sender: Any) {
        if (boutiques.backgroundColor == UIColor.white) {
            click(button: boutiques)
            interests += ["Boutiques"]
        } else {
            unClick(button: boutiques)
            interests.removeAll { $0 == "Boutiques" }
        }
        checkEnd()
    }
    
    @IBAction func hike(_ sender: Any) {
        if (Hiking.backgroundColor == UIColor.white) {
            click(button: Hiking)
            interests += ["Hiking"]
        } else {
            unClick(button: Hiking)
            interests.removeAll { $0 == "Hiking" }
        }
        checkEnd()
    }
    @IBAction func wine(_ sender: Any) {
        if (wine.backgroundColor == UIColor.white) {
            click(button: wine)
            interests += ["Wine"]
        } else {
            unClick(button: wine)
            interests.removeAll { $0 == "Wine" }
        }
        checkEnd()
    }
    @IBAction func fish(_ sender: Any) {
        if (dining.backgroundColor == UIColor.white) {
            click(button: dining)
            interests += ["Fine Dining"]
        } else {
            unClick(button: dining)
            interests.removeAll { $0 == "Fine Dining" }
        }
        checkEnd()
    }
    @IBAction func surf(_ sender: Any) {
        if (surf.backgroundColor == UIColor.white) {
            click(button: surf)
            interests += ["Surfing"]
        } else {
            unClick(button: surf)
            interests.removeAll { $0 == "Surfing" }
        }
        checkEnd()
    }
    @IBAction func fishing(_ sender: Any) {
        if (fish.backgroundColor == UIColor.white) {
            click(button: fish)
            interests += ["Fishing"]
        } else {
            unClick(button: fish)
            interests.removeAll { $0 == "Fishing" }
        }
        checkEnd()
    }
    @IBAction func muse(_ sender: Any) {
        if (museums.backgroundColor == UIColor.white) {
            click(button: museums)
            interests += ["Museums"]
        } else {
            unClick(button: museums)
            interests.removeAll { $0 == "Museums" }
        }
        checkEnd()
    }
    @IBAction func sports(_ sender: Any) {
        if (Sports.backgroundColor == UIColor.white) {
            click(button: Sports)
            interests += ["Sports"]
        } else {
            unClick(button: Sports)
            interests.removeAll { $0 == "Sports" }
        }
        checkEnd()
    }
    @IBAction func rest(_ sender: Any) {
        if (resturant.backgroundColor == UIColor.white) {
            click(button: resturant)
            interests += ["Resturants"]
        } else {
            unClick(button: resturant)
            interests.removeAll { $0 == "Resturants" }
        }
        checkEnd()
    }
    @IBAction func bike(_ sender: Any) {
        if (biking.backgroundColor == UIColor.white) {
            click(button: biking)
            interests += ["Biking"]
        } else {
            unClick(button: biking)
            interests.removeAll { $0 == "Biking" }
        }
        checkEnd()
    }
    @IBAction func camo(_ sender: Any) {
        if (camping.backgroundColor == UIColor.white) {
            click(button: camping)
            interests += ["Camping"]
        } else {
            unClick(button: camping)
            interests.removeAll { $0 == "Camping" }
        }
        checkEnd()
    }
    @IBAction func sightsee(_ sender: Any) {
        if (sightseeing.backgroundColor == UIColor.white) {
            click(button: sightseeing)
            interests += ["Sightseeing"]
        } else {
            unClick(button: sightseeing)
            interests.removeAll { $0 == "Sightseeing" }
        }
        checkEnd()
    }
    
}
