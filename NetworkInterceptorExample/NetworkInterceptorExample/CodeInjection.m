//
//  CodeInjection.m
//  NetworkInterceptorExample
//
//  Created by Kenneth Poon on 23/7/18.
//  Copyright © 2018 Kenneth Poon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkInterceptorExample-Swift.h"

@interface CodeInjection: NSObject
@end

@implementation CodeInjection

static void __attribute__((constructor)) initialize(void){
    [[CodeInjectionSwift shared] performTask];
}

@end
