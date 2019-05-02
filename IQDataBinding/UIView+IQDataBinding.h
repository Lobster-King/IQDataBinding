//
//  UIView+IQDataBinding.h
//  IQDataBinding
//
//  Created by lobster on 2019/5/2.
//  Copyright © 2019 lobster. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

typedef void(^returnValue)(id returnValue);
typedef void(^observe)(NSString *key,returnValue va);

@interface UIView (IQDataBinding)

- (void)bindModel:(id)model;
- (UIView *(^)(NSString *,returnValue c))bind;

@end

NS_ASSUME_NONNULL_END
