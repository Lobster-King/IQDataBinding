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
    }).bind(@"age",^(id value){
        
    });
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField.text) {
        self.update(@"content",textField.text);
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
