//
//  AppDelegate.swift
//  ms
//
//  Created by Elijah MacLeod-Shaw on 2014-12-31. 
//  Copyright (c) 2014 Missed Social. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import Foundation



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    
    var window: UIWindow?
    var locationManager: CLLocationManager = CLLocationManager()
    let coreDataManagement = CoreDataManagement()
    var coreDataUsed = false

    
    
    
    func startWatchingLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
 //       println("\(locations[0].coordinate.latitude)")
 //       println("\(locations[0].coordinate.longitude)")
        
        
        // Creating the URL to post to. This URL can (should) be changed, depending on what you're doing
        // For this example, I'm simply sending one 'Location' object.
        // Note the use of the TastyPie format, with ?username=matt&api_key=12345&format=json
        // Each user should receive their own 'api_key', and this is done server side (not on the apps) but
        // the apps will need to receive that key initially and store it. You'll have to then use that api_key for every
        // call to Zeus
        let urlPath = "http://23.239.3.97:8000/user/api/v1/location/?username=garfonzo&api_key=12345&format=json"
        let url = NSURL(string: urlPath)
        // The request needs to be 'Mutable' because we'll be attaching parameters to the POST request
        let request = NSMutableURLRequest(URL: url!)
        
        // All the variables to make up the POST params. I'm using static variables here, but
        // the lat and long should be the actual ones, caputed by the device
        // Change the newLat and newLong values to something that you will be able to recognize on the website. That way
        // you can see if the values made it from the simulator/phone to Zeus
        var newLat = "\(locations[0].coordinate.latitude)"
        var newLong = "\(locations[0].coordinate.longitude)"
        var timeStamp = "2015-01-15T12:00:00"
        let userID = "/user/api/v1/user/13/"
        
        
        // Build a dictionary of all params
        var params = ["latitude": newLat, "longitude": newLong, "timeStamp":timeStamp, "user":userID] as Dictionary
        var err: NSError?
        
        // Assembling all the parts
        request.HTTPMethod = "POST"
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // This simply makes the network activity turn into a spinner, so that the user
        // can see that some sort of network activity is happening
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        // Last look at request we will send to Zeus
//        println(request)
//        println(request.HTTPBody)
        

        
        // This part actually sends the POST request as JSON data
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { response, data, error in
            if let httpResponse = response as? NSHTTPURLResponse {
                // For testing, we want to see what code is returned. If it's something lik 401, then it's an authorization issue
                // or code 500 is internal server errors. We want to know what's coming back instead of silently failing.
                // We're aiming for the 2XX range, which is the success range. Like status code 201.
                //println("The status code is: \(httpResponse.statusCode)")
                //If there are location data points in core data
                if(self.coreDataUsed)
                {
                    //loop entire contents of coredata to server
                    var fetchedCoreData = self.coreDataManagement.fetchLog()
                    
                    for dataPoints in fetchedCoreData
                    {
                      self.coreDataManagement.makeString(dataPoints)
                      //println(dataPoints)
                    }

                  self.coreDataManagement.cleanCore()
                  self.coreDataUsed = false
                }
                

            }
            else{
                 // Server request failed
                 //begin core data storage
                self.coreDataManagement.saveCoords(newLat, longCoord: newLong, timeCoord: timeStamp)
                self.coreDataUsed = true
            
            }
            
            
            
            
            // Turn off the "spinner" network activity indicator
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            
        }
        
    }
    

    
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        FBLoginView.self
        FBProfilePictureView.self
        
        //get session cookie
        FBSession.openActiveSessionWithAllowLoginUI(false)


    //    println(myToken);
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if defaults.objectForKey("userLoggedIn") == nil {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let initViewController: UIViewController = storyboard.instantiateViewControllerWithIdentifier("LandingViewController") as UIViewController
            self.window?.rootViewController = initViewController
        }
        

        
        startWatchingLocation()
        return true
    }
 
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: NSString?, annotation: AnyObject) -> Bool {
        
        var wasHandled:Bool = FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
        return wasHandled
        
    }
 


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        // Logs 'install' and 'app activate' App Events.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "MissedSocial.ms" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("ms", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("ms.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
 
    lazy var backgroundContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var backgroundContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        backgroundContext.persistentStoreCoordinator = coordinator
        return backgroundContext
        }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }

}

