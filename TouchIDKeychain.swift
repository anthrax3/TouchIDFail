//
//  TouchIDKeychain.swift
//  TouchIDTesting
//
//  Created by David Lindner on 11/2/15.
//  Copyright © 2015 David Lindner. All rights reserved.
//

import Foundation

let MyKeychainWrapper = KeychainWrapper()
let createLoginButtonTag = 0
let loginButtonTag = 1

@IBOutlet weak var loginButton: UIButton!

@IBAction func loginAction(sender: AnyObject) {
    
    // 1.
    if (usernameTextField.text == "" || passwordTextField.text == "") {
        let alertView = UIAlertController(title: "Login Problem",
            message: "Wrong username or password." as String, preferredStyle:.Alert)
        let okAction = UIAlertAction(title: "Foiled Again!", style: .Default, handler: nil)
        alertView.addAction(okAction)
        self.presentViewController(alertView, animated: true, completion: nil)
        return;
    }
    
    // 2.
    usernameTextField.resignFirstResponder()
    passwordTextField.resignFirstResponder()
    
    // 3.
    if sender.tag == createLoginButtonTag {
        
        // 4.
        let hasLoginKey = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
        if hasLoginKey == false {
            NSUserDefaults.standardUserDefaults().setValue(self.usernameTextField.text, forKey: "username")
        }
        
        // 5.
        MyKeychainWrapper.mySetObject(passwordTextField.text, forKey:kSecValueData)
        MyKeychainWrapper.writeToKeychain()
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLoginKey")
        NSUserDefaults.standardUserDefaults().synchronize()
        loginButton.tag = loginButtonTag
        
        performSegueWithIdentifier("dismissLogin", sender: self)
    } else if sender.tag == loginButtonTag {
        // 6.
        if checkLogin(usernameTextField.text!, password: passwordTextField.text!) {
            performSegueWithIdentifier("dismissLogin", sender: self)
        } else {
            // 7.
            let alertView = UIAlertController(title: "Login Problem",
                message: "Wrong username or password." as String, preferredStyle:.Alert)
            let okAction = UIAlertAction(title: "Foiled Again!", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
        }
    }
}

