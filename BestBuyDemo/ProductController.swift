//
//  ProductController.swift
//  BestBuyDemo
//
//  Created by Chris Bateman on 2015-10-27.
//  Copyright © 2015 Chris Bateman. All rights reserved.
//

import UIKit
import ObjectMapper
import ImageLoader

class ProductController: UIViewController {
    
    let domain = Constants.Domain
    let lang = Constants.Lang
    
    var sku: String?
    var task: NSURLSessionDataTask?
    
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var separatorTopView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func addToCartPressed(sender: UIButton) {
        ViewUtils.showOKMessage(self, title:"Info", message:"Product added to cart")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let newSku = sku {
            searchProduct(newSku)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        separatorTopView.hidden = true
        productNameLabel.hidden = true
        addToCartButton.hidden = true
        productImageView.hidden = true
        priceLabel.hidden = true
        descriptionTextView.hidden = true
        activityIndicator.hidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        // Need auto layout to kick in before adding border
        separatorTopView.addTopBorderWithColor(UIColor.lightGrayColor(), width: 1.0)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let newTask = task {
            print("viewWillDisappear : task.state = \(newTask.state.description)")
            if newTask.state == NSURLSessionTaskState.Running {
                newTask.cancel()
                print("viewWillDisappear : task canceled")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///
    /// Search for product detail based on skuText. The product detail is returned by BestBuy
    /// REST API as a Json string which is parsed into a ProductDetail object. The object to
    /// display product detail info on screen.
    ///
    /// - parameters:
    ///   - skuText: the text used to search product detail
    ///
    func searchProduct(skuText: String) {
        let langCodeArr = lang.componentsSeparatedByString("-")
        let productUrl = String(format: Constants.ProductUrl, skuText, langCodeArr[0])
        
        print("Product url : \(productUrl)")
        
        let request = NSMutableURLRequest(URL: NSURL(string: productUrl)!)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            if (error == nil) {                
                let productDetail = Mapper<ProductDetail>().map(NSString(data: data!, encoding: NSUTF8StringEncoding)!)
                
                if productDetail != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.hidden = true
                        
                        self.updateGUI(productDetail!)
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.hidden = true
                        
                        ViewUtils.showOKMessage(self, title:"Error", message:"Error parsing data")
                    })
                }
            } else {
                if error!.code != NSURLErrorCancelled {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.hidden = true
                        
                        ViewUtils.showOKMessage(self, title:"Error", message:"Error retrieving data")
                    })
                }
            }
        }
        
        task!.resume()
    }
    
    ///
    /// Update gui with product detail information.
    ///
    /// - parameters:
    ///   - productDetail: the ProductDetail to update gui with
    ///
    func updateGUI(productDetail: ProductDetail) {
        productNameLabel.text = productDetail.name
        priceLabel.text = "$" + String(productDetail.regularPrice)
        descriptionTextView.text = productDetail.shortDescription!.stringByDecodingHTMLEntities
        
        let URL = domain + productDetail.thumbnailImage!
        let placeholder = UIImage(named: "placeholder.png")!
        productImageView.load(URL, placeholder: placeholder) {
            URL, image, error, cacheType in
            
            if cacheType == CacheType.None {
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = kCATransitionFade
                self.productImageView.layer.addAnimation(transition, forKey: nil)
                self.productImageView.image = image
            }
        }
        
        separatorTopView.hidden = false
        productNameLabel.hidden = false
        addToCartButton.hidden = false
        productImageView.hidden = false
        priceLabel.hidden = false
        descriptionTextView.hidden = false
    }
}
