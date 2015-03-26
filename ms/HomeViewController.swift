//
//  HomeViewController.swift
//  ms
//
//  Created by Neil Ballard on 2/11/15.
//  Copyright (c) 2015 Missed Social. All rights reserved.
//

import Foundation
import UIKit



class HomeViewController: UITabBarController {
    
    //let serverManagement = ServerManagement()
    


    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        

/*
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if defaults.objectForKey("userLoggedIn") == nil {
            let LandingController: LandingViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LandingViewController") as LandingViewController
            self.navigationController?.presentViewController(LandingController, animated: true, completion: nil)
        }
*/
      //  serverManagement.serverGet()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
}


}