//
//  NewPostViewController.swift
//  Bankroll
//
//  Created by Mohan Lakshmanan on 6/25/15.
//  Copyright (c) 2015 AD. All rights reserved.
//

import Foundation
import UIKit

protocol NewPostViewControllerDelegate {
    func newPostViewControllerDidCancel(controller : NewPostViewController)
    func newPostViewControllerDidPost(controller : NewPostViewController, post : Post)
}

class NewPostViewController: UITableViewController, UITextViewDelegate {
    var delegate : NewPostViewControllerDelegate?
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var privacyLabel: UILabel!
    
    @IBOutlet weak var heightConstraint : NSLayoutConstraint!
    var handler : GrowingTextViewHandler!
    var numberOfLines = 2
    
    override func viewDidLoad() {
        postTextView.delegate = self
        handler = GrowingTextViewHandler(textView: postTextView, withHeightConstraint: heightConstraint)
        handler.updateMinimumNumberOfLines(1, andMaximumNumberOfLine: numberOfLines)
    }
    
    func textViewDidChange(textView: UITextView) {
        let newLine = handler.resizeTextViewWithAnimation(true)
        if newLine && numberOfLines != 23 {
            numberOfLines++
            handler.updateMinimumNumberOfLines(1, andMaximumNumberOfLine: numberOfLines)
        }
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    @IBAction func cancel(sender : AnyObject) {
        self.delegate?.newPostViewControllerDidCancel(self)
    }
    
    @IBAction func post(sender : AnyObject) {
        var newPost = Post()
        newPost.postInformation = postTextView.text
        self.delegate?.newPostViewControllerDidPost(self, post: newPost)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            self.postTextView.becomeFirstResponder()
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return self.postTextView.frame.height + 8
        }
        return 44
    }
}