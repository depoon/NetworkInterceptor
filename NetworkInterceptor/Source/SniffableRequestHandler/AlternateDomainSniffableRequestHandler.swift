//
//  AlternateDomainSniffableRequestHandler.swift
//  NetworkInterceptor
//
//  Created by Kenneth Poon on 26/8/18.
//  Copyright © 2018 Kenneth Poon. All rights reserved.
//

import Foundation

public class AlternateDomainSniffableRequestHandler: SniffableRequestHandler {

    let domainURL: URL

    public init(domainURL: URL){
        self.domainURL = domainURL
    }
    
    public func sniffRequest(urlRequest: URLRequest) {
        let alternateRequest = URLRequestFactory().createURLRequest(originalUrlRequest: urlRequest, url: self.domainURL)
        NetworkInterceptor.shared.refireURLRequest(urlRequest: alternateRequest as URLRequest)
    }
    
}
