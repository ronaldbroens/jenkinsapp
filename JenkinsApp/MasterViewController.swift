//
//  MasterViewController.swift
//  JenkinsApp
//
//  Created by Ronald Broens on 07/02/15.
//  Copyright (c) 2015 Ronald Broens. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    //var objects = NSMutableArray()
    var jenkinsJobs : Array<JenkinsJob> = Array<JenkinsJob>()


    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.jenkinsJobs.append(JenkinsJob(Name: "Loading", Url: "", Color: ""))
        
        // Do any additional setup after loading the view, typically from a nib.
        //self.navigationItem.leftBarButtonItem = self.editButtonItem()
        var jobsReader = JobsReader();
        jobsReader.LoadJenkinsJobs(self.JobsLoaded);

        //let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        var settingsButton = UIBarButtonItem(title: "Settings", style: .Plain, target: self, action:"GotoSettings")
        self.navigationItem.rightBarButtonItem = settingsButton
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].parentViewController as? DetailViewController
        }
    }
    
    func GotoSettings()
    {
        print("Goto setting")
        self.performSegueWithIdentifier("settings", sender: self)
    }
    
    func JobsLoaded(jobs : Array<JenkinsJob>)
    {
        print("Jobs loaded");
        self.jenkinsJobs = jobs;
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_main_queue())
            {
                // update some UI
                self.tableView.reloadData()
            }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        //objects.insertObject(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = jenkinsJobs[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jenkinsJobs.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        let job = jenkinsJobs[indexPath.row]
        cell.textLabel!.text = job.Name
        
        if(job.Color == "red")
        {
            cell.contentView.backgroundColor = UIColor.redColor()
        }
        
        if(job.Color == "blue")
        {
            cell.contentView.backgroundColor = UIColor.greenColor()
        }

        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            //jenkinsJobs.removeObjectAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

