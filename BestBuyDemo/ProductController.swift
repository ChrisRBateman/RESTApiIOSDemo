//
//  ProductController.swift
//  BestBuyDemo
//
//  Created by Chris Bateman on 2017-01-17.
//  Copyright © 2017 Chris Bateman. All rights reserved.
//

import UIKit
import ObjectMapper
import ImageLoader

class ProductController: UIViewController {
    
    let domain = Constants.Domain
    let lang = Constants.Lang
    
    var sku: String?
    var task: URLSessionDataTask?
    
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var separatorTopView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func addToCartPressed(_ sender: UIButton) {
        ViewUtils.showOKMessage(self, title:"Info", message:"Product added to cart")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("ProductController - viewDidLoad")
        
        if let newSku = sku {
            searchProduct(newSku)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        separatorTopView.isHidden = true
        productNameLabel.isHidden = true
        addToCartButton.isHidden = true
        productImageView.isHidden = true
        priceLabel.isHidden = true
        descriptionTextView.isHidden = true
        activityIndicator.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Need auto layout to kick in before adding border
        separatorTopView.addTopBorderWithColor(UIColor.lightGray, width: 1.0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let newTask = task {
            print("viewWillDisappear : task.state = \(newTask.state.description)")
            if newTask.state == URLSessionTask.State.running {
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
    func searchProduct(_ skuText: String) {
        let langCodeArr = lang.components(separatedBy: "-")
        let productUrl = String(format: Constants.ProductUrl, skuText, langCodeArr[0])
        
        print("Product url : \(productUrl)")
        
        var request = URLRequest(url: URL(string: productUrl)!)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            
            if (error == nil) {
                let productDetail = Mapper<ProductDetail>().map(JSONString: String(data: data!, encoding: String.Encoding.utf8)!)
                
                if productDetail != nil {
                    DispatchQueue.main.async(execute: {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                        self.updateGUI(productDetail!)
                    })
                } else {
                    DispatchQueue.main.async(execute: {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                        ViewUtils.showOKMessage(self, title:"Error", message:"Error parsing data")
                    })
                }
            } else {
                DispatchQueue.main.async(execute: {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    ViewUtils.showOKMessage(self, title:"Error", message:"Error retrieving data")
                })
            }
        })
        
        task!.resume()
    }
    
    ///
    /// Update gui with product detail information.
    ///
    /// - parameters:
    ///   - productDetail: the ProductDetail to update gui with
    ///
    func updateGUI(_ productDetail: ProductDetail) {
        productNameLabel.text = productDetail.name
        priceLabel.text = "$" + String(productDetail.regularPrice)
        descriptionTextView.text = productDetail.shortDescription!.stringByDecodingHTMLEntities
        
        let url = productDetail.thumbnailImage!
        productImageView.image = UIImage(named: "placeholder.png")
        productImageView.load.request(with: url, onCompletion: { image, error, operation in
            if operation == .network {
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = kCATransitionFade
                self.productImageView.layer.add(transition, forKey: nil)
                self.productImageView.image = image
            }
        })
        
        separatorTopView.isHidden = false
        productNameLabel.isHidden = false
        addToCartButton.isHidden = false
        productImageView.isHidden = false
        priceLabel.isHidden = false
        descriptionTextView.isHidden = false
    }
}

