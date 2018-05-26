# NetworkInterceptor
Simple framework to demo how we can inject URLRequest intercepting codes into iOS Apps (even for non-jailbroken devices). This framework allows you to inspect the details of all outgoing requests from the app. This includes requests sent out by 3rd party framework like FacebookSDK, Google Analytics, etc

## Main Components
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
- You are required to provide your own Slack Authentication Token and slack channel ID for this to work.

## How this repository works
- The build output of this Xcode Project is a dynamic framework, **NetworkInterceptor.framework**.
- In order to view the requests of an app, the framework needs to be correctly packaged into the app.
- Out of the box, you will need to provide your own Slack Authentication Token and slack channel ID to use SlackRequestLogger
- You can also create and use multiple implementations of interceptors and loggers by conforming to RequestInterceptor/RequestLogger protocols and initializing appropriately in the constructor of [NetworkInterceptor](https://github.com/depoon/NetworkInterceptor/blob/785766fbfdd5dd328630626b4fb6e61c1bc88710/NetworkInterceptor/Source/NetworkInterceptor.swift#L36-L37)

### If you want to use this framework in your own Xcode project
- Build the library using the appropriate architecture (iphonesimulator or iphoneos). 
- Copy the .framework file and add it into the Xcode project you wish to inspect its outgoing network. 
- Perform the tasks required to link and embedded the framework into the correct project scheme/target. 
- Build and install the app, you should be able to observe the logs when the app start ups.
- For iOS device apps, build the library using iphoneos architecture.

### If you want to use this framework in iOS Device apps you do not own
- Build the library using iphoneos architecture.
- Get an .ipa file that does not have Digital Rights Management protection. You can download cracked .ipa from https://www.iphonecake.com
- Inject the framework into the .ipa using [optool](https://github.com/alexzielenski/optool). You can also use the scripts from in this repository https://github.com/depoon/iOSDylibInjectionDemo. Make sure you included any necessary dependent framework or libraries.
- Use [Cydia Impactor](http://www.cydiaimpactor.com/) to sideload the modified app.
