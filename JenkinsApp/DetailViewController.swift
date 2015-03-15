//
//  DetailViewController.swift
//  JenkinsApp
//
//  Created by Ronald Broens on 07/02/15.
//  Copyright (c) 2015 Ronald Broens. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var tv_builds: UITableView!
    @IBOutlet weak var progressbar: UIProgressView!
    
    var timer : NSTimer!

    @IBAction func BtnBuildClick(sender: UIButton)
    {
        println("Must build the job with name: "+self.detailItem!.Name)
        println("Must build the job with url: "+self.detailItem!.Url)
        
        var jenkinsReader = JobsReader()
        jenkinsReader.StartJobs(self.detailItem!.Url)
    }
    
    var detailItem: JenkinsJob? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        
        if let job = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = job.Name
            }
            
            if(self.timer != nil)
            {
                timer.invalidate()
                timer = nil
            }
            
             self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("PullJobDetails"), userInfo: nil, repeats: true)

        }
    }
    
    func PullJobDetails()
    {
        var jenkinsReader = JobsReader()
        jenkinsReader.GetJobDetails(self.detailItem!.Url, detailhandler: self.JobDetailsLoaded)
    }
    
    func JobDetailsLoaded(details : JenkinsDetailInfo)
    {
        println("Details loaded")
        var jenkinsReader = JobsReader()
        jenkinsReader.GetBuildDetails(details.LastBuild.Url, detailhandler: self.JobBuildLoaded)
    }
    
    func JobBuildLoaded(details: JenkinsBuild)
    {
        // hack
        var builds = Array<JenkinsBuild>()
        builds.append(details)
        self.tv_builds.dataSource = BuildsDatasource(builds: builds)
        
        /*dispatch_async(dispatch_get_main_queue())
            {
                self.tv_builds.reloadData()
        }*/
        
        println("BuildInfo loaded");
        
        let dateFormatter = NSDateFormatter()//3
        
        var theDateFormat = NSDateFormatterStyle.ShortStyle //5
        let theTimeFormat = NSDateFormatterStyle.MediumStyle//6
        
        dateFormatter.dateStyle = theDateFormat//8
        dateFormatter.timeStyle = theTimeFormat//9
        
        println("Build started at: " + dateFormatter.stringFromDate(details.StartTime))//11
        println("Expected finisch at: " + dateFormatter.stringFromDate(details.ExpectedEndTime))//11

        
        
        if(!details.Building)
        {
            dispatch_async(dispatch_get_main_queue())
            {
                self.progressbar.hidden = true;
            }
            return
        }
        
        var timeDifg = NSDate().timeIntervalSinceDate(details.StartTime)
        println("timedif: \(timeDifg)")
        
        
        var totalTimeDone = Float(NSDate().timeIntervalSince1970 - details.StartTime.timeIntervalSince1970);
        println("TotaltimeDOne \(totalTimeDone)")
        
        var duration = Float(details.EstimatedDuration)
        var percentage : Float = (totalTimeDone / duration)
        
        println("Percentage = \(percentage)");
        
        //percentage = Math.round(percentage * 100.0) / 100.0;
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: details.StartTime)
        let hour = components.hour
        let minutes = components.minute
        
        println("Build starten on: " + String(hour) + ":" + String(minutes));
        
        dispatch_async(dispatch_get_main_queue())
            {
                self.progressbar.hidden = false
                self.progressbar.setProgress(percentage, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

