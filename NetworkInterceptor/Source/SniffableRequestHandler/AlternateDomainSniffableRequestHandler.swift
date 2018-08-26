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
        guard let alternateRequest = (urlRequest as NSURLRequest).mutableCopy() as? NSMutableURLRequest else {
            return
        }
        guard let path = urlRequest.url?.path else {
            return
        }
        guard let alternateURL = URL(string: "\(self.domainURL.absoluteString)\(path)") else {
            return
        }
        alternateRequest.url = alternateURL
        NetworkInterceptor.shared.refireURLRequest(urlRequest: alternateRequest as URLRequest)
    }
    
}
