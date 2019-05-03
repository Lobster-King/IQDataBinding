//
//  ViewController.m
//  IQDataBindingDemo
//
//  Created by lobster on 2019/5/2.
//  Copyright © 2019 lobster. All rights reserved.
//

#import "ViewController.h"
#import <IQDataBinding/IQDataBinding.h>
#import "ContentModel.h"

@interface ViewController ()

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UILabel *contentLabel1;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.contentLabel];
    
    ContentModel *model = [[ContentModel alloc]init];
    model.content = @"data binding demo";
    
    self.bind(@"key1",^(id value){

    }).bind(@"key2",^(id value){
        
    });
    // Do any additional setup after loading the view.
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
    }
    return _contentLabel;
}


@end
