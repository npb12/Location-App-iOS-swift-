//
//  ServerManagement.swift
//  ms
//
//  Created by Neil Ballard on 1/26/15.
//  Copyright (c) 2015 Missed Social. All rights reserved.
//


import UIKit
import Foundation


class ServerManagement
{
    
    

    
    func serverGet()
    {
        let urlPath = "http://23.239.3.97:8000/user/api/v1/user/?username=garfonzo@gmail.com&api_key=12345&format=json"
        let url = NSURL(string: urlPath)
        let request = NSURLRequest(URL: url!)
        // Turns on activity spinner
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { response, data, error in
            if let httpResponse = response as? NSHTTPURLResponse {
                println("The status code is: \(httpResponse.statusCode)")
                // 200 status code means we have a good response
                if httpResponse.statusCode == 200 {
                    var err: NSError?
                    println(httpResponse.statusCode)
                    var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                    if let json = jsonResult as? Dictionary<String, AnyObject> {
                        let numSystems = json["objects"]!.count - 1
                        for index in 0...numSystems {
                            if let username: AnyObject = json["objects"]![index]["fName"]! {
 //                               if let last: AnyObject = json["objects"]![index]["lastName"]! {
 //                                   if let id: AnyObject = json["objects"]![index]["resource_uri"]! {
                                        let userName: String = username as String
                                        println(userName)
//                                        let lName: String = last as String
 //                                       let ownerID: String = id as String
 //                                       let reducedID = ownerID.substringWithRange(Range<String.Index>(start: advance(ownerID.startIndex, 18), end:advance(ownerID.endIndex, -1)))
//                                        if (self.checkIfOwnerExists(reducedID) == false) {
//                                            Owner.createInManagedObjectContext(self.managedObjectContext!, ownerID: reducedID, fName: fName, lName: lName)
                      
                                
                            }
    
                        }
                    }
                }
            }
        }
    }







}