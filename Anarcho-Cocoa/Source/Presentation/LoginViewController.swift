//
//  LoginViewController.swift
//  Anarcho-Cocoa
//
//  Created by Maksim on 27.05.15.
//  Copyright (c) 2015 Dima Sai. All rights reserved.
//


import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate  {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var buttonWidth: NSLayoutConstraint!

    
    var applications : [Application] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Welcome"
        self.setUpTextField()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.passwordTextField.text = ""
    }
    
    func setUpTextField() {
        self.loginTextField.text = "msa@ciklum.com"
        self.passwordTextField.text = "123654"
        let colour = UIColor.blackColor().colorWithAlphaComponent(0.8)
        
        var placeholderLogin = NSAttributedString(string: "Email address:", attributes: [NSForegroundColorAttributeName : colour])
        self.loginTextField.attributedPlaceholder = placeholderLogin
        var placeholderPassword = NSAttributedString(string: "Password:", attributes: [NSForegroundColorAttributeName : colour])
        self.passwordTextField.attributedPlaceholder = placeholderPassword
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showBuilds" {
            let buildsViewController = segue.destinationViewController as? BuildsViewController
            if let viewController = buildsViewController {
                viewController.applications = self.applications
                viewController.userLogin = self.loginTextField.text
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
    
    @IBAction func pressLoginButton(sender: AnarchoButton) {
        self.view.endEditing(true)
        sender.startLoading(self.buttonWidth)
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(3 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            sender.endLoading(self.buttonWidth)
        }
        
//        if self.validateUserData() {
//            let login : (String) = self.loginTextField.text
//            let pass : (String) = self.passwordTextField.text
//            
//            AnarchoAPI().authorization(login, password: pass) { () -> Void in
//                AnarchoAPI().getApps { (app) -> Void in
//                    self.applications = app
//                    println(app)
//                    self.performSegueWithIdentifier("showBuilds", sender: self)
//                    self.loginButton.enabled = true
//                }
//                
//            }
//        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
        
    
}