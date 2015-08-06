//
//  InterfaceController.swift
//  JenkinsApp WatchKit Extension
//
//  Created by Ronald Broens on 28/02/15.
//  Copyright (c) 2015 Ronald Broens. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    var jobs = Dictionary<String,String>()
    
    @IBOutlet weak var tbl_jobs: WKInterfaceTable!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
       //var sizzel = Tester()
        //sizzel.DoTest()
        
        LoadDataFromIos()
        
    }
    
    func LoadDataFromIos()
    {
        // values to pass
        let parentValues = [
            "value1" : "Test 1",
            "value2" : "Test 2"
        ]
        
        WKInterfaceController.openParentApplication(parentValues, reply: { (replyValues, error) -> Void in
            let response = replyValues as! Dictionary<String,String>
            self.jobs = response
            self.SetupTable()
            
        })
    }
    
    func SetupTable()
    {
        /*var jobs = Array<String>();
        jobs.append("Job 1")
        jobs.append("JOb 2")
        jobs.append("Job 3")
        jobs.append("Another job")
        jobs.append("Another job 2")*/
        
        tbl_jobs.setNumberOfRows(jobs.count, withRowType: "jobRow")
        var index = 0;
        for (jobname, url) in Array(jobs).sort({$0.0 < $1.0}) {
            let theRow = self.tbl_jobs.rowControllerAtIndex(index) as! JobRowController
            theRow.lbl_job_title.setText(jobname)
            index++
        }

    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

class JobRowController: NSObject {
    @IBOutlet weak var lbl_job_title: WKInterfaceLabel!
}