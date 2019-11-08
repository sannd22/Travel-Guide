//
//  Message.swift
//  lab5FINAL
//
//  Created by David Sann on 6/9/19.
//  Copyright © 2019 David Sann. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    @objc var text: String?
    @objc var fromID: String?
    @objc var timeStamp: NSNumber?
    @objc var toID: String?
    //var toID: String?
    
    func chatPartnerId() -> String? {
        if fromID == Auth.auth().currentUser?.uid {
            return toID
        } else {
            return fromID
        }
    }
}
