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
        let redirectedURL = self.redirectedUrl(originalUrlRequest: originalUrlRequest)
        var redirectedRequest = URLRequest(url: redirectedURL)
        redirectedRequest.httpBody = originalUrlRequest.httpBody
        redirectedRequest.httpMethod = originalUrlRequest.httpMethod!
        redirectedRequest.allHTTPHeaderFields = originalUrlRequest.allHTTPHeaderFields
        redirectedRequest.cachePolicy = originalUrlRequest.cachePolicy
        return redirectedRequest
    }
    
    fileprivate func redirectedUrl(originalUrlRequest: URLRequest) -> URL {
        var redirectedUrlString = "\(self.domainURL.absoluteString)\(originalUrlRequest.url!.path)"
        if let query = originalUrlRequest.url?.query {
            redirectedUrlString = "\(redirectedUrlString)?\(query)"
        }
        return URL(string: redirectedUrlString)!
    }
}
