//
//  ContentView.m
//  IQDataBindingDemo
//
//  Created by lobster on 2019/5/4.
//  Copyright © 2019 lobster. All rights reserved.
//

#import "ContentView.h"
#import <IQDataBinding/IQDataBinding.h>

@interface ContentView ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *loginTextField;
@property (nonatomic, strong) UITextField *pwdTextField;

@end

@implementation ContentView

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews {
    
    [self addSubview:self.loginTextField];
    [self addSubview:self.pwdTextField];
    
    self.loginTextField.frame = CGRectMake(0, 0, self.bounds.size.width, 30);
    self.pwdTextField.frame = CGRectMake(0, 40, self.bounds.size.width, 30);
    
    __weak typeof(self)weakSelf = self;
    self.bind(@"title",^(id value){
        weakSelf.loginTextField.text = value;
    }).bind(@"content",^(id value){
        weakSelf.pwdTextField.text = value;
    });
    
}
/*
 @property (nonatomic, assign) CGPoint point;
 @property (nonatomic, assign) CGSize size;
 @property (nonatomic, assign) double db;
 @property (nonatomic, assign) float fl;
 @property (nonatomic, assign) long lg;
 @property (nonatomic, assign) long long llg;
 @property (nonatomic, assign) short st;
 @property (nonatomic, assign) char ch;
 @property (nonatomic, assign) bool bl;
 @property (nonatomic, assign) unsigned char ucha;
 @property (nonatomic, assign) unsigned long ulg;
 @property (nonatomic, assign) unsigned int uit;
 @property (nonatomic, assign) unsigned long long ullg;
 @property (nonatomic, assign) unsigned short ust;
 */

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField.text) {
        self.update(@"content",textField.text).update(@"point",CGPointMake(10, 20)).update(@"size",CGSizeMake(100, 200)).update(@"db",300).update(@"fl",400.0).update(@"lg",500.0).update(@"llg",70000000).update(@"st",700).update(@"ch","char").update(@"bl",true).update(@"ucha","lobster");
        [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.1];
    }
    return YES;
}

- (UITextField *)loginTextField {
    if (!_loginTextField) {
        _loginTextField = [[UITextField alloc]init];
        _loginTextField.borderStyle = UITextBorderStyleRoundedRect;
        _loginTextField.backgroundColor = [UIColor greenColor];
        _loginTextField.placeholder = @"请输入用户名";
        _loginTextField.delegate = self;
    }
    return _loginTextField;
}

- (UITextField *)pwdTextField {
    if (!_pwdTextField) {
        _pwdTextField = [[UITextField alloc]init];
        _pwdTextField.borderStyle = UITextBorderStyleRoundedRect;
        _pwdTextField.backgroundColor = [UIColor redColor];
        _pwdTextField.placeholder = @"请输入密码";
        _pwdTextField.delegate = self;
    }
    return _pwdTextField;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
