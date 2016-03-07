//
//  NetworkService.swift
//  NSManchester
//
//  Created by Ross Butler on 15/01/2016.
//  Copyright © 2016 Ross Butler. All rights reserved.
//

import Foundation

let NSMNetworkUpdateNotification = "network-update-notification"

class NetworkService : NSObject {
    
    func update() {
        
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: NSURL(string: "http://nsmanchester.github.io/config/nsmanchester.json")!)
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            if let error = error {
                print("Failure:", error.localizedDescription);
                return
            }
            
            guard let data = data else {
                print("Failure: No data received");
                return
            }
            guard let response = response as? NSHTTPURLResponse else {
                print("Failure: Unexpected response");
                return
            }
            guard 200...299 ~= response.statusCode else {
                print("Failure: Unexpected response code'\(response.statusCode)'");
                return
            }
            
            if let parsedData = ParsingService().parse(data) {
                print(parsedData)
                if let dir: NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
                    let file = "nsmanchester.json"
                    let path = dir.stringByAppendingPathComponent(file);
                    data.writeToFile(path, atomically: true)
                    NSNotificationCenter.defaultCenter().postNotificationName(NSMNetworkUpdateNotification, object: nil)
                }
            }
        });
        task.resume()
    }
}