//
//  NetworkRequestRedirectHandler.swift
//  NetworkInterceptor
//
//  Created by Kenneth Poon on 26/8/18.
//  Copyright © 2018 Kenneth Poon. All rights reserved.
//

import Foundation

class NetworkRequestRedirectHandler: NSObject {
    var urlProtocol: URLProtocol?
    var urlSession: URLSession?
    var urlSessionTask: URLSessionTask?
    
    
    
    func startLoading(request: URLRequest, urlProtocol: URLProtocol){
        self.urlProtocol = urlProtocol
        
        urlSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        urlSessionTask = urlSession?.dataTask(with: request as URLRequest, completionHandler: { [weak self] (data, response, error) in
            
            guard let handlingProtocol = self?.urlProtocol, let client = handlingProtocol.client else {
                return
            }

            if let error = error {
                client.urlProtocol(handlingProtocol, didFailWithError: error)
                return
            }
            
            client.urlProtocol(handlingProtocol, didReceive: response!, cacheStoragePolicy: .allowed)
            client.urlProtocol(handlingProtocol, didLoad: data!)
            client.urlProtocolDidFinishLoading(handlingProtocol)
        })
        
        self.urlSessionTask?.resume()
    }
}

extension NetworkRequestRedirectHandler: URLSessionDataDelegate {
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let handlingProtocol = self.urlProtocol, let client = handlingProtocol.client else {
            return
        }
        if let error = error {
            client.urlProtocol(handlingProtocol, didFailWithError: error)
            return
        }
        client.urlProtocolDidFinishLoading(handlingProtocol)
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        guard let handlingProtocol = self.urlProtocol, let client = handlingProtocol.client else {
            return
        }
        client.urlProtocol(handlingProtocol, didReceive: response, cacheStoragePolicy: .notAllowed)
        completionHandler(.allow)
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let handlingProtocol = self.urlProtocol, let client = handlingProtocol.client else {
            return
        }
        client.urlProtocol(handlingProtocol, didLoad: data)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        guard let handlingProtocol = self.urlProtocol, let client = handlingProtocol.client else {
            return
        }
        client.urlProtocol(handlingProtocol, wasRedirectedTo: request, redirectResponse: response)
    }
}
