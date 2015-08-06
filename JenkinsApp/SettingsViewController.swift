//
//  SettingsViewController.swift
//  JenkinsApp
//
//  Created by Ronald Broens on 08/02/15.
//  Copyright (c) 2015 Ronald Broens. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController : UIViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = JenkinsSettings()
        textboxUrl.text = settings.Url
        textboxUsername.text = settings.Username
        textboxPassword.text = settings.Password
    }
    
    
    @IBAction func BtnSaveClick(sender: UIButton)
    {
        let settings = JenkinsSettings()
        settings.Url = self.textboxUrl.text!
        settings.Username = self.textboxUsername.text!
        settings.Password = self.textboxPassword.text!
        settings.Save()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var textboxUrl: UITextField!
    @IBOutlet weak var textboxUsername: UITextField!
    @IBOutlet weak var textboxPassword: UITextField!

}

class JenkinsSettings
{
    var Url : String
    var Username : String
    var Password : String
    
    init()
    {
        let defaultSettings = NSUserDefaults.standardUserDefaults()
        
        let url = defaultSettings.valueForKey("jenkinsurl") as! String?
        let username = defaultSettings.valueForKey("username") as! String?
        let password = defaultSettings.valueForKey("password") as! String?
        
        self.Url = url != nil ? url! : ""
        self.Username = username != nil ? username! : ""
        self.Password = password != nil ? password! : ""
    }
    
    func Save()
    {
        let defaultSettings = NSUserDefaults.standardUserDefaults()
        
        defaultSettings.setValue(self.Url, forKey: "jenkinsurl")
        defaultSettings.setValue(self.Username, forKey: "username")
        defaultSettings.setValue(self.Password, forKey: "password")
        defaultSettings.synchronize()

    }
}
