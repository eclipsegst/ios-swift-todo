//
//  TableViewController.swift
//  RSS Reader
//
//  Created by iOS Students on 5/5/15.
//  Copyright (c) 2015 Zhaolong Zhong. All rights reserved.
//

import UIKit
import Foundation

class TableViewController: UITableViewController, NSXMLParserDelegate {
    
    // Declare properties
    
    var parser = NSXMLParser()
    var feeds = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    
    var ftitle = NSMutableString()
    var link = NSMutableString()

    var url: NSURL = NSURL()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Set feed url
        url = NSURL(string: "http://api.nytimes.com/svc/mostpopular/v2/mostviewed/technology/7.xml?api-key=sample-key")!
        //url = NSURL(string: "http://feeds.skynews.com/feeds/rss/home.xml")!
        //load feed
        loadRss(url)
    }
    
    func loadRss(url: NSURL) {
        //println(url)
        feeds = []
        parser = NSXMLParser(contentsOfURL: url)!
        parser.shouldProcessNamespaces = false
        parser.shouldReportNamespacePrefixes = false
        parser.shouldResolveExternalEntities = false
        
        // Have to add the line below or it won't execute the first parser func below
        parser.delegate = self
        parser.parse()
        
        tableView.rowHeight = 60
        tableView.reloadData()
        //println("reload data..")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        
        element = elementName
        
        if (element as NSString).isEqualToString("result") {
            elements = NSMutableDictionary.alloc()
            elements = [:]
            ftitle = NSMutableString.alloc()
            ftitle = ""
            link = NSMutableString.alloc()
            link = ""
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if (elementName as NSString).isEqualToString("result") {
            if ftitle != "" {
                elements.setObject(ftitle, forKey: "title")
                //println("ftitle = \(ftitle)")
            }
            
            if link != "" {
                elements.setObject(link, forKey: "url")
                //println("link = \(url)")
            }
            
            feeds.addObject(elements)
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        if element.isEqualToString("title") {
            ftitle.appendString(string!)
        } else if element.isEqualToString("url") {
            if string!.lowercaseString.rangeOfString("image") == nil {
            link.appendString(string!)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if(feeds.count > 0) {
            return feeds.count
        } else {
            return 5
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("feedCell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        
        //println("feeds = \(feeds.count)")
        
        cell.textLabel?.text = feeds.objectAtIndex(indexPath.row).objectForKey("title") as? String
        cell.detailTextLabel?.text = feeds.objectAtIndex(indexPath.row).objectForKey("url") as? String
        
        return cell
    }
    
    override func tableView(tableView:UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow();
        
        let cell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!

        let text = cell?.detailTextLabel?.text
        
        if let text = text {
            NSLog("link: \(text)")
        }
        
        var currentUrl: NSURL
        currentUrl = NSURL(string:text!)!

        NSLog("url: \(currentUrl)")
        
        // Open the link in Safari
        UIApplication.sharedApplication().openURL(currentUrl)
    }

}
