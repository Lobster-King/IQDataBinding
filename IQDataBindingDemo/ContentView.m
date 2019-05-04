//
//  ContentView.m
//  IQDataBindingDemo
//
//  Created by lobster on 2019/5/4.
//  Copyright © 2019 lobster. All rights reserved.
//

#import "ContentView.h"
#import <IQDataBinding/IQDataBinding.h>

@interface ContentView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation ContentView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews {
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    
    self.titleLabel.frame = CGRectMake(0, 0, self.bounds.size.width, 20);
    self.contentLabel.frame = CGRectMake(0, 40, self.bounds.size.width, 20);
    
    __weak typeof(self)weakSelf = self;
    self.bind(@"title",^(id value){
        weakSelf.titleLabel.text = value;
    }).bind(@"content",^(id value){
        weakSelf.contentLabel.text = value;
    }).bind(@"age",^(id value){
        
    });
    
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor greenColor];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.backgroundColor = [UIColor redColor];
    }
    return _contentLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
