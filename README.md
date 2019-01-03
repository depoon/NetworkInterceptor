# NetworkInterceptor
Simple framework to demo how we can intercept URLRequest in iOS Apps. This framework allows you to inspect the details of all outgoing requests from the app. This includes requests sent out by 3rd party framework like FacebookSDK, Google Analytics, etc. It is possible to use this framework to inspect and intercept App Store apps even on non-jailbroken devices.

### Installation

##### [CocoaPods](http://cocoapods.org)

NetworkInterceptor is available through CocoaPods. To install it, simply add the following line to your Podfile:
```ruby
pod 'NetworkInterceptor'
```

## Main Components
- [NetworkInterceptor.swift](./NetworkInterceptor/Source/NetworkInterceptor.swift#L32) Main class that manages the URLRequest interception process.
- [NetworkRequestSniffableUrlProtocol.swift](./NetworkInterceptor/Source/URLProtocol/NetworkRequestSniffableUrlProtocol.swift)
UrlProtocol class that allows us to observe (and sniff) outgoing requests.
that manages the URLRequest interception process.
- [NetworkRedirectUrlProtocol.swift](./NetworkInterceptor/Source/URLProtocol/NetworkRedirectUrlProtocol.swift)
UrlProtocol class that allows us to redirect requets to a different URL.
- [RequestEvaluator](./NetworkInterceptor/Source/NetworkInterceptor.swift#15) Protocol for classes to evaluate whether operation on URLRequest is allowed
- [SniffableRequestHandler](./NetworkInterceptor/Source/NetworkInterceptor.swift#19) Protocol for classes to handle sniffing/spying on URLRequest
- [RedirectableRequestHandler](./NetworkInterceptor/Source/NetworkInterceptor.swift#23) Protocol for classes to handle the creation of Redirect URLRequests.
- [NetworkInterceptorConfig](./NetworkInterceptor/Source/NetworkInterceptorConfig.swift) Struct that defines the config object used to setup the Interception process


### How to use NetworkInterceptor

Example 1: Log all http/https requests using NSLog
```swift
let requestSniffers: [RequestSniffer] = [
    RequestSniffer(requestEvaluator: AnyHttpRequestEvaluator(), handlers: [
        SniffableRequestHandlerRegistrable.console(logginMode: .nslog).requestHandler()
    ])
]

let networkConfig = NetworkInterceptorConfig(requestSniffers: requestSniffers)
NetworkInterceptor.shared.setup(config: networkConfig)
NetworkInterceptor.shared.startRecording()
```

Example 2: For all requests that points to "www.antennahouse.com", redirect all matching requests to a custom URL
```swift
let requestRedirectors: [RequestRedirector] = [
    RequestRedirector(requestEvaluator: DomainHttpRequestEvaluator(domain: "www.antennahouse.com"),         
        redirectableRequestHandler: AlternateUrlRequestRedirector(url: URL(string: "https://www.rhodeshouse.ox.ac.uk/media/1002/sample-pdf-file.pdf")!))
]

let networkConfig = NetworkInterceptorConfig(requestRedirectors: requestRedirectors)
NetworkInterceptor.shared.setup(config: networkConfig)
NetworkInterceptor.shared.startRecording()
```       

### Request Evaluators available

[AnyHttpRequestInterceptor.swift](./NetworkInterceptor/Source/RequestEvaluator/AnyHttpRequestEvaluator.swift) Intercepts all http and https requests

[DomainHttpRequestEvaluator.swift](./NetworkInterceptor/Source/RequestEvaluator/DomainHttpRequestEvaluator.swift)
Intercepts all http and https requests that matches a given doman URL

### Sniffable Request Handlers available

[ConsoleLoggerSniffableRequestHandler.swift](./NetworkInterceptor/Source/SniffableRequestHandler/ConsoleLoggerSniffableRequestHandler.swift) Prints request in cURL format to the console

[SlackSniffableRequestHandler.swift](./NetworkInterceptor/Source/SniffableRequestHandler/SlackSniffableRequestHandler.swift) Sends the request in cURL format to a designated [Slack](https://slack.com) channel. You are required to provide your own Slack Authentication Token and slack channel ID for this to work.

[AlternateDomainSniffableRequestHandler.swift](./NetworkInterceptor/Source/SniffableRequestHandler/AlternateDomainSniffableRequestHandler.swift)  Sends the copy of the request to an alternate domain

### Request Redirectors available

[AlternateDomainRequestRedirector.swift](./NetworkInterceptor/Source/RequestRedirector/AlternateDomainRequestRedirector.swift) Redirects request to a different domain.

[AlternateUrlRequestRedirector.swift](./NetworkInterceptor/Source/RequestRedirector/AlternateUrlRequestRedirector.swift) Requests request to a complete different URL


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
