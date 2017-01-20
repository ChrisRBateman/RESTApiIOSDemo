//
//  ViewController.swift
//  BestBuyDemo
//
//  Created by Chris Bateman on 2017-01-17.
//  Copyright © 2017 Chris Bateman. All rights reserved.
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
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
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
        
        print("ViewController - viewDidLoad")
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.isTranslucent = false
        let color = UIColor(hex: Constants.TitleBarColor)
        self.navigationController?.navigationBar.barTintColor = color
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
    func searchForProducts(_ searchText: String) {
        let langCodeArr = lang.components(separatedBy: "-")
        let newSearchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let searchUrl = String(format: Constants.SearchUrl, langCodeArr[0], newSearchText)
        
        print("Search url : \(searchUrl)")
        
        var request = URLRequest(url: URL(string: searchUrl)!)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            
            if (error == nil) {
                let searchResults = Mapper<SearchResults>().map(JSONString: String(data: data!, encoding: String.Encoding.utf8)!)
                
                if searchResults != nil {
                    DispatchQueue.main.async(execute: {
                        self.activityIndicator.stopAnimating()
                        if let products = searchResults?.products {
                            self.products = products
                            self.searchTableView.reloadData()
                        }
                    })
                } else {
                    DispatchQueue.main.async(execute: {
                        self.activityIndicator.stopAnimating()
                        ViewUtils.showOKMessage(self, title:"Error", message:"Error parsing data")
                    })
                }
            } else {
                DispatchQueue.main.async(execute: {
                    self.activityIndicator.stopAnimating()
                    ViewUtils.showOKMessage(self, title:"Error", message:"Error retrieving data")
                })
            }
        })
        
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == Constants.ShowProductDetailSegue {
            // pass data to next view
            if sku != nil {
                let pc = segue.destination as! ProductController
                pc.sku = sku
            }
        }
    }
    
    // MARK: UITableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let textCellIdentifier = "ProductCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! ProductViewCell
        
        let row = indexPath.row
        let product = products[row]
        cell.nameLabel?.text = product.name
        cell.priceLabel?.text = "$" + String(product.regularPrice)
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        let url = product.thumbnailImage!
        cell.placeHolderImageView.image = UIImage(named: "placeholder.png")
        cell.placeHolderImageView.load.request(with: url, onCompletion: { image, error, operation in
            if operation == .network {
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = kCATransitionFade
                cell.placeHolderImageView.layer.add(transition, forKey: nil)
                cell.placeHolderImageView.image = image
            }
        })
        
        return cell
    }
    
    // MARK: UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Products"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        
        header.textLabel!.textColor = UIColor.gray
        header.textLabel!.font = UIFont.boldSystemFont(ofSize: 15)
        header.textLabel!.frame = header.frame
        header.textLabel!.textAlignment = NSTextAlignment.left
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let product = products[indexPath.row]
        sku = product.sku
        performSegue(withIdentifier: Constants.ShowProductDetailSegue, sender: self)
    }
}

