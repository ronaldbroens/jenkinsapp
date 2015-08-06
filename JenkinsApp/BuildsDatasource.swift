//
//  BuildsDatasource.swift
//  JenkinsApp
//
//  Created by Ronald Broens on 16/02/15.
//  Copyright (c) 2015 Ronald Broens. All rights reserved.
//

import Foundation
import UIKit

class BuildsDatasource : NSObject, UITableViewDataSource
{
    var builds : Array<JenkinsBuild>
    
    init(builds : Array<JenkinsBuild>)
    {
        self.builds = builds
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.builds.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        var build = builds[indexPath.row]
    
        if(cell.textLabel != nil)
        {
             cell.textLabel?.text = build.FullDisplayName
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}