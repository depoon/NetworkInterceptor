//
//  InterceptedRequestHandlerRegistrable.swift
//  NetworkInterceptor
//
//  Created by Kenneth Poon on 23/7/18.
//  Copyright © 2018 Kenneth Poon. All rights reserved.
//

import Foundation

public enum InterceptedRequestHandlerRegistrable {
    case console(logginMode: ConsoleLoggingMode)
    case slack(slackToken: String, channel: String, username: String)
    
    public func requestHandler() -> InterceptedRequestHandler {
        switch self {
        case .console(let loggingMode):
            return ConsoleLoggerRequestHandler(loggingMode: loggingMode)
        case .slack(let slackToken, let channel, let username):
            return SlackRequestHandler(slackToken: slackToken, channel: channel, username: username)
        }
    }
}
