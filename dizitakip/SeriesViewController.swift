//
//  SeriesViewController.swift
//  dizitakip
//
//  Created by Ömer Emre Aslan on 04/01/15.
//  Copyright (c) 2015 OEASLAN. All rights reserved.
//

import Foundation
import UIKit

class SeriesViewController : UITableViewController{
    
    
    @IBOutlet var tblView: UITableView!
    let seriesModel: SeriesModel = SeriesModel()
    var series: [[String:String]]!
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var profile: [String:String]!
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return series.count
    }
    override func viewDidLoad() {
        seriesModel.setTop10()
        series = seriesModel.top10
        
        profile = userDefaults.objectForKey("profile") as [String:String]
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("SeriesTableCell") as SeriesTableCell
        
        cell.seriesTitle.text = series[indexPath.row]["series_name"]
        cell.seriesGenres.text = series[indexPath.row]["series_genres"]
        cell.seriesImdb.text = "IMDB: "+series[indexPath.row]["series_rating"]!
        cell.seriesNextEpisode.text = series[indexPath.row]["series_editedtime"]!
        cell.seriesDate.text = " "+series[indexPath.row]["series_lastepisode"]!+" "
        cell.seriesDate.layer.masksToBounds = true
        cell.seriesDate.layer.cornerRadius = 4.0
        cell.seriesOrder.text = String(indexPath.row+1)+"."
        var apiUrl = "http://localhost/imdb/"+series[indexPath.row]["series_img"]!
        
        
        if let nsurl = NSURL(string: apiUrl) {
            
            if let nsdata = NSData(contentsOfURL: nsurl) {
                
                cell.seriesImage.image = UIImage(data: nsdata)
                }
            
            }
        
        return cell
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
        }
        if (editingStyle == UITableViewCellEditingStyle.None){
            
        }
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject] {
        
        
        var seriesID:String = series[indexPath.row]["series_id"]!
        var SID:Int! = seriesID.toInt()
        var userID: String = profile["user_id"]! 
        var UID:Int! = userID.toInt()
        var likeAction: UITableViewRowAction!
        var paths = indexPath
        //Unlike process
        if self.seriesModel.isLikedSeries(SID, userId: UID){
            likeAction = UITableViewRowAction(style: .Normal, title: "Unlike") { (action, indexPath) -> Void in
                tableView.editing = false
                self.seriesModel.likeSeries(SID, userId: UID)
            }
            likeAction.backgroundColor = UIColorFromRGB(0xFF0000)
        }else{
            likeAction = UITableViewRowAction(style: .Normal, title: "Like") { (action, indexPath) -> Void in
                tableView.editing = false
                self.seriesModel.likeSeries(SID, userId: UID)
            }
            likeAction.backgroundColor = UIColorFromRGB(0x29ade0)
        }
        
        /*
        var followAction = UITableViewRowAction(style: .Default, title: "Follow") { (action, indexPath) -> Void in
        tableView.editing = false
        
        println(self.seriesModel.runUrl)
        JLToast.makeText("You successfully followed "+self.series[indexPath.row]["series_name"]!, duration: JLToastDelay.LongDelay).show()   
        
        }
        
        followAction.backgroundColor = UIColorFromRGB(0x158cba)
        
        
        return [likeAction, followAction]
        
        */
        return [likeAction]
    }
        
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "seriesFromTop10"{
            
            var newVC:SeriesDetailViewController = segue.destinationViewController as SeriesDetailViewController
            
            let cell = sender as UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let seriesTitle = series[indexPath!.item]["series_name"]!
            let genresTitle = series[indexPath!.item]["series_genres"]!
            let imageUrl = series[indexPath!.item]["series_img"]!
            
            newVC.seriesTitle = seriesTitle
            newVC.genresTitle = genresTitle
            newVC.imageUrl = imageUrl
            newVC.seriesId = series[indexPath!.item]["series_id"]
        }
    }

    
}