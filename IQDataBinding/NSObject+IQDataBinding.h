//
//  NSObject+IQDataBinding.h
//  IQDataBinding
//
//  Created by lobster on 2019/5/2.
//  Copyright © 2019 lobster. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^observe)(id returnValue);

@interface NSObject (IQDataBinding)

- (void)bindModel:(id)model;
- (NSObject *(^)(NSString *,observe))bind;

@end

NS_ASSUME_NONNULL_END
