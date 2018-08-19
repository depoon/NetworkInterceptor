# NetworkInterceptor
Simple framework to demo how we can inject URLRequest intercepting codes into iOS Apps (even for non-jailbroken devices). This framework allows you to inspect the details of all outgoing requests from the app. This includes requests sent out by 3rd party framework like FacebookSDK, Google Analytics, etc

### Installation

##### [CocoaPods](http://cocoapods.org)

NetworkInterceptor is available through CocoaPods. To install it, simply add the following line to your Podfile:
```ruby
pod 'NetworkInterceptor', :git => 'https://github.com/depoon/NetworkInterceptor.git', :tag => '0.0.2'
```

## Main Components
- [NetworkInterceptor.swift](https://github.com/depoon/NetworkInterceptor/blob/master/NetworkInterceptor/Source/NetworkInterceptor.swift#L32) Main class that manages the URLRequest interception process.
- [RequestInterceptor](https://github.com/depoon/NetworkInterceptor/blob/master/NetworkInterceptor/Source/NetworkInterceptor.swift#L15) Protocol for classes to determine whether a URLRequest can be intercepted
- [InterceptedRequestHandler](https://github.com/depoon/NetworkInterceptor/blob/master/NetworkInterceptor/Source/NetworkInterceptor.swift#L19) Protocol for classes to handle intercepted URLRequest
- [Interceptor](https://github.com/depoon/NetworkInterceptor/blob/master/NetworkInterceptor/Source/NetworkInterceptor.swift#L23) Struct that defines the RequestInterceptor and corresponding InterceptedRequestHandlers used.
- [NetworkInterceptorConfig](https://github.com/depoon/NetworkInterceptor/blob/master/NetworkInterceptor/Source/NetworkInterceptorConfig.swift#L11) Struct that defines the config object used to setup the Interception process


### How to use NetworkInterceptor

Setting up local console logging
```swift
@import NetworkInterceptor

let networkConfig = NetworkInterceptorConfig(interceptors: [
    Interceptor(requestInterceptor: AnyHttpRequestInterceptor(), handlers: [
        InterceptedRequestHandlerRegistrable.console(logginMode: .nslog).requestHandler()
    ])
])
NetworkInterceptor.shared.setup(config: networkConfig)
NetworkInterceptor.shared.startRecording()
```
To use multiple loggers, eg Locale Console and Slack Loggers
```swift
let networkConfig = NetworkInterceptorConfig(interceptors: [
    Interceptor(requestInterceptor: AnyHttpRequestInterceptor(), handlers: [
        InterceptedRequestHandlerRegistrable.console(logginMode: .nslog).requestHandler(),
        InterceptedRequestHandlerRegistrable.slack(slackToken: "Token", channel: "Channel", username: "username").requestHandler()
    ])
])
```       

### InterceptedRequestHandler available

[AnyHttpRequestInterceptor.swift](https://github.com/depoon/NetworkInterceptor/blob/master/NetworkInterceptor/Source/RequestInterceptor/AnyHttpRequestInterceptor.swift) Intercepts all http and https requests

### Implementation of RequestLogger

[ConsoleLoggerRequestHandler](https://github.com/depoon/NetworkInterceptor/blob/master/NetworkInterceptor/Source/InterceptedRequestHandler/ConsoleLoggerRequestHandler.swift) Prints request in cURL format to the console

[SlackRequestHandler](https://github.com/depoon/NetworkInterceptor/blob/master/NetworkInterceptor/Source/InterceptedRequestHandler/SlackRequestHandler.swift) Sends the request in cURL format to a designated [Slack](https://slack.com) channel. You are required to provide your own Slack Authentication Token and slack channel ID for this to work.

#### You can also create and use multiple implementations of interceptors and loggers by conforming to RequestInterceptor/InterceptedRequestHandler protocols


### If you want to use this framework in iOS Device apps you do not own
- Create a new Dynamic Framework Project and use **NetworkInterceptor** pod. We will only use this framework to start NetworkInterceptor recording.
- Use Objective C to load code into memory. Refer to the example project in this repository.
```swift
static void __attribute__((constructor)) initialize(void)
```
- Build the library using iphoneos architecture.
- Get an .ipa file that does not have Digital Rights Management protection. You can download cracked .ipa from https://www.iphonecake.com
- Inject both the **NetworkInterceptor** pod framework  and your new Dynamic Framework into the .ipa using [optool](https://github.com/alexzielenski/optool). You can also use the scripts from in this repository https://github.com/depoon/iOSDylibInjectionDemo. Make sure you included any necessary dependent framework or libraries.
- Use [Cydia Impactor](http://www.cydiaimpactor.com/) to sideload the modified app.
