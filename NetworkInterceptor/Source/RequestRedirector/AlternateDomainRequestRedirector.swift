//
//  AlternateDomainRequestRedirector.swift
//  NetworkInterceptor
//
//  Created by Kenneth Poon on 26/8/18.
//  Copyright © 2018 Kenneth Poon. All rights reserved.
//

import Foundation

public class AlternateDomainRequestRedirector: RedirectableRequestHandler {
    
    let domainURL: URL
    
    public init(domainURL: URL){
        self.domainURL = domainURL
    }
    
    public func redirectedRequest(originalUrlRequest: URLRequest) -> URLRequest {
        let mutableRequest = (originalUrlRequest as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        var path: String = ""
        if let originalURL = originalUrlRequest.url {
            path = originalURL.path
        }
        let redirectedURL = URL(string: "\(domainURL.absoluteString)\(path)")!
        mutableRequest.url = redirectedURL
        return mutableRequest as URLRequest
    }
}
