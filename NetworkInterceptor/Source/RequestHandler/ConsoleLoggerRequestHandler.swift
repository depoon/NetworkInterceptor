//
//  ConsoleLoggerRequestHandler.swift
//  NetworkInterceptor
//
//  Created by Kenneth Poon on 10/7/18.
//  Copyright © 2018 Kenneth Poon. All rights reserved.
//

import Foundation

public enum ConsoleLoggingMode {
    case print, nslog
}

public class ConsoleLoggerRequestHandler: InterceptedRequestHandler {
    
    let loggingMode: ConsoleLoggingMode
    public init(loggingMode: ConsoleLoggingMode){
        self.loggingMode = loggingMode
    }
    
    fileprivate var requestCount: Int = 0
    public func handleRequest(urlRequest: URLRequest) {
        requestCount = requestCount + 1
        let loggableText = "Request #\(requestCount): CURL => \(urlRequest.cURL)"
        switch self.loggingMode {
        case .nslog:
            NSLog(loggableText)
        case .print:
            print(loggableText)
        }
    }
}
