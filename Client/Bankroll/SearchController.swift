//
//  SearchController.swift
//  Bankroll
//
//  Created by Mohan Lakshmanan on 6/17/15.
//  Copyright (c) 2015 AD. All rights reserved.
//
//Bug is that search bar now crashes
import UIKit

protocol DisplaySearchDelegate {
    func selected(user : User)
}

class SearchController: UITableViewController, UISearchBarDelegate, UITableViewDelegate {
    
    @IBOutlet var segment: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var delegate : DisplaySearchDelegate?
    
    var searchActive : Bool = false
    //var data: [String] = ["San Francisco","New York","San Jose","Chicago","Los Angeles","Austin", "Seattle"]
    
   var data: [String] = ["Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware", "Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming"]
    var userArray : [User] = [User]()
    var placeArray : [String] = [String]()
    
    var filtered:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Setup delegates */
        self.tableView.delegate = self
        self.tableView.dataSource = self
        searchBar.delegate = self
        
        userArray = [User(),User(),User(),User(),User(),User(),User(),User()]
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        filtered = data.filter({ (text) -> Bool in
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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return data.count;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //CODE TO BE RUN ON CELL TOUCH
        /* let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell;
        if cell.textLabel?.text == "Java" //specific cell is clicked
        {
        ListViewController.cellClicked = 1
        println("Hi")
        }
        */
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell;
        
        if currentCell.textLabel?.text == "California" //set cellClicked here so that server returns appropiate array of ppl
        {
            SearchPeopleViewController.cellClicked = 1
        }
        else if currentCell.textLabel?.text == "Alabama"
        {
            SearchPeopleViewController.cellClicked = 7
        }
        
        println(currentCell.textLabel!.text)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell;
        if(searchActive){
            cell.textLabel?.text = filtered[indexPath.row]
        } else {
            cell.textLabel?.text = data[indexPath.row];
        }
        
        return cell;
    }
    
    func getUsernames(users : [User]) -> [String] {
        var dat : [String] = [String]()
        for user in users {
            dat.append(user.username)
        }
        return dat
    }
    
    func searchFriends() {
        self.data = self.getUsernames(userArray)
        self.tableView.reloadData()
    }
    
    func searchPlaces() {
        self.data = self.placeArray
        self.tableView.reloadData()
    }
    
    @IBAction func switchView(sender: UISegmentedControl!) {
        switch segment.selectedSegmentIndex
        {
        case 0:
            searchPlaces()
        case 1:
            searchFriends()
        default:
            break
        }
    }
    
}