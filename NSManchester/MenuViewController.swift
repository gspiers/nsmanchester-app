//
//  MenuViewController.swift
//  NSManchester
//
//  Created by Ross Butler on 28/01/2016.
//  Copyright © 2016 Ross Butler. All rights reserved.
//

import UIKit
import Foundation

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView?
    var menuOptions: Array<MenuOption>?
    
    // MARK: View lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        menuOptions = DataService().mainMenuOptions()
        super.init(coder: aDecoder)
        
       NSNotificationCenter.defaultCenter().addObserver(self, selector: "reload:", name: NSMNetworkUpdateNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if(tableView != nil)
        {
            if let selectedIndex = tableView?.indexPathForSelectedRow
            {
                tableView?.deselectRowAtIndexPath(selectedIndex, animated: true)
            }
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cellIdentifier = menuOptions?[indexPath.row].cellIdentifier
        {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath);
        if indexPath.row != 0
        {
            cell.textLabel?.text = menuOptions?[indexPath.row].title
        }
        if let subtitle = menuOptions?[indexPath.row].subtitle
        {
            cell.detailTextLabel?.text = subtitle
        }
        let selectedBackgroundView = UIView(frame: cell.frame)
        selectedBackgroundView.backgroundColor = tableView.cellSelectionColourForCellWithColour(cell.contentView.backgroundColor!)
            cell
        cell.selectedBackgroundView = selectedBackgroundView
        return cell
        }
        return tableView.dequeueReusableCellWithIdentifier("", forIndexPath: indexPath)
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (menuOptions != nil) ? menuOptions!.count : 0;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var height = 80 as CGFloat
        switch(indexPath.row)
        {
        case 0:
            height = 300
            break;
        case 1:
            height = 120
            break
        default:
            height = 80
        }
        return height;
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let segueIdentifier = menuOptions?[indexPath.row].segue
        {
            self.performSegueWithIdentifier(segueIdentifier, sender: tableView)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @IBAction override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        
    }
    
    // Notifications
    
    @objc func reload(notification: NSNotification){
        menuOptions = DataService().mainMenuOptions()
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            self.tableView?.reloadData()
        }
    }
}

