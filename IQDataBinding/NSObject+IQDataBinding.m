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
    NSAssert(keyPath.length, @"keyPath不合法");
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
    /*给view添加一个关联对象IQWatchDog，IQWatchDog职责如下
     1.存储@{绑定的Key，回调Block}对应关系。
     2.根据@{绑定的Key，回调Block}中的Key，进行KVO监听。
     3.监听view Dealloc事件，自动移除KVO监听。
     */
    IQWatchDog *viewAssociatedModel = objc_getAssociatedObject(self, &kViewAssociatedModelKey);
    if (viewAssociatedModel) {
        objc_setAssociatedObject(self, &kViewAssociatedModelKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    viewAssociatedModel = [[IQWatchDog alloc]init];
    viewAssociatedModel.target = model;
    objc_setAssociatedObject(self, &kViewAssociatedModelKey, viewAssociatedModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    /*借鉴Git stash暂存命令理念，stashedObserver职责如下
     1.如果bindModel调用在绑定keyPath之后调用，会自动把当前@{绑定的Key，回调Block}结构保存到暂存区。
     2.调用bindModel的时候先根据当前view的地址指针去stashedObserver取暂存的数据。
     3.如果暂存区有数据则调用IQWatchDog注册方法进行自动注册。
     4.注册完成进行stash pop操作。
     */
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

- (NSObject *(^)(NSString *keyPath,observerCallBack observer))observe {
    if (!stashedObserver) {
        stashedObserver = [NSMutableDictionary dictionary];
    }
    
    IQWatchDog *viewAssociatedModel = objc_getAssociatedObject(self, &kViewAssociatedModelKey);
    
    return ^(NSString *keyPath,observerCallBack observer){
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
}

- (NSObject * (^)(id,...))update {
    return ^id(id attribute,...) {
        return self;
    };
}

id autoboxing(const char *type, ...) {
    
    va_list v;
    va_start(v, type);
    
    NSObject *pointer = va_arg(v, id);
    NSString *key = va_arg(v, NSString *);
   
    IQWatchDog *watchDog = objc_getAssociatedObject(pointer, &kViewAssociatedModelKey);
    Ivar ivar = class_getInstanceVariable([watchDog.target class], [[NSString stringWithFormat:@"_%@",key] UTF8String]);
    
    id obj = nil;
    if (strcmp(type, @encode(id)) == 0) {
        id actual = va_arg(v, id);
        object_setIvar(watchDog.target,ivar,actual);
    } else if (strcmp(type, @encode(CGPoint)) == 0) {
#warning fix me!!!
        CGPoint actual = (CGPoint)va_arg(v, CGPoint);
        void (*fcgpoint)(id, Ivar, CGPoint) = (void (*)(id, Ivar, CGPoint))object_setIvar;
        fcgpoint(watchDog.target,ivar,actual);
    } else if (strcmp(type, @encode(CGSize)) == 0) {
#warning fix me!!!
        CGSize actual = (CGSize)va_arg(v, CGSize);
        void (*fcgsize)(id, Ivar, CGSize) = (void (*)(id, Ivar, CGSize))object_setIvar;
        fcgsize(watchDog.target,ivar,actual);
    }  else if (strcmp(type, @encode(double)) == 0) {
        double actual = (double)va_arg(v, double);
        void (*fdouble)(id, Ivar, double) = (void (*)(id, Ivar, double))object_setIvar;
        fdouble(watchDog.target,ivar,actual);
    } else if (strcmp(type, @encode(float)) == 0) {
        float actual = (float)va_arg(v, double);
        void (*ffloat)(id, Ivar, float) = (void (*)(id, Ivar, float))object_setIvar;
        ffloat(watchDog.target,ivar,actual);
    } else if (strcmp(type, @encode(int)) == 0) {
        int actual = (int)va_arg(v, int);
        void (*fint)(id, Ivar, int) = (void (*)(id, Ivar, int))object_setIvar;
        fint(watchDog.target,ivar,actual);
    } else if (strcmp(type, @encode(long)) == 0) {
        long actual = (long)va_arg(v, long);
        void (*flong)(id, Ivar, long) = (void (*)(id, Ivar, long))object_setIvar;
        flong(watchDog.target,ivar,actual);
    } else if (strcmp(type, @encode(long long)) == 0) {
        long long actual = (long long)va_arg(v, long long);
        void (*flonglong)(id, Ivar, long long) = (void (*)(id, Ivar, long long))object_setIvar;
        flonglong(watchDog.target,ivar,actual);
    } else if (strcmp(type, @encode(short)) == 0) {
        short actual = (short)va_arg(v, int);
        void (*fshort)(id, Ivar, short) = (void (*)(id, Ivar, short))object_setIvar;
        fshort(watchDog.target,ivar,actual);
    } else if (strcmp(type, @encode(char)) == 0) {
        char actual = (char)va_arg(v, int);
        void (*fchar)(id, Ivar, char) = (void (*)(id, Ivar, char))object_setIvar;
        fchar(watchDog.target,ivar,actual);
    } else if (strcmp(type, @encode(bool)) == 0) {
        bool actual = (bool)va_arg(v, int);
        void (*fbool)(id, Ivar, bool) = (void (*)(id, Ivar, bool))object_setIvar;
        fbool(watchDog.target,ivar,actual);
    } else if (strcmp(type, @encode(unsigned char)) == 0) {
        unsigned char actual = (unsigned char)va_arg(v, unsigned int);
        void (*funsignedchar)(id, Ivar, unsigned char) = (void (*)(id, Ivar, unsigned char))object_setIvar;
        funsignedchar(watchDog.target,ivar,actual);
    } else if (strcmp(type, @encode(unsigned int)) == 0) {
        unsigned int actual = (unsigned int)va_arg(v, unsigned int);
        void (*funsignedint)(id, Ivar, unsigned int) = (void (*)(id, Ivar, unsigned int))object_setIvar;
        funsignedint(watchDog.target,ivar,actual);
    } else if (strcmp(type, @encode(unsigned long)) == 0) {
        unsigned long actual = (unsigned long)va_arg(v, unsigned long);
        void (*funsignedlong)(id, Ivar, unsigned long) = (void (*)(id, Ivar, unsigned long))object_setIvar;
        funsignedlong(watchDog.target,ivar,actual);
    } else if (strcmp(type, @encode(unsigned long long)) == 0) {
        unsigned long long actual = (unsigned long long)va_arg(v, unsigned long long);
        void (*funsignedlonglong)(id, Ivar, unsigned long long) = (void (*)(id, Ivar, unsigned long long))object_setIvar;
        funsignedlonglong(watchDog.target,ivar,actual);
    } else if (strcmp(type, @encode(unsigned short)) == 0) {
        unsigned short actual = (unsigned short)va_arg(v, unsigned int);
        void (*funsignedshort)(id, Ivar, unsigned short) = (void (*)(id, Ivar, unsigned short))object_setIvar;
        funsignedshort(watchDog.target,ivar,actual);
    }
    va_end(v);
    return obj;
}

@end
