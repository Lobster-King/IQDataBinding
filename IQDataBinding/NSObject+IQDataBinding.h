//
//  NSObject+IQDataBinding.h
//  IQDataBinding
//
//  Created by lobster on 2019/5/2.
//  Copyright © 2019 lobster. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^observerCallBack)(id changedValue);

@interface NSObject (IQDataBinding)

- (void)bindModel:(id)model;
- (NSObject *(^)(NSString *keyPath,observerCallBack observer))bind;
- (void)updateValue:(id)value forKeyPath:(NSString *)keyPath;
#warning 理想的方式是这样 self.update(@"key",20.0);key是viewModel中的属性，值就是viewModel的属性值
@end

NS_ASSUME_NONNULL_END
