//
//  URLRequestFactory.swift
//  NetworkInterceptor
//
//  Created by Kenneth Poon on 7/10/18.
//  Copyright © 2018 Kenneth Poon. All rights reserved.
//

import Foundation
import URLRequest_cURL

class URLRequestFactory {

    public func createURLRequest(originalUrlRequest: URLRequest, url: URL) -> URLRequest {
        var urlString = "\(url.absoluteString)\(originalUrlRequest.url!.path)"
        if let query = originalUrlRequest.url?.query {
            urlString = "\(urlString)?\(query)"
        }
        var redirectedRequest = URLRequest(url: URL(string: urlString)!)
        if let _ = originalUrlRequest.httpBodyStream,
            let httpBodyStreamData = originalUrlRequest.getHttpBodyStreamData() {
            redirectedRequest.httpBody = httpBodyStreamData
        } else {
            redirectedRequest.httpBody = originalUrlRequest.httpBody
        }
        redirectedRequest.httpMethod = originalUrlRequest.httpMethod!
        redirectedRequest.allHTTPHeaderFields = originalUrlRequest.allHTTPHeaderFields
        redirectedRequest.cachePolicy = originalUrlRequest.cachePolicy
        return redirectedRequest
    }
}
