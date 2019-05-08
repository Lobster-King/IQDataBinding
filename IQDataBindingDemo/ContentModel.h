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
@property (nonatomic, assign) int age;
@property (nonatomic, assign) CGFloat cgfl;
@property (nonatomic, assign) float fl;

@end

NS_ASSUME_NONNULL_END
