//
//  NSObject+IQDataBinding.h
//  IQDataBinding
//
//  Created by lobster on 2019/5/2.
//  Copyright © 2019 lobster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

#define update(key,...)                 update(IQBoxValue(key,(__VA_ARGS__)))
#define IQBoxValue(key,value) autoboxing(@encode(__typeof__((value))),self,key,(value))

id autoboxing(const char *type, ...);

typedef void(^observerCallBack)(id changedValue);

@interface NSObject (IQDataBinding)

- (void)bindModel:(id)model;

- (NSObject *(^)(NSString *keyPath,observerCallBack observer))observe;
- (NSObject * (^)(id,...))update;

@end

NS_ASSUME_NONNULL_END
