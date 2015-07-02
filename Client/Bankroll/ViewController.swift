//
//  ViewController.swift
//  Bankroll
//
//  Created by Mohan Lakshmanan on 3/21/15.
//  Copyright (c) 2015 AD. All rights reserved.
//

import UIKit
import SWXMLHash

class ViewController: UIViewController {
    
    @IBOutlet var userField : UITextField!
    @IBOutlet var passField : UITextField!

    var isLoggedIn = false
    var timer : NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendLoginToServer(loginData: NSString, password : NSString) {
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
                let a : Crypto = Crypto(message: loginData, password: password)
                
                //Specify parameters to send
                let params : Dictionary = ["data" : a.getEncryptedDataAsString(), "password" : a.encryptPassword(parser["Root"]["Key"].element?.text as NSString!), "uk" : userKey]
                
                request(.POST, "http://msg.besaba.com/login.php", parameters: params)
                    .validate()
                    .response { (request, response, data2, error) in
                        //Parse the xml
                        var xml2 = NSString(data: data2 as! NSData, encoding: NSUTF8StringEncoding)!
                        let parser2 = SWXMLHash.parse(xml2 as String)
                        let success2 = parser2["Root"]["Success"].element?.text!
                        
                        println(xml2)
                        
                        if success2! == "Yes" {
                            self.isLoggedIn = true
                        }
                }
        }
    }
    
    func checkLogin() {
        if self.isLoggedIn {
            performSegueWithIdentifier("loginSegue", sender: self)
        }
    }
    
    func invalidateTimer() {
        timer.invalidate()
    }
    
    @IBAction func login(sender: UIButton!) {
        //Formats the login data as XML using the custom XMLWriter class
        let xmlWriter : XMLWriter = XMLWriter()
        xmlWriter.addElementToGroup("Username", content: userField.text)
        xmlWriter.addElementToGroup("Password", content: passField.text)
        xmlWriter.createElementThatEncapsulatesGroup("Root")
        
        //println(xmlWriter.getXMLString())
        
        sendLoginToServer(xmlWriter.getXMLString(), password: Crypto.randomStringWithLength(200))
        timer = NSTimer(timeInterval: 0.5, target: self, selector: "checkLogin", userInfo: nil, repeats: true)
        let timer2 = NSTimer(timeInterval: 5.0, target: self, selector: "invalidateTimer", userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        NSRunLoop.currentRunLoop().addTimer(timer2, forMode: NSRunLoopCommonModes)
    }
    
    @IBAction func createAccount(sender: UIButton!) {
        performSegueWithIdentifier("signupSegue", sender: self)
    }
    
    @IBAction func bypassLogin(sender: AnyObject) {
        performSegueWithIdentifier("loginSegue", sender: self)

    }

}

