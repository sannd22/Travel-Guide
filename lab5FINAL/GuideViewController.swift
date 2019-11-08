//
//  GuideViewController.swift
//  lab5FINAL
//
//  Created by David Sann on 5/5/19.
//  Copyright © 2019 David Sann. All rights reserved.
//

import UIKit
import os.log

class GuideViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var connect: UIButton!
    
    @IBOutlet weak var prof: UIImageView!
    
    @IBOutlet weak var rating: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var interests: UILabel!
    
    var guide: Consultant?
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let newVC = segue.destination as? MessengerViewController else {
            fatalError("Unexpected destination")
        }
        newVC.newChat = guide
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = guide?.name
        rating.text = guide?.rating
        location.text = guide?.location
        var interests1 = ""
        for i in 0...(guide?.interests!.count)! - 1 {
            interests1 += (guide?.interests![i])!
            if (i != ((guide?.interests!.count)! - 2)) {
                interests1 += ", "
            }
            
        }
        interests.text = interests1
        let imageUrl = URL(string: (guide?.imageURL!)!)!
        
        let imageData = try! Data(contentsOf: imageUrl)
        
        let image = UIImage(data: imageData)
        prof.image = image
        
    }
}

