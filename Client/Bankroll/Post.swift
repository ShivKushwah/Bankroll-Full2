//
//  Post.swift
//  Bankroll
//
//  Created by Mohan Lakshmanan on 6/24/15.
//  Copyright (c) 2015 AD. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class Post {
    let poster : User? //Change to poster class that stores more info about the poster
    let timePosted : String?
    
    var postInformation : String? //Combine this with the img variables in a data class called PostData
    var img : UIImage?
    
    var isPublic : Bool?
    var viewRadius : Int?
    let postLocation : CLLocation?

    var ranking : Int? //Number of upvotes - downvotes
    var comments : [String]? //The comments
    
    class func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789               "
        
        var randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }

    
    init() {
        //The below initializations are not final
        self.postInformation = Post.randomStringWithLength(Int(arc4random_uniform(499)+1)) as! String
        self.img = UIImage(named: "postImage.jpg")
        self.timePosted = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        
        //The below initializations are finalized
        self.poster = User()
        self.postLocation = ACLocation().getCurrentLocation()
        self.ranking = 0
        self.comments = [String]()
    }
}
