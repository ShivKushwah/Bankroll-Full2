//
//  SignUpController.swift
//  Bankroll
//
//  Created by Mohan Lakshmanan on 3/21/15.
//  Copyright (c) 2015 AD. All rights reserved.
//

import UIKit
import SWXMLHash


class SignUpController: UIViewController {
    
    var timer: NSTimer!
    var accountCreated = false
    
    @IBOutlet var userField : UITextField!
    @IBOutlet var passField : UITextField!
    @IBOutlet var emailField : UITextField!
    @IBOutlet var nameField : UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var dobField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: UIButton!) {
        performSegueWithIdentifier("cancelSegue", sender: self)
    }
    
    @IBAction func createAccount(sender: UIButton!) {
        //Formats the login data as XML using the custom XMLWriter class
        let xmlWriter : XMLWriter = XMLWriter()
        xmlWriter.addElementToGroup("Username", content: userField.text)
        xmlWriter.addElementToGroup("Password", content: passField.text)
        xmlWriter.addElementToGroup("Name", content: nameField.text)
        xmlWriter.addElementToGroup("Email", content: emailField.text)
        xmlWriter.addElementToGroup("Phone", content: phoneNumber.text)
        xmlWriter.addElementToGroup("DOB", content: dobField.text)
        xmlWriter.createElementThatEncapsulatesGroup("Root")
        
        println(xmlWriter.getXMLString())
        
        sendAccountDataToServer(xmlWriter.getXMLString(), password: Crypto.randomStringWithLength(200))
        timer = NSTimer(timeInterval: 0.5, target: self, selector: "checkCreated", userInfo: nil, repeats: true)
        let timer2 = NSTimer(timeInterval: 5.0, target: self, selector: "invalidateTimer", userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        NSRunLoop.currentRunLoop().addTimer(timer2, forMode: NSRunLoopCommonModes)
    }
    func sendAccountDataToServer(accountData: NSString, password : NSString) {
        let userKey = Crypto.randomStringWithLength(266) as String
        let param : Dictionary = ["key" : userKey]
        
        request(.POST, "http://msg.besaba.com/OpenAuthenticationSession.php", parameters: param)
            .validate()
            .response { (req, response, data, error) in
                //Parse the xml
                var xml = NSString(data: data as! NSData, encoding: NSUTF8StringEncoding)!
                let parser = SWXMLHash.parse(xml as String)
                let success = parser["Root"]["Success"].element?.text
                
                //Encrypt data with a password and encrypt the password
                let a : Crypto = Crypto(message: accountData, password: password)
                
                //Specify parameters to send
                let params : Dictionary = ["data" : a.getEncryptedDataAsString(), "password" : a.encryptPassword(parser["Root"]["Key"].element?.text as NSString!), "uk" : userKey]
                
                request(.POST, "http://msg.besaba.com/createAccount.php", parameters: params)
                    .validate()
                    .response { (request, response, data2, error) in
                        //Parse the xml
                        var xml2 = NSString(data: data2 as! NSData, encoding: NSUTF8StringEncoding)!
                        let parser2 = SWXMLHash.parse(xml2 as String)
                        let success2 = parser2["Root"]["Success"].element?.text!
                        
                        println(xml2)
                        
                        if success2! == "Yes" {
                            self.accountCreated = true
                        }
                }
        }
    }
    
    func checkCreated() {
        if self.accountCreated {
            performSegueWithIdentifier("signupSegue", sender: self)
        }
    }
    
    func invalidateTimer() {
        println("Account Creation Failed")
        timer.invalidate()
    }
    
  
    
    
    
}
