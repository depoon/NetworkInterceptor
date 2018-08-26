//
//  ViewController.swift
//  NetworkInterceptorExample
//
//  Created by Kenneth Poon on 10/7/18.
//  Copyright © 2018 Kenneth Poon. All rights reserved.
//

import UIKit
import NetworkInterceptor

class ViewController: UIViewController {

    var session: URLSession?
    let webView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.webView)
        self.webView.frame = self.view.bounds

        let urlRequest = URLRequest(url: URL(string: "https://www.antennahouse.com/XSLsample/pdf/sample-link_1.pdf")!)
        self.webView.loadRequest(urlRequest)

//
//        
//
//        self.session = URLSession(configuration: URLSessionConfiguration.default)
//        if let url = URL(string: "https://www.antennahouse.com/XSLsample/pdf/sample-link_1.pdf") {
//            let request = URLRequest(url: url)
//            if let task = self.session?.dataTask(with: request) {
//                task.resume()
//                print("task started")
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

