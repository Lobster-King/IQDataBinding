# IQDataBinding
iOS端View和ViewModel数据绑定框架，实现了自动移除，且支持函数式、链式调用，使用姿势比较优雅。

## 使用方式  
**一、通过Cocoapods引入工程。**  

```
pod 'IQDataBinding'
```

**二、Controller**

```
/*引入NSObject+IQDataBinding头文件*/
- (void)configData {
    self.contentModel = [[ContentModel alloc]init];
    self.contentModel.title = @"lobster";
    self.contentModel.content = @"123456";
    
    /*View和ViewModel之间绑定*/
    [self.contentView bindModel:self.contentModel];
    
}

```

**三、View**

```
/*ViewModel >>> View*/
- (void)setUpSubviews {
    

    [self addSubview:self.loginTextField];
    [self addSubview:self.pwdTextField];
    
    self.loginTextField.frame = CGRectMake(0, 0, self.bounds.size.width, 30);
    self.pwdTextField.frame = CGRectMake(0, 40, self.bounds.size.width, 30);
    
    /*绑定ViewModel中title和content属性，发生改变自动触发View更新操作*/
    __weak typeof(self)weakSelf = self;
    self.bind(@"title",^(id value){
        weakSelf.loginTextField.text = value;
    }).bind(@"content",^(id value){
        weakSelf.pwdTextField.text = value;
    });
    
}
    
```
```
/*View >>> ViewModel*/
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField.text) {
        /*函数式调用*/
        self.update(@"content",textField.text).update(@"title",@"lobster");
    }
    return YES;
}
```

## IQDataBinding踩坑记

* View更新ViewModel属性时，如何让一个函数支持传输不同的数据类型？
* View更新ViewModel时，如何避免触发KVO而导致死循环？
* 如何自动移除KVO？

**View更新ViewModel属性时，如何让一个函数支持传输不通的数据类型？**  

笔者借鉴了Masonry框架的解决方案，通过宏定义+不定参数解决了传输不通数据类型的问题。感兴趣的可以了解下Masonry中_MASBoxValue这个函数。  

**View更新ViewModel时，如何避免触发KVO而导致死循环？**  

很显然，通过setValue:forKey:函数会触发KVO回调，所以我的解决方案是获取到IVar，直接设置实例变量的值。但是object_setIvar(id _Nullable obj, Ivar _Nonnull ivar, id _Nullable value) 函数，只接收id类型的值。Stack Overflow查询之后，发现可以通过函数类型强转的方式来解决。

**如何自动移除KVO？**  

这个问题就比较简单了，为了监控View的dealloc函数调用时机，我们可以通过Hook的方式，但是Hook不太推荐。尤其使用类似于Aspects（通过消息转发来实现，代价很高）进行Hook时，对于那种一秒钟调用超过1000次的业务场景会严重影响性能。所以我采用的方案是，通过给View添加一个关联对象来解决。因为我们知道对象释放时会先释放成员变量，然后再释放关联对象，所以我们可以在关联对象的dealloc方法里对观察者进行自动移除。  

```
 /*给view添加一个关联对象IQWatchDog，IQWatchDog职责如下
     1.存储@{绑定的Key，回调Block}对应关系。
     2.根据@{绑定的Key，回调Block}中的Key，进行KVO监听。
     3.监听view Dealloc事件，自动移除KVO监听。
     */
    IQWatchDog *viewAssociatedModel = objc_getAssociatedObject(self, &kViewAssociatedModelKey);
    if (!viewAssociatedModel) {
        viewAssociatedModel = [[IQWatchDog alloc]init];
        viewAssociatedModel.target = model;
        objc_setAssociatedObject(self, &kViewAssociatedModelKey, viewAssociatedModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
```
```
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

```

## 联系我
PRs or Issues.  
Email:[zhiwei.geek@gmail.com](mailto:zhiwei.geek@gmail.com)
