//
//  SocialViewController.swift
//  ms
//
//  Created by Neil Ballard on 3/1/15.
//  Copyright (c) 2015 Missed Social. All rights reserved.
//

import Foundation
import UIKit



class SocialViewController: UIViewController {
    
    let serverManagement = ServerManagement()
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        println("this is Social VIEW")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}