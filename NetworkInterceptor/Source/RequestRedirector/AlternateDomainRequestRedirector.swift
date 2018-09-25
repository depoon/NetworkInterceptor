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
        let redirectedRequest = URLRequestFactory().createURLRequest(originalUrlRequest: originalUrlRequest, url: self.domainURL)
        return redirectedRequest
    }
}
