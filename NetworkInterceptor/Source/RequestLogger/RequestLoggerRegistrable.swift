//
//  RequestLoggerregistrable.swift
//  NetworkInterceptor
//
//  Created by Kenneth Poon on 23/7/18.
//  Copyright © 2018 Kenneth Poon. All rights reserved.
//

import Foundation

public enum RequestLoggerRegistrable {
    case console
    case slack(slackToken: String, channel: String, username: String)
    
    func logger() -> RequestLogger {
        switch self {
        case .console:
            return ConsoleRequestLogger()
        case .slack(let slackToken, let channel, let username):
            return SlackRequestLogger(slackToken: slackToken, channel: channel, username: username)
        }
    }
}
