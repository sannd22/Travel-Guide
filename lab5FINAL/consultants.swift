//
//  consultants.swift
//  lab4
//
//  Created by David Sann on 4/24/19.
//  Copyright © 2019 David Sann. All rights reserved.
//

import Foundation
import os.log

class Consultant {
    
    let name: String?
    let interests: [String]?
    let location: String?
    let rating: String?
    let imageURL: String?
    let type: String?
    let uid: String?
    
    init(name: String, interests: [String], location: String, rating: String, imageURL: String, type: String, uid: String)
    {
        self.name = name
        self.imageURL = imageURL
        self.interests = interests
        self.location = location
        self.rating = rating
        self.type = type
        self.uid = uid
    }
}
