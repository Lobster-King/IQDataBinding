//
//  ContentModel.h
//  IQDataBindingDemo
//
//  Created by lobster on 2019/5/2.
//  Copyright © 2019 lobster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContentModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
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

@end

NS_ASSUME_NONNULL_END
