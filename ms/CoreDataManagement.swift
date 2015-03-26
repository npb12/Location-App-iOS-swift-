//
//  CoreDataManagement.swift
//  ms
//
//  Created by Neil Ballard on 1/22/15.
//  Copyright (c) 2015 Missed Social. All rights reserved.
//

import Foundation
import UIKit
import CoreData




class CoreDataManagement {
    
    
    var locations = [NSManagedObject]()

    
    
    //coordinates passed from AppDelegate
    func saveCoords(latCoord: String, longCoord: String, timeCoord: String) {
    

        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        
        let entity =  NSEntityDescription.entityForName("Location",
            inManagedObjectContext:
            managedContext)
        
        let coordsInfo = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedContext)
        
        
        coordsInfo.setValue(latCoord, forKey: "latitude")
        coordsInfo.setValue(longCoord, forKey: "longitude")
        coordsInfo.setValue(timeCoord, forKey: "timestamp")
        
        
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        
        locations.append(coordsInfo)

        

    }

    

    //fetch core data Location objects
    func fetchLog() -> Array<NSManagedObject> {
        
        //declare AppDelegate object
        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        //declare fetch request of entitiy Location
        let fetchRequest = NSFetchRequest(entityName: "Location")
        //don't return faults
        fetchRequest.returnsObjectsAsFaults = false;
        //execute the fetch request
        var fetchResults = appDelegate.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil)
       
        //return array of Location objects
        return fetchResults! as Array<NSManagedObject>
    }
    
    
    func makeString(objects: NSManagedObject)
    {
        var coreDataToServer = CoreDataToServer()

        //get values from NSManagedObject (objects)
        var latitude = objects.valueForKey("latitude") as String?
        var longitude = objects.valueForKey("longitude") as String?
        var timestamp = objects.valueForKey("timestamp") as String?
        
//        println(latitude!)
//        println(longitude!)
//        println(timestamp!)
        
        //push to server 
        coreDataToServer.unloadCoreToServer(latitude!, longitude:longitude!,timestamp: timestamp!)
        
    }
    

    //clear core data after objects have been fetched
    func cleanCore()
    {
        
        var cleanNum = 0
        //declare AppDelegate object
        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let context = appDelegate.managedObjectContext!
        
        var error: NSError? = nil
        
        var fetchReq = NSFetchRequest(entityName: "Location")
        //fetch core data objects
        var result = appDelegate.backgroundContext!.executeFetchRequest(fetchReq, error:&error)
        //delete these objects
        for resultItem in result! {
            var locationItem = resultItem as Location
            appDelegate.backgroundContext!.deleteObject(locationItem)
//            println("Delete: \(cleanNum++)")
        }
        //save context of core data
        context.save(nil)
        
        /* check that core data is empty*/
        
        var res = appDelegate.backgroundContext!.executeFetchRequest(fetchReq, error:&error)
        if res!.isEmpty {
            println("Delete worked")
        }
        else
        {
 //           println("Delete Failed")
        }
        
    }



}