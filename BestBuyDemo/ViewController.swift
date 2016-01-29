//
//  ViewController.swift
//  BestBuyDemo
//
//  Created by Chris Bateman on 2015-10-16.
//  Copyright © 2015 Chris Bateman. All rights reserved.
//

import UIKit
import ObjectMapper
import ImageLoader

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let domain = Constants.Domain
    let lang = Constants.Lang
    
    var products: [Product] = []
    var sku: String?
    
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var searchTableView: UITableView!
    
    @IBAction func searchButtonPressed(sender: UIButton) {
        if let searchText = searchTextField.text?.trim() {
            print("Search Button Pressed : |\(searchText)|")
            
            if searchText.characters.count > 0 {
                activityIndicator.startAnimating()
                searchForProducts(searchText)
            }
        }
        searchTextField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.translucent = false
        let color = UIColor(hex: Constants.TitleBarColor)
        self.navigationController?.navigationBar.barTintColor = color
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        // Apply constraints to labels and imageview under contentview of tableviewcell.
        // Name label height is not constrained because it always changes.
        // Also adjust Content Hugging Priority and Content Compression Resistance Priority.
        // I gave name label higher priority since its height needs adjusting.
        // See Main.storyboard for all changes.
        searchTableView.estimatedRowHeight = 62.0
        searchTableView.rowHeight = UITableViewAutomaticDimension
        
        // Removes all lines from initially empty table
        searchTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // delegate for textfield set in main.storyboard
        // Hide keyboard when Done tapped
        searchTextField.resignFirstResponder()
        return false
    }
    
    ///
    /// Search for products based on searchText. The products are returned by BestBuy
    /// REST API as a Json string which is parsed into a list. The list is used by tableview to
    /// display product info on screen.
    ///
    /// - parameters:
    ///   - searchText: the text used to search products
    ///
    func searchForProducts(searchText: String) {
        let langCodeArr = lang.componentsSeparatedByString("-")
        let newSearchText = searchText.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        let searchUrl = String(format: Constants.SearchUrl, langCodeArr[0], newSearchText)
        
        print("Search url : \(searchUrl)")
        
        let request = NSMutableURLRequest(URL: NSURL(string: searchUrl)!)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            if (error == nil) {
                let searchResults = Mapper<SearchResults>().map(NSString(data: data!, encoding: NSUTF8StringEncoding)!)
                
                if searchResults != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.activityIndicator.stopAnimating()
                        if let products = searchResults?.products {
                            self.products = products
                            self.searchTableView.reloadData()
                        }
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.activityIndicator.stopAnimating()
                        ViewUtils.showOKMessage(self, title:"Error", message:"Error parsing data")
                    })
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.activityIndicator.stopAnimating()
                    ViewUtils.showOKMessage(self, title:"Error", message:"Error retrieving data")
                })
            }
        }
        
        task.resume()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == Constants.ShowProductDetailSegue {
            // pass data to next view
            if sku != nil {
                let pc = segue.destinationViewController as! ProductController
                pc.sku = sku
            }
        }
    }
    
    // MARK: UITableViewDataSource Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let textCellIdentifier = "ProductCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! ProductViewCell
        
        let row = indexPath.row
        let product = products[row]
        cell.nameLabel?.text = product.name
        cell.priceLabel?.text = "$" + String(product.regularPrice)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        let URL = product.thumbnailImage!
        let placeholder = UIImage(named: "placeholder.png")!
        cell.placeHolderImageView.load(URL, placeholder: placeholder) {
            URL, image, error, cacheType in
            
            if cacheType == CacheType.None {
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = kCATransitionFade
                cell.placeHolderImageView.layer.addAnimation(transition, forKey: nil)
                cell.placeHolderImageView.image = image
            }
        }
        
        return cell
    }
    
    // MARK: UITableViewDelegate Methods
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Products"
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        
        header.textLabel!.textColor = UIColor.grayColor()
        header.textLabel!.font = UIFont.boldSystemFontOfSize(15)
        header.textLabel!.frame = header.frame
        header.textLabel!.textAlignment = NSTextAlignment.Left
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let product = products[indexPath.row]
        sku = product.sku
        performSegueWithIdentifier(Constants.ShowProductDetailSegue, sender: self)
    }
}

