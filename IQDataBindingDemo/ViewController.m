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
    self.contentModel.title = @"title changed";
    self.contentModel.content = @"content changed";
    self.contentModel.age = 28;
    [self.contentView updateValue:@(30) forKeyPath:@"age"];
    [self.contentView updateValue:@(30.0) forKeyPath:@"cgfl"];
    [self.contentView updateValue:[NSNumber numberWithFloat:50.0] forKeyPath:@"fl"];
    
}

- (void)setUpSubviews {
    self.contentView = [[ContentView alloc]initWithFrame:CGRectMake(100, 100, 200, 60)];
    [self.view addSubview:self.contentView];
    self.contentView.center = self.view.center;
    
    self.changeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.changeButton.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y + 100, 200, 40);
    
    [self.changeButton setTitle:@"更改标题和内容" forState:UIControlStateNormal];
    [self.changeButton addTarget:self action:@selector(changeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.changeButton];
    
}

- (void)configData {
    self.contentModel = [[ContentModel alloc]init];
    self.contentModel.title = @"title";
    self.contentModel.content = @"content";
    
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
