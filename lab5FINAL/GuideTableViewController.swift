//
//  GuideTableViewController.swift
//  lab5FINAL
//
//  Created by David Sann on 5/5/19.
//  Copyright © 2019 David Sann. All rights reserved.
//

import UIKit
import os.log
import Firebase
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn

class GuideTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var guides = [Consultant]()
    
    var city: String?
    
    var state: String?
    
    let stationsURL = "https://gist.githubusercontent.com/ahmu83/38865147cf3727d221941a2ef8c22a77/raw/c647f74643c0b3f8407c28ddbb599e9f594365ca/US_States_and_Cities.json"
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // unowned self to avoid reference cycle between VC and closure
        ref = Database.database().reference()
        let userReference = ref.child("users")
        userReference.observe(DataEventType.value, with: { (snapshot) in
                //Do not cast print it directly may be score is Int not string
                for guiders in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let value = guiders.value as? [String: AnyObject]
                    if (value?["location"] as? String == self.state && value?["type"] as? String == "guides") {
                        let name  = value?["interests"] as? [String: String] ?? ["None": "None"]
                        var interest = [String]()
                        for (key, value) in name {
                            interest.append(key)
                        }
                        let state  = value?["location"]
                        let address  = value?["email"]
                        let first = value?["first"] as! String
                        let last = value?["last"] as! String
                        let abbr  = first + " " + last
                        let image = value?["imageURL"]
                        let type1 = value?["type"]
                        self.guides.append(Consultant(name: abbr , interests: interest, location: state as! String, rating: address as! String, imageURL: image as! String, type: type1 as! String, uid: guiders.key))
                    }
                    
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            
        })
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddGuideMode = presentingViewController is UINavigationController
        
        if isPresentingInAddGuideMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    /*
    func jsonDrillDown(locationArray: [String: [String : Any]]) {
        
        for (key, value) in locationArray{
            let name  = value["first"] ?? "name"
            let state  = value["location"] ?? "loco"
            let address  = value["displayName"] ?? "disp"
            let abbr  = value["interests"] ?? "none"
            self.guides.append(Consultant(name: abbr as! String, interests: name as! String, location: state as! String, rating: address as! String)!)
        }
    }
    */
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guides.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "GuideTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GuideTableViewCell else {
            fatalError("ERROR")
        }

        let guide = guides[indexPath.row]
        
        cell.nameLabel.text = guide.name
        cell.locationLabel.text = guide.location
        
        let imageUrl = URL(string: guide.imageURL!)!
        
        let imageData = try! Data(contentsOf: imageUrl)
        
        let image = UIImage(data: imageData)
        cell.imageView?.image = image
        cell.imageView?.layer.borderWidth = 1
        cell.imageView?.layer.masksToBounds = false
        cell.imageView?.layer.borderColor = UIColor.black.cgColor
        cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.height)!/2
        cell.imageView?.clipsToBounds = true
        return cell
    }
    
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? GuideViewController, let guide = sourceViewController.guide {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                guides[selectedIndexPath.row] = guide
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: guides.count, section: 0)
                
                guides.append(guide)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            //saveGuides()
        }
    }

    
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new guide.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let guideDetailViewController = segue.destination as? GuideViewController else {
                fatalError("Unexpected destination")
            }
            
            guard let selectedGuideCell = sender as? GuideTableViewCell else {
                fatalError("Unexpected sender")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedGuideCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedGuide = guides[indexPath.row]
            guideDetailViewController.guide = selectedGuide
            
        default:
            fatalError("Unexpected Segue Identifier")
        }
    }
}
