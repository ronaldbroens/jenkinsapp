//
//  JobsReader.swift
//  JenkinsApp
//
//  Created by Ronald Broens on 07/02/15.
//  Copyright (c) 2015 Ronald Broens. All rights reserved.
//

import Foundation

class JobsReader
{
    func LoadJenkinsJobs(jobshandler : Array<JenkinsJob> -> Void){
        
        var results = Array<JenkinsJob>()
        
        var settings = JenkinsSettings()
        
        let url = NSURL(string: settings.Url + "/api/json")!
        print(settings.Url + "/api/json");
        
        let urlSession = NSURLSession.sharedSession()
        
        //2
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                print(error!.localizedDescription)
                return
            }
            
            print("Data received");
            var err: NSError?
            
            // 3
            do{
            var jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            
            
            
                print("Data " + (jsonResult["nodeDescription"] as! String))
                
                var jobs = jsonResult["jobs"] as! NSArray
                for(var i = 0; i < jobs.count; i++)
                {
                    var job = jobs[i] as! NSDictionary
                    
                    var name = job["name"] as! String
                    var url = job["url"] as! String
                    var color = job["color"] as! String
                    //url color
                    
                    var jobObject = JenkinsJob(Name: name, Url: url, Color: color)
                    results.append(jobObject)
                        
                    
                    
                
                }
                jobshandler(results);
                
            
            }catch{
                print("Error")
            }
        })
        
        jsonQuery.resume()
    }
    
    func GetJobDetails(joburl: String, detailhandler : JenkinsDetailInfo -> Void)
    {
        var buildjoburl = joburl + "api/json";
        print("Will call to get job details " + buildjoburl)
        let urlSession = NSURLSession.sharedSession()
        let url = NSURL(string: buildjoburl)!
        
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                print(error!.localizedDescription)
                return
            }
            
            print("Data received");
            var err: NSError?
            
            // 3
            do {
            var jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            if (err != nil) {
                print("JSON Error \(err!.localizedDescription)")
            }
            
          
                var color = (jsonResult["color"] as! String)
                print("Color " + color)
                
                var lastBuildObject = jsonResult["lastBuild"] as! NSDictionary
                var buildnumer = lastBuildObject["number"] as! Int
                print("Last build buildnumer: " + String(buildnumer))
                
                var buildUrl = lastBuildObject["url"] as! String
                print("Last build url: " + buildUrl)
                
                var lastBuild = JenkinsBuildReference(Url: buildUrl, Number: buildnumer)
                var builds = Array<JenkinsBuildReference>()
                
                // lastBuild
                var result = JenkinsDetailInfo(LastBuild: lastBuild, Color: color, Builds: builds)
                detailhandler(result)
            }catch{
                print("error parsing json")
            }
            
        
    })
    
    jsonQuery.resume()


    }
    
    func GetBuildDetails(buildurl: String, detailhandler : JenkinsBuild -> Void)
    {
        var buildjoburl = buildurl + "api/json";
        print("Will call to get build details " + buildjoburl)
        let urlSession = NSURLSession.sharedSession()
        let url = NSURL(string: buildjoburl)!
        
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                print(error!.localizedDescription)
                return
            }
            
            print("Data received");
            var err: NSError?
            
            // 3
            do{
                var jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                if (err != nil) {
                    print("JSON Error \(err!.localizedDescription)")
                }
            
                
                    var building = (jsonResult["building"] as! Bool)
                    var fullDisplayName = (jsonResult["fullDisplayName"] as! String)
                    var estimatedDuration = (jsonResult["estimatedDuration"] as! Int)
                    var timestamp = (jsonResult["timestamp"] as! NSNumber).longLongValue
                
               // println("TImestamp: \(timestamp)")
                    var unixTimestamp = timestamp / 1000;
                //println("Unixt timestamp \(unixTimestamp)")
                
                    var startTime = NSDate(timeIntervalSince1970: NSTimeInterval(unixTimestamp))
                    var expectedEndTime = NSDate(timeIntervalSince1970: NSTimeInterval(unixTimestamp + (estimatedDuration/1000)))
                    var durationInSeconds : Int = Int(expectedEndTime.timeIntervalSinceDate(startTime))


                    var result = JenkinsBuild(Building: building, FullDisplayName: fullDisplayName, Duration: estimatedDuration, EstimatedDuration: durationInSeconds, StartTime : startTime, ExpectedEndTime : expectedEndTime)
                    detailhandler(result);
                
            }catch{
                print("Error at json parse");
            }
        })
        
        jsonQuery.resume()
    }

    
    func StartJobs( joburl: String)
    {
        let buildjoburl = joburl + "build";
        print("Will call to start job " + buildjoburl)
        let urlSession = NSURLSession.sharedSession()
        
        let url = NSURL(string: buildjoburl)
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        // set up the base64-encoded credentials
        let settings = JenkinsSettings()
        let loginString = NSString(format: "%@:%@", settings.Username, settings.Password)
        let loginData: NSData? = loginString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64LoginString = loginData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")

        let jsonQuery = urlSession.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                print(error!.localizedDescription)
                return
            }
            
            let status = (response as! NSHTTPURLResponse).statusCode
            print("status code is \(status)")
            
            let responseText = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print(responseText)
        })
        
        jsonQuery.resume()

        
    }
   }