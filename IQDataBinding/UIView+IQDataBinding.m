//
//  UIView+IQDataBinding.m
//  IQDataBinding
//
//  Created by lobster on 2019/5/2.
//  Copyright © 2019 lobster. All rights reserved.
//

#import "UIView+IQDataBinding.h"

@implementation UIView (IQDataBinding)


- (UIView *(^)(NSString *,returnValue c))bind {
    UIView *(^haha)(NSString *,returnValue c) = ^(NSString *key,returnValue c){
        if (c) {
            c(@"result");
        }
        return self;
    };
    return haha;
}

- (void)test {
    
}

@end
