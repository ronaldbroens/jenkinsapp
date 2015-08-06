//
//  JenkinsJob.swift
//  JenkinsApp
//
//  Created by Ronald Broens on 07/02/15.
//  Copyright (c) 2015 Ronald Broens. All rights reserved.
//

import Foundation

struct JenkinsJob
{
    var Name : String
    var Url : String
    var Color : String
}

struct JenkinsDetailInfo
{
    var LastBuild : JenkinsBuildReference
    var Color : String
    var Builds : Array<JenkinsBuildReference>
}

struct JenkinsBuildReference
{
    var Url : String
    var Number : Int
}

struct JenkinsBuild
{
    var Building : Bool
    var FullDisplayName : String
    var Duration : Int
    var EstimatedDuration : Int
    var StartTime : NSDate
    var ExpectedEndTime : NSDate
}