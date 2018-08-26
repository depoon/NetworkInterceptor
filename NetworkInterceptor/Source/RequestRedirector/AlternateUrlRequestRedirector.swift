//
//  AlternateUrlRequestRedirector.swift
//  NetworkInterceptor
//
//  Created by Kenneth Poon on 26/8/18.
//  Copyright © 2018 Kenneth Poon. All rights reserved.
//

import Foundation

public class AlternateUrlRequestRedirector: RedirectableRequestHandler {
    
    let url: URL
    
    public init(url: URL){
        self.url = url
    }
    
    public func redirectedRequest(originalUrlRequest: URLRequest) -> URLRequest {
        let mutableRequest = (originalUrlRequest as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        mutableRequest.url = self.url
        return mutableRequest as URLRequest
    }
}
