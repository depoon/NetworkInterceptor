# NetworkInterceptor
Simple framework to demo how we can inject URLRequest intercepting codes into iOS Apps (even for non-jailbroken devices). This framework allows you to inspect the details of all outgoing requests from the app. This includes requests sent out by 3rd party framework like FacebookSDK, Google Analytics, etc

### Installation

##### [CocoaPods](http://cocoapods.org)

NetworkInterceptor is available through CocoaPods. To install it, simply add the following line to your Podfile:
```ruby
pod 'NetworkInterceptor', :git => 'https://github.com/depoon/NetworkInterceptor.git', :branch => 'master'
```

## Main Components
- [NetworkInterceptorCodeInjection.m](https://github.com/depoon/NetworkInterceptor/blob/689ab2e9053409ede08459fed73c45d95078dc7a/NetworkInterceptor/Source/NetworkInterceptorCodeInjection.m)
Initiates the code injection process
- [NetworkInterceptor.swift](https://github.com/depoon/NetworkInterceptor/blob/master/NetworkInterceptor/Source/NetworkInterceptor.swift#L27) Main class that manages the URLRequest interception process as well as the logging process
- [RequestInterceptor](https://github.com/depoon/NetworkInterceptor/blob/master/NetworkInterceptor/Source/NetworkInterceptor.swift#L15) Protocol for classes that intercepts URLRequest
- [RequestLogger](https://github.com/depoon/NetworkInterceptor/blob/master/NetworkInterceptor/Source/NetworkInterceptor.swift#L20) Protocol for classes that log the intercepted URLRequest

### Implementation of RequestInterceptor
[CustormUrlProtocolRequestInterceptor.swift](https://github.com/depoon/NetworkInterceptor/blob/master/NetworkInterceptor/Source/RequestInterceptor/CustormUrlProtocolRequestInterceptor.swift)
- Creates its own implementation of URLProtocol and uses method swizzling to add its class into **procotolClasses**
### Implementation of RequestLogger
[SlackRequestLogger](https://github.com/depoon/NetworkInterceptor/blob/master/NetworkInterceptor/Source/RequestLogger/SlackRequestLogger.swift)
- Creates a cURL command for a URLRequest and sends to a designated [Slack](https://slack.com) channel
- You are required to provide your own Slack Authentication Token and slack channel ID for this to work.

You can also create and use multiple implementations of interceptors and loggers by conforming to RequestInterceptor/RequestLogger protocols

### How to use NetworkInterceptor

Setting up local console logging
```swift
let networkConfig = NetworkInterceptorConfig(requestLoggers: [
  RequestLoggerRegistrable.console.logger()
])
NetworkInterceptor.shared.setupLoggers(config: networkConfig)
NetworkInterceptor.shared.startRecording()
```
To use multiple loggers, eg Locale Console and Slack Loggers
```swift
let networkConfig = NetworkInterceptorConfig(requestLoggers: [
  RequestLoggerRegistrable.console.logger(),
  RequestLoggerRegistrable.slack(slackToken: "XXX", channel: "YYY", username: "ZZZ").logger()
])
```       

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
