//
//  SystemModel.swift
//  dizitakip
//
//  Created by Ömer Emre Aslan on 03/01/15.
//  Copyright (c) 2015 OEASLAN. All rights reserved.
//
import Foundation

class SystemModel{
    let apiKey = "d3ff368943be4b576251437784234c5d3a200160"
    let apiSecret = "268403caf178514c213cc9ee41bf7252848a4b50"
    let baseApiUrl = "http://localhost/imdb/api/"
    
    var profile: [String:String]! = nil
    var errorMessage: String! = nil
    var statistics: [String:String]! = nil
    func login(username: String, password: String) -> Bool{
        var apiUrl = baseApiUrl + "login?apiKey=" + apiKey + "&apiSecret=" + apiSecret + "&username=" + username + "&password=" + password
        
        if let nsurl = NSURL(string: apiUrl) {
            
            if let nsdata = NSData(contentsOfURL: nsurl) {
                
                var jsonDict: [String:AnyObject]!
                jsonDict = NSJSONSerialization.JSONObjectWithData(nsdata, options: NSJSONReadingOptions.AllowFragments, error: nil) as [String:AnyObject]
                
                var status = jsonDict["status"] as String
                
                
                if (status=="success" as String){
                    var userInfos = jsonDict["result"] as [[String:String]]
                    profile =  userInfos[0]
                    return true
                }
                
                
            }
        }
        
        return false
    }
    func setStatistics(user_id: String){
        var apiUrl = baseApiUrl + "getstatistics?apiKey=" + apiKey + "&apiSecret=" + apiSecret + "&userId="+user_id
        
        if let nsurl = NSURL(string: apiUrl) {
            
            if let nsdata = NSData(contentsOfURL: nsurl) {
                
                var jsonDict: [String:AnyObject]!
                jsonDict = NSJSONSerialization.JSONObjectWithData(nsdata, options: NSJSONReadingOptions.AllowFragments, error: nil) as [String:AnyObject]
                
                var status = jsonDict["status"] as String
                
                
                if (status=="success" as String){
                    var infos = jsonDict["result"] as [[String:String]]
                    statistics = infos[0]
                }else{
                    errorMessage = jsonDict["error_message"] as String
                }
                
                
            }
        }
    }
    func register(username: String, password: String, email: String)->Bool{
        
        var apiUrl = baseApiUrl + "register?apiKey=" + apiKey + "&apiSecret=" + apiSecret + "&username=" + username + "&password=" + password + "&email=" + email
        
        if let nsurl = NSURL(string: apiUrl) {
            
            if let nsdata = NSData(contentsOfURL: nsurl) {
                
                var jsonDict: [String:AnyObject]!
                jsonDict = NSJSONSerialization.JSONObjectWithData(nsdata, options: NSJSONReadingOptions.AllowFragments, error: nil) as [String:AnyObject]
                
                var status = jsonDict["status"] as String
                
                
                if (status=="success" as String){
                    var userInfos = jsonDict["result"] as [[String:String]]
                    profile =  userInfos[0]
                    return true
                }else{
                    errorMessage = jsonDict["error_message"] as String
                }
                
                
            }
        }
        
        return false
        
    }
}