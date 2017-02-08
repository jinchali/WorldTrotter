//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by Jackson Inchalik on 2/7/17.
//  Copyright © 2017 Jackson Inchalik. All rights reserved.
//

import Foundation
import WebKit

class WebViewController: UIViewController {
    
    //var webView = MKWebView!
    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("WebView loaded its view")

        let url = URL(string: "www.bignerdranch.com")
        
        let request = URLRequest(url: url!)
        
        webView
        webView.load(request)
        
        
    }
    
    
}
