//
//  CustomToast.h
//  neo_gooddoc_ios
//
//  Created by yellomobile on 2015. 2. 25..
//  Copyright (c) 2015년 Yellow. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGB(a, b, c) [UIColor colorWithRed:(a / 255.0f) green:(b / 255.0f) blue:(c / 255.0f) alpha:1.0f]
#define RGBA(a, b, c, d) [UIColor colorWithRed:(a / 255.0f) green:(b / 255.0f) blue:(c / 255.0f) alpha:d]

typedef NS_ENUM(NSInteger, WToastDuration) {
    kWTShort = 1,
    kWTLong = 5
};

@interface CustomToast : UIView

-(void)showWithTextTT:(NSString *)text;

+ (void)showWithText:(NSString *)text;
+ (void)showWithImage:(UIImage *)image;

+ (void)showWithText:(NSString *)text duration:(NSInteger)duration;
+ (void)showWithImage:(UIImage *)image duration:(NSInteger)duration;

+ (void)showWithText:(NSString *)text duration:(NSInteger)duration roundedCorners:(BOOL)roundedCorners;
+ (void)showWithImage:(UIImage *)image duration:(NSInteger)duration roundedCorners:(BOOL)roundedCorners;

@end
