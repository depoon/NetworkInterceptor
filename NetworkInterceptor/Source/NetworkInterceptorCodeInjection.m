//
//  NetworkInterceptorCodeInjection.m
//  NetworkInterceptor
//
//  Created by Kenneth Poon on 26/5/18.
//  Copyright © 2018 Kenneth Poon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkInterceptor-Swift.h"

@interface NetworkInterceptorCodeInjection: NSObject
@end

@implementation NetworkInterceptorCodeInjection

static NetworkInterceptor* networkInterceptor;

static void __attribute__((constructor)) initialize(void){
    NSLog(@"***** Code Injection Initiated *****");
    networkInterceptor = [NetworkInterceptor shared];
    [networkInterceptor startRecording];
    NSLog(@"***** Code Injection Ended *****");
}

@end
