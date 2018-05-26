# NetworkInterceptor
Simple framework to demo how we can inject URLRequest intercepting codes into iOS Apps (even for non-jailbroken devices). This framework allows you to inspect the details of all outgoing requests from the app. This includes requests sent out by 3rd party framework like FacebookSDK, Google Analytics, etc

## Main Components (included)
- [NetworkInterceptorCodeInjection.m](https://github.com/depoon/NetworkInterceptor/blob/689ab2e9053409ede08459fed73c45d95078dc7a/NetworkInterceptor/Source/NetworkInterceptorCodeInjection.m)
Initiates the code injection process
- [NetworkInterceptor.swift](https://github.com/depoon/NetworkInterceptor/blob/master/NetworkInterceptor/Source/NetworkInterceptor.swift) Main class that manages the URLRequest interception process as well as the logging process
- [RequestInterceptor](https://github.com/depoon/NetworkInterceptor/blob/689ab2e9053409ede08459fed73c45d95078dc7a/NetworkInterceptor/Source/NetworkInterceptor.swift#L15) Protocol for classes that intercepts URLRequest
- [RequestLogger](https://github.com/depoon/NetworkInterceptor/blob/689ab2e9053409ede08459fed73c45d95078dc7a/NetworkInterceptor/Source/NetworkInterceptor.swift#L20) Protocol for classes that log the intercepted URLRequest

### Implementation of RequestInterceptor
[CustormUrlProtocolRequestInterceptor.swift](https://github.com/depoon/NetworkInterceptor/blob/master/NetworkInterceptor/Source/RequestInterceptor/CustormUrlProtocolRequestInterceptor.swift)
- Creates its own implementation of URLProtocol and uses method swizzling to add its class into **procotolClasses**
### Implementation of RequestLogger
[SlackRequestLogger](https://github.com/depoon/NetworkInterceptor/blob/master/NetworkInterceptor/Source/RequestLogger/SlackRequestLogger.swift)
- Creates a cURL command for a URLRequest and sends to a designated [Slack](https://slack.com) channel
