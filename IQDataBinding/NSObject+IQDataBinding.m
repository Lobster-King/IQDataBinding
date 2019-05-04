//
//  NSObject+IQDataBinding.m
//  IQDataBinding
//
//  Created by lobster on 2019/5/2.
//  Copyright © 2019 lobster. All rights reserved.
//

#import "NSObject+IQDataBinding.h"
#import <objc/runtime.h>

static NSString *kViewAssociatedModelKey = @"kViewAssociatedModelKey";

@interface IQWatchDog : NSObject

@property (nonatomic, strong) id target;
@property (nonatomic, strong) NSMutableDictionary *keyPathsAndCallBack;

@end

@implementation IQWatchDog

- (void)dealloc {
    [self.keyPathsAndCallBack enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self.target removeObserver:self forKeyPath:key];
    }];
}

- (void)observeKeyPath:(NSString *)keyPath callBack:(observerCallBack)callBack {
    /*加载默认值*/
    id value = [self.target valueForKeyPath:keyPath];
    if (value) {
        callBack(value);
    }
    /*添加观察者*/
    [self.keyPathsAndCallBack setObject:callBack forKey:keyPath];
    [self.target addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    observerCallBack callBack = self.keyPathsAndCallBack[keyPath];
    if (callBack) {
        callBack(change[NSKeyValueChangeNewKey]);
    }
}

- (void)removeAllObservers {
    [self.keyPathsAndCallBack enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self.target removeObserver:self forKeyPath:key];
    }];
}

- (NSMutableDictionary *)keyPathsAndCallBack {
    if (!_keyPathsAndCallBack) {
        _keyPathsAndCallBack = [NSMutableDictionary dictionary];
    }
    return _keyPathsAndCallBack;
}

@end

@implementation NSObject (IQDataBinding)

- (void)bindModel:(id)model {
    IQWatchDog *viewAssociatedModel = objc_getAssociatedObject(self, &kViewAssociatedModelKey);
    if (!viewAssociatedModel) {
        viewAssociatedModel = [[IQWatchDog alloc]init];
        viewAssociatedModel.target = model;
        objc_setAssociatedObject(self, &kViewAssociatedModelKey, viewAssociatedModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    if (viewAssociatedModel.target) {
        //如果有view的关联model，则先把观察model的操作移除掉
        [viewAssociatedModel removeAllObservers];
    }
}

- (NSObject *(^)(NSString *keyPath,observerCallBack observer))bind {
    IQWatchDog *viewAssociatedModel = objc_getAssociatedObject(self, &kViewAssociatedModelKey);
    
    NSAssert(viewAssociatedModel, @"请先绑定viewModel！");
    
    NSObject *(^chainObject)(NSString *,observerCallBack) = ^(NSString *keyPath,observerCallBack observer){
        [viewAssociatedModel observeKeyPath:keyPath callBack:observer];
        return self;
    };
    return chainObject;
}

@end
