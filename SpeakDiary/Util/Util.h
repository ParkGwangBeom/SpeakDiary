//
//  Util.h
//  RightNow
//
//  Created by yellomobile on 2015. 7. 22..
//  Copyright (c) 2015년 RightNow. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GPSModel.h"

@interface Util : NSObject
+ (float)calculateHeightOfTextFromWidth:(NSString*)textt :(UIFont*)withFont :(float)width;

+ (BOOL)checkEmailFormat:(NSString *)email;

+(void)showToast:(NSString *)Message;

+ (void)hideKeyboard;


+(void) alertWithTitle:(NSString *)argTitle message:(NSString *)argMessage;



//날짜
+(long long)setMillisecond:(NSDate *)date;
+(NSInteger)getMonth:(long long)millisecond;
+(NSInteger)getYear:(long long)millisecond;
+(NSInteger)getDay:(long long)millisecond;

//날씨
+(NSDictionary*)getWeatherForLocation:(CLLocation*)location;

+(void)applyRoundCornerWithView:(UIView*)view cornerRadius:(CGFloat)cornerRadius;
@end
