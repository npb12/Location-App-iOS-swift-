//
//  CoreDataToServer.swift
//  ms
//
//  Created by Neil Ballard on 1/24/15.
//  Copyright (c) 2015 Missed Social. All rights reserved.
//

import Foundation

class CoreDataToServer {

    
    var coreDataUsed = false
    var cleanNum = 0
    var cleanNum2 = 0
    var coreDataManagement = CoreDataManagement()

    
    
    func unloadCoreToServer(latitude: String, longitude: String, timestamp: String)
    {
        let urlPath = "http://23.239.3.97:8000/user/api/v1/location/?username=garfonzo@gmail.com&api_key=12345&format=json"
        let url = NSURL(string: urlPath)
        // The request needs to be 'Mutable' because we'll be attaching parameters to the POST request
        let request = NSMutableURLRequest(URL: url!)
        
        // All the variables to make up the POST params. I'm using static variables here, but
        // the lat and long should be the actual ones, caputed by the device
        // Change the newLat and newLong values to something that you will be able to recognize on the website. That way
        // you can see if the values made it from the simulator/phone to Zeus
        var newLat = latitude
        var newLong = longitude
        var timeStamp = timestamp
        let userID = "/user/api/v1/user/1/"
        
        
        // Build a dictionary of all params
        var params = ["latitude": newLat, "longitude": newLong, "timeStamp":timeStamp, "user":userID] as Dictionary
        var err: NSError?
        
        // Assembling all the parts
        request.HTTPMethod = "POST"
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        

        // This part actually sends the POST request as JSON data
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { response, data, error in
            if let httpResponse = response as? NSHTTPURLResponse {
                // For testing, we want to see what code is returned. If it's something lik 401, then it's an authorization issue
                // or code 500 is internal server errors. We want to know what's coming back instead of silently failing.
                // We're aiming for the 2XX range, which is the success range. Like status code 201.
//                println("The status code is: \(httpResponse.statusCode)")
                
                if(self.coreDataUsed)
                {
                    //loop entire contents of coredata to server
                    var fetchedCoreData = self.coreDataManagement.fetchLog()
                    
                    for dataPoints in fetchedCoreData
                    {
                        self.coreDataManagement.makeString(dataPoints)
//                        println("fetched: \(self.cleanNum2++)")
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
//                println("inserted: \(self.cleanNum++)")
                
            }
            
            
            
            
        }


        
        
        
        
    }






}
