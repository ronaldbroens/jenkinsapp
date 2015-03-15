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
        println(settings.Url + "/api/json");
        
        let urlSession = NSURLSession.sharedSession()
        
        //2
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                println(error.localizedDescription)
                return
            }
            
            println("Data received");
            var err: NSError?
            
            // 3
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary?
            if (err != nil) {
                println("JSON Error \(err!.localizedDescription)")
            }
            
            if(jsonResult != nil)
            {
                println("Data " + (jsonResult!["nodeDescription"] as String))
                
                var jobs = jsonResult!["jobs"] as NSArray
                for(var i = 0; i < jobs.count; i++)
                {
                    var job = jobs[i] as NSDictionary
                    
                    var name = job["name"] as String
                    var url = job["url"] as String
                    var color = job["color"] as String
                    //url color
                    
                    var jobObject = JenkinsJob(Name: name, Url: url, Color: color)
                    results.append(jobObject)
                        
                    
                    
                
                }
                jobshandler(results);
                
            }
        })
        
        jsonQuery.resume()
    }
    
    func GetJobDetails(joburl: String, detailhandler : JenkinsDetailInfo -> Void)
    {
        var buildjoburl = joburl + "api/json";
        println("Will call to get job details " + buildjoburl)
        let urlSession = NSURLSession.sharedSession()
        let url = NSURL(string: buildjoburl)!
        
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                println(error.localizedDescription)
                return
            }
            
            println("Data received");
            var err: NSError?
            
            // 3
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary?
            if (err != nil) {
                println("JSON Error \(err!.localizedDescription)")
            }
            
            if(jsonResult != nil)
            {
                var color = (jsonResult!["color"] as String)
                println("Color " + color)
                
                var lastBuildObject = jsonResult!["lastBuild"] as NSDictionary
                var buildnumer = lastBuildObject["number"] as Int
                println("Last build buildnumer: " + String(buildnumer))
                
                var buildUrl = lastBuildObject["url"] as String
                println("Last build url: " + buildUrl)
                
                var lastBuild = JenkinsBuildReference(Url: buildUrl, Number: buildnumer)
                var builds = Array<JenkinsBuildReference>()
                
                // lastBuild
                var result = JenkinsDetailInfo(LastBuild: lastBuild, Color: color, Builds: builds)
                detailhandler(result)
            }
        
    })
    
    jsonQuery.resume()


    }
    
    func GetBuildDetails(buildurl: String, detailhandler : JenkinsBuild -> Void)
    {
        var buildjoburl = buildurl + "api/json";
        println("Will call to get build details " + buildjoburl)
        let urlSession = NSURLSession.sharedSession()
        let url = NSURL(string: buildjoburl)!
        
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                println(error.localizedDescription)
                return
            }
            
            println("Data received");
            var err: NSError?
            
            // 3
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary?
            if (err != nil) {
                println("JSON Error \(err!.localizedDescription)")
            }
            
            if(jsonResult != nil)
            {
                var building = (jsonResult!["building"] as Bool)
                var fullDisplayName = (jsonResult!["fullDisplayName"] as String)
                var estimatedDuration = (jsonResult!["estimatedDuration"] as Int)
                var timestamp = (jsonResult!["timestamp"] as NSNumber).longLongValue
                
               // println("TImestamp: \(timestamp)")
                var unixTimestamp = timestamp / 1000;
                //println("Unixt timestamp \(unixTimestamp)")
                
               var startTime = NSDate(timeIntervalSince1970: NSTimeInterval(unixTimestamp))
                var expectedEndTime = NSDate(timeIntervalSince1970: NSTimeInterval(unixTimestamp + (estimatedDuration/1000)))
                var durationInSeconds : Int = Int(expectedEndTime.timeIntervalSinceDate(startTime))


                var result = JenkinsBuild(Building: building, FullDisplayName: fullDisplayName, Duration: estimatedDuration, EstimatedDuration: durationInSeconds, StartTime : startTime, ExpectedEndTime : expectedEndTime)
                detailhandler(result);
            }
        })
        
        jsonQuery.resume()
    }

    
    func StartJobs( joburl: String)
    {
        var buildjoburl = joburl + "build";
        println("Will call to start job " + buildjoburl)
        let urlSession = NSURLSession.sharedSession()
        
        var url = NSURL(string: buildjoburl)
        
        var request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        // set up the base64-encoded credentials
        let settings = JenkinsSettings()
        let loginString = NSString(format: "%@:%@", settings.Username, settings.Password)
        let loginData: NSData? = loginString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64LoginString = loginData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(0))
        
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")

        let jsonQuery = urlSession.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                println(error.localizedDescription)
                return
            }
            
            let status = (response as NSHTTPURLResponse).statusCode
            println("status code is \(status)")
            
            var responseText = NSString(data: data, encoding: NSUTF8StringEncoding)
            println(responseText)
        })
        
        jsonQuery.resume()

        
    }
   }