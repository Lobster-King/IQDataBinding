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
static NSMutableDictionary *stashedObserver = nil;

@interface IQWatchDog : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, strong) NSMutableDictionary *keyPathsAndCallBacks;

@end

@implementation IQWatchDog

- (void)dealloc {
    [self.keyPathsAndCallBacks enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
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
    [self.keyPathsAndCallBacks setObject:callBack forKey:keyPath];
    [self.target addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    observerCallBack callBack = self.keyPathsAndCallBacks[keyPath];
    if (callBack) {
        callBack(change[NSKeyValueChangeNewKey]);
    }
}

- (void)removeAllObservers {
    [self.keyPathsAndCallBacks enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self.target removeObserver:self forKeyPath:key];
    }];
}

- (NSMutableDictionary *)keyPathsAndCallBacks {
    if (!_keyPathsAndCallBacks) {
        _keyPathsAndCallBacks = [NSMutableDictionary dictionary];
    }
    return _keyPathsAndCallBacks;
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
    
    NSString *viewP = [NSString stringWithFormat:@"%p",self];
    
    NSDictionary *viewStashMap = stashedObserver[viewP];
    
    if (viewStashMap) {
        [viewStashMap enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [viewAssociatedModel observeKeyPath:key callBack:obj];
        }];
        /*stash pop*/
        [stashedObserver removeObjectForKey:viewP];
    }
}

- (NSObject *(^)(NSString *keyPath,observerCallBack observer))bind {
    
    if (!stashedObserver) {
        stashedObserver = [NSMutableDictionary dictionary];
    }
    
    IQWatchDog *viewAssociatedModel = objc_getAssociatedObject(self, &kViewAssociatedModelKey);
    
//    NSAssert(viewAssociatedModel, @"请先绑定viewModel！");
    
    NSObject *(^chainObject)(NSString *,observerCallBack) = ^(NSString *keyPath,observerCallBack observer){
        
        /*viewAssociatedModel为空，说明在绑定属性前没有绑定model，此处进行stash暂存*/
        if (!viewAssociatedModel) {
            
            /*stash push*/
            NSString *viewP = [NSString stringWithFormat:@"%p",self];
            NSMutableDictionary *viewStashMap = [NSMutableDictionary dictionaryWithDictionary:stashedObserver[viewP]];
            
            if (!viewStashMap) {
                viewStashMap = [NSMutableDictionary new];
            }
            
            [viewStashMap setObject:observer forKey:keyPath];
            
            [stashedObserver setObject:viewStashMap forKey:viewP];
            
            return self;
        }
        
        [viewAssociatedModel observeKeyPath:keyPath callBack:observer];
        return self;
    };
    return chainObject;
}

@end
