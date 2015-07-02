//
//  HomeController.swift
//  Bankroll
//
//  Created by Mohan Lakshmanan on 6/17/15.
//  Copyright (c) 2015 AD. All rights reserved.
//

import UIKit

class HomeController: UITableViewController, NewPostViewControllerDelegate {
    
    @IBOutlet var segment: UISegmentedControl!
    
    var tblData : Array<Post>!
    
    var recData : Array<Post>!
    var treData : Array<Post>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        recData = [Post(), Post(), Post(), Post()]
        treData = [Post(), Post(), Post(), Post()]
        
        tblData = recData
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tblData.count
    }
    
    override func tableView(tableView: (UITableView!), cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : PostCell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostCell
        let post : Post = tblData[indexPath.row]
        
        //Assign values to the components
        cell.user.text = post.poster?.username
        cell.time.text = post.timePosted
        cell.post.text = post.postInformation
        cell.profilePic.image = post.poster?.profilePic
        cell.postPic.image = post.img
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let cell : PostCell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostCell
        let post : Post = tblData[indexPath.row]
        
        //Get all custom cell components
        let postLbl = cell.post
        let postPic : UIImageView = cell.postPic
        
        //Post lbl properties
        let PADDING : Float = 8
        let pString = post.postInformation as NSString?
        
        let textRect = pString?.boundingRectWithSize(CGSizeMake(CGFloat(self.tableView.frame.size.width - CGFloat(PADDING * 3.0)), CGFloat(1000)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(14.0)], context: nil)
        
        //Individual height variables
        let postInfoHeight = 66 as CGFloat
        var postHeight = textRect?.size.height
        postHeight? += CGFloat(PADDING * 3)
        var imgHeight = 8 + postPic.frame.height as CGFloat
        
        if post.img == nil {
            postPic.removeFromSuperview()
            imgHeight = 0
        }
        
        //Change the autolayout constraints so it works properly
        return postInfoHeight + postHeight! + imgHeight
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayRecent() {
        tblData = recData
        self.tableView.reloadData()
        self.tableView.setContentOffset(CGPointMake(0, -64), animated:true)
    }
    
    func displayTrending() {
        tblData = treData
        self.tableView.reloadData()
        self.tableView.setContentOffset(CGPointMake(0, -64), animated:true)
    }
    
    @IBAction func switchView(sender: UISegmentedControl!) {
        switch segment.selectedSegmentIndex
        {
            case 0:
                displayRecent()
            case 1:
                displayTrending()
            default:
                break
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newPostSegue" {
            let navigationController : UINavigationController = segue.destinationViewController as! UINavigationController
            let newPostViewController : NewPostViewController = navigationController.viewControllers[0] as! NewPostViewController
            newPostViewController.delegate = self
        }
    }
    
    //Delegate methods
    func newPostViewControllerDidCancel(controller: NewPostViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func newPostViewControllerDidPost(controller: NewPostViewController, post : Post) {
        //Sort both arrays by time/upvotes respectively
        recData.append(post)
        treData.append(post)
        
        tblData.append(post)
        self.tableView.reloadData()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
