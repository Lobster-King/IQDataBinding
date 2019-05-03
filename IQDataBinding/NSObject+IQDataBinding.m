//
//  NSObject+IQDataBinding.m
//  IQDataBinding
//
//  Created by lobster on 2019/5/2.
//  Copyright © 2019 lobster. All rights reserved.
//

#import "NSObject+IQDataBinding.h"

@implementation NSObject (IQDataBinding)

- (NSObject *(^)(NSString *,observe))bind {
    NSObject *(^haha)(NSString *,observe) = ^(NSString *key,observe o){
        if ([key isEqualToString:@"key1"]) {
            o(@"result");
        }
        return self;
    };
    return haha;
}

@end
