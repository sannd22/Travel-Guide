//
//  ChatLogViewController.swift
//  
//
//  Created by David Sann on 6/9/19.
//

import UIKit
import Firebase
import GoogleSignIn

class ChatLogViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatLogTable.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)
        cell.textLabel?.text = messages[indexPath.row].text
        if (messages[indexPath.row].toID == messages[indexPath.row].chatPartnerId()) {
            cell.textLabel?.textAlignment = .right
            cell.backgroundColor = UIColor(red: 0.88, green: 0.37, blue: 0.59, alpha: 1.0)
            cell.textLabel?.textColor = UIColor.white
            return cell
        }
        cell.backgroundColor = UIColor.lightGray
        cell.textLabel?.textColor = UIColor.black
        return cell
    }
    
    
    @IBOutlet weak var chatLogTable: UITableView!
    
    @IBOutlet weak var textField: UITextField!
    
    var recipient: Consultant?
    var rec_id: String?
    
    var messages = [Message]()
    
    @IBOutlet weak var sendButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatLogTable.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        navigationItem.title = recipient?.name
        
        textField?.delegate = self
        self.chatLogTable.separatorStyle = UITableViewCell.SeparatorStyle.none
        observeMessages()

        // Do any additional setup after loading the view.
    }
    
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: {(snapshot) in
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dict = snapshot.value as? [String: AnyObject] else {
                    return
                }
                let message = Message()
                message.setValuesForKeys(dict)
                
                if message.chatPartnerId() == self.rec_id {
                    self.messages.append(message)
                    DispatchQueue.main.async {
                        self.chatLogTable.reloadData()
                    }
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    @objc func handleSend(_ sender: Any) {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let FROMID = Auth.auth().currentUser!.uid
        let time = NSNumber(value: NSDate().timeIntervalSince1970)
        let toID = recipient?.uid
        let values = ["text": textField.text!, "fromID": FROMID, "timeStamp": time, "toID": toID] as [String : Any]
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error ?? "")
                return
            }
            let userMessagesRef = Database.database().reference().child("user-messages").child(FROMID)
            guard let messageId = childRef.key else { return }
            userMessagesRef.child(messageId).setValue(1)
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toID!).child(messageId)
            recipientUserMessagesRef.setValue(1)
        }
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
