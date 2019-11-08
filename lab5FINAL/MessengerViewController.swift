//
//  MessengerViewController.swift
//  lab5FINAL
//
//  Created by David Sann on 6/5/19.
//  Copyright © 2019 David Sann. All rights reserved.
//

import Photos
import UIKit
import Firebase
//import GoogleMobileAds
import Crashlytics

let kBannerAdUnitID = "ca-app-pub-3940256099942544/2934735716"


class MessengerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    var newChat: Consultant?
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MessegeCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MessegeCell else {
            fatalError("ERROR")
        }
        
        let message = messages[indexPath.row]
        if let toID = message.chatPartnerId() {
            let ref = Database.database().reference().child("users").child(toID)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    cell.name.text = String(dictionary["first"] as! String) + " " + String(dictionary["last"] as! String)
                    
                }
                
            }, withCancel: nil)
        }
        let date = NSDate(timeIntervalSince1970: message.timeStamp!.doubleValue)
        
        let dateForm = DateFormatter()
        dateForm.dateFormat = "hh:mm:ss a"
        
        cell.timeLabel.text = dateForm.string(from: date as Date)
        cell.location.text = message.text
        return cell
    }
    
    
    @IBOutlet weak var logOut: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //observeMessages()
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        observeUserMessages()
        if newChat != nil {
            showChatController(newChat!)
        }
    }
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messageReference = Database.database().reference().child("messages").child(messageId)
            messageReference.observeSingleEvent(of: .value, with: {(snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let message = Message()
                    message.setValuesForKeys(dictionary)
                    self.messages.append(message)
                    if let toID = message.toID {
                        self.messagesDictionary[toID] = message
                        self.messages = Array(self.messagesDictionary.values)
                        self.messages.sort(by: { (m1, m2) -> Bool in
                            return m1.timeStamp!.intValue > m2.timeStamp!.intValue
                        })
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }, withCancel: nil)
        }, withCancel: nil)
        
    }
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            print(snapshot)
            guard let dictionary = snapshot.value as? [String: AnyObject]
                else {
                    return
            }
            let rec = Consultant(name: dictionary["first"] as! String, interests: ["hello"], location: dictionary["location"] as! String, rating: dictionary["email"] as! String, imageURL: dictionary["imageURL"] as! String, type: dictionary["type"] as! String, uid: chatPartnerId)
                self.showChatController(rec)
            
        }, withCancel: nil)
    }
    
    func showChatController(_ recipient: Consultant) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatLog") as! ChatLogViewController
        vc.recipient = recipient
        vc.rec_id = recipient.uid
        self.show(vc, sender: self)
        
        
    }
    
    func observeMessages() {
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message()
                message.setValuesForKeys(dictionary)
                self.messages.append(message)
                if let toID = message.toID {
                    self.messagesDictionary[toID] = message
                    self.messages = Array(self.messagesDictionary.values)
                    self.messages.sort(by: { (m1, m2) -> Bool in
                        return m1.timeStamp!.intValue > m2.timeStamp!.intValue
                    })
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
            
        }, withCancel: nil)
        
    }
    
    @IBAction func logOut(_ sender: Any) {
        try! Auth.auth().signOut()
        
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            self.present(vc, animated: true, completion: nil)
        }
        /*
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        */
    }
}
