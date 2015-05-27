//
//  LoginViewController.swift
//  Anarcho-Cocoa
//
//  Created by Maksim on 27.05.15.
//  Copyright (c) 2015 Dima Sai. All rights reserved.
//


import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var applications : [Application] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        self.loginTextField.text = ""
        self.passwordTextField.text = ""
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showBuilds" {
            let buildsViewController = segue.destinationViewController as? BuildsViewController
            if let viewController = buildsViewController {
                viewController.applications = self.applications
            }
        }

    }

    func validateUserData() -> (Bool) {
        if self.loginTextField.text == "" {
            return false;
        }
        
        if self.passwordTextField.text == "" {
            return false;
        }
        self.loginButton.enabled = false
        return true
    }
    
    @IBAction func pressLoginButton(sender: UIButton) {
        if self.validateUserData() {
            let login : (String) = self.loginTextField.text
            let pass : (String) = self.passwordTextField.text
            
            AnarchoAPI().authorization(login, password: pass) { () -> Void in
                AnarchoAPI().getApps { (app) -> Void in
                    self.applications = app
                    self.performSegueWithIdentifier("showBuilds", sender: self)
                    self.loginButton.enabled = true
                }
                
            }
        }
    }
    
}