//
//  SearchPeopleViewController.swift
//  Bankroll
//
//  Created by Shivendra Kushwah on 7/1/15.
//  Copyright (c) 2015 AD. All rights reserved.
//

import UIKit

//implement cellClicked in SearchController

class SearchPeopleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchActive : Bool = false
    
    static var cellClicked = 0
    
    static var items: [String] = ["Bill Gates", "Steve Jobs", "Shiv Kushwah", ""]
    
    static var filtered:[String] = []
    
    /*For server, create static var items: [String] = []
    
    Then, in func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    send the cellClicked to the server and set items to the array returned by the server
    
    */
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        
        self.tableView.delegate = self
        
        self.tableView.dataSource = self
        
        searchBar.delegate = self
        
        
        
        
        
    }
    
    
    
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if SearchPeopleViewController.cellClicked > 3
            
        {
            
            SearchPeopleViewController.items = ["John Doe", "Will Smith", "Christian Bale", "Cool Person"]
            
        }
            
        else
            
        {
            
            SearchPeopleViewController.items =  ["Bill Gates", "Steve Jobs", "Shiv Kushwah", ""]
            
        }
        
        if(searchActive) {
            
            return SearchPeopleViewController.filtered.count
            
        }
        
        return SearchPeopleViewController.items.count;
        
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell { //prints cell
        
        
        
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        
        
        // let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell;
        
        
        
        if(searchActive){
            
            cell.textLabel?.text = SearchPeopleViewController.filtered[indexPath.row]
            
        } else {
            
            cell.textLabel?.text = SearchPeopleViewController.items[indexPath.row];
            
        }
        
        
        
        //   var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        
        
        // println(SearchPeopleViewController.cellClicked)
        
        
        
        
        
        //cell.textLabel?.text = SearchPeopleViewController.items[indexPath.row]
        
        
        
        return cell
        
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        println("You selected cell #\(indexPath.row)!")
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        searchActive = true;
        
    }
    
    
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        searchActive = false;
        
        self.tableView.reloadData()
        
    }
    
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        searchActive = false;
        
        self.tableView.reloadData()
        
    }
    
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchActive = false;
        
        self.tableView.reloadData()
        
    }
    
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        
        SearchPeopleViewController.filtered = SearchPeopleViewController.items.filter({ (text) -> Bool in
            
            let tmp: NSString = text
            
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            
            return range.location != NSNotFound
            
        })
        
        /*if(filtered.count == 0){
        
        searchActive = false;
        
        } else {
        
        searchActive = true;
        
        }*/
        
        
        
        self.tableView.reloadData()
        
    }
    
    
    
   // @IBAction func goBackTapped(sender: AnyObject) {
        
   //     self.performSegueWithIdentifier("gotoTable", sender: nil)
        
        
        
    }
    
    
    
    
    



