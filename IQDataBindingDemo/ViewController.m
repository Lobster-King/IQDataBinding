//
//  ViewController.m
//  IQDataBindingDemo
//
//  Created by lobster on 2019/5/2.
//  Copyright © 2019 lobster. All rights reserved.
//

#import "ViewController.h"
#import <IQDataBinding/IQDataBinding.h>
#import "ContentView.h"
#import "ContentModel.h"

@interface ViewController ()

@property (nonatomic, strong) ContentView *contentView;
@property (nonatomic, strong) UIButton *changeButton;
@property (nonatomic, strong) ContentModel *contentModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubviews];
    [self configData];
    
//    [self testModelDealloc];
//    [self testViewDealloc];
}

- (void)changeButtonClicked {
    self.contentModel.title = @"lobster";
    self.contentModel.content = @"654321";
}

- (void)setUpSubviews {
    self.contentView = [[ContentView alloc]initWithFrame:CGRectMake(100, 80, 200, 100)];
    [self.view addSubview:self.contentView];
    self.contentView.center = self.view.center;
    
    self.changeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.changeButton.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y + 100, 200, 40);
    
    [self.changeButton setTitle:@"加载默认用户名和密码" forState:UIControlStateNormal];
    [self.changeButton addTarget:self action:@selector(changeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.changeButton];
    
}

- (void)configData {
    self.contentModel = [[ContentModel alloc]init];
    self.contentModel.title = @"lobster";
    self.contentModel.content = @"123456";
    
    /*view和viewModel之间绑定*/
    [self.contentView bindModel:self.contentModel];
    
}

- (void)testViewDealloc {
    [self.contentView removeFromSuperview];
    self.contentView = nil;
}

- (void)testModelDealloc {
    self.contentModel = nil;
}

@end
