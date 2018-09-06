//
//  URLRequest+cURL.swift
//  NetworkInterceptor
//
//  Created by Kenneth Poon on 26/5/18.
//  Copyright © 2018 Kenneth Poon. All rights reserved.
//

import Foundation

extension URLRequest {
    public var cURL: String {
        return RequestCurlCommand().toCurlString(request: self)
    }
}

class RequestCurlCommand{
    
    func toCurlString(request: URLRequest) -> String{
        
        guard let url = request.url else { return "" }
        var method = "GET"
        if let aMethod = request.httpMethod {
            method = aMethod
        }
        let baseCommand = "curl -X \(method) '\(url.absoluteString)'"
        
        var command: [String] = [baseCommand]
        
        if let headers = request.allHTTPHeaderFields {
            for (key, value) in headers {
                command.append("-H '\(key): \(value)'")
            }
        }
        if let httpBodyString = self.getHttpBodyString(request: request) {
            command.append("-d '\(httpBodyString)'")
        }
        return command.joined(separator: " ")
    }
    
    fileprivate func getHttpBodyString(request: URLRequest) -> String? {
        if let httpBodyString = self.getHttpBodyStream(request: request) {
            return httpBodyString
        }
        if let httpBodyString = self.getHttpBody(request: request) {
            return httpBodyString
        }
        return nil
    }
    
    fileprivate func getHttpBodyStream(request: URLRequest) -> String? {
        guard let httpBodyStream = request.httpBodyStream else {
            return nil
        }
        let data = NSMutableData()
        var buffer = [UInt8](repeating: 0, count: 4096)
        
        httpBodyStream.open()
        while httpBodyStream.hasBytesAvailable {
            let length = httpBodyStream.read(&buffer, maxLength: 4096)
            if length == 0 {
                break
            } else {
                data.append(&buffer, length: length)
            }
        }
        return NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue) as String?
    }
    
    fileprivate func getHttpBody(request: URLRequest) -> String? {
        guard let httpBody = request.httpBody, httpBody.count > 0 else {
            return nil
        }
        guard let httpBodyString = String(data: httpBody, encoding: String.Encoding.utf8) else {
            return nil
        }
        let escapedHttpBody = self.escapeAllSingleQuotes(httpBodyString)
        return escapedHttpBody
    }
    
    fileprivate func escapeAllSingleQuotes(_ value: String) -> String {
        return value.replacingOccurrences(of: "'", with: "'\\''")
    }
    
}
