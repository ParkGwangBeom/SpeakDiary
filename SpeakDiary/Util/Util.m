//
//  Util.m
//  RightNow
//
//  Created by yellomobile on 2015. 7. 22..
//  Copyright (c) 2015년 RightNow. All rights reserved.
//

#import "Util.h"

#import "CustomToast.h"

#import "JSONKit.h"


@implementation Util

+ (float)calculateHeightOfTextFromWidth:(NSString*)textt :(UIFont*)withFont :(float)width
{
    CGSize maximumLabelSize = CGSizeMake(width, FLT_MAX);
    CGRect textRect = [textt boundingRectWithSize:maximumLabelSize
                                          options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                       attributes:@{NSFontAttributeName:withFont}
                                          context:nil];
    
    return textRect.size.height;
}


//이메일 체크
+ (BOOL)checkEmailFormat:(NSString *)email{
    /*
     NSRange subRange;
     subRange = [email rangeOfString : @"@"];
     //    NSLog (@"String is at index %d, length is %d", subRange.location, subRange.length);
     if (subRange.location == NSNotFound) return NO;
     return YES;
     */
    
    if(email.length == 0) return NO;
    const char *tmp = [email cStringUsingEncoding:NSUTF8StringEncoding];
    
    if (email.length != strlen(tmp)) {
        
        return NO;
        
    }
    
    NSString *check = @"([0-9a-zA-Z_-]+)@([0-9a-zA-Z_-]+)(\\.[0-9a-zA-Z_-]+){1,2}";
    
    NSRange match = [email rangeOfString:check options:NSRegularExpressionSearch];
    
    if (NSNotFound == match.location) {
        
        return NO;
        
    }
    
    return YES;
}

//Show CustomToast
+(UIView *)showToast:(NSString *)toastTitle message:(NSString *)toastMessage duration:(float)duration{
    UIView *v_Toast = [[UIView alloc]initWithFrame:CGRectMake(80.0f, 50.0f, 100.0f, 100.0f)];
    UILabel *lb_title = [[UILabel alloc]initWithFrame:CGRectMake(80.0f, 50.0f, 100.0f, 100.0f)];
    UILabel *lb_Message = [[UILabel alloc]initWithFrame:CGRectMake(80.0f, 50.0f, 100.0f, 100.0f)];
    
    lb_title.text = toastTitle;
    lb_Message.text = toastMessage;
    
    [v_Toast addSubview:lb_title];
    [v_Toast addSubview:lb_Message];
    
    return v_Toast;
}



+(void)showToast:(NSString *)Message {
    [CustomToast showWithText:Message];
}



//keyboard
//키보드 감추기
+ (void)hideKeyboard
{
    UIWindow *tempWindow;
    
    
    for (int c=0; c < [[[UIApplication sharedApplication] windows] count]; c++)
    {
        tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:c];
        for (int i = 0; i < [tempWindow.subviews count]; i++)
        {
            [self _hideKeyboardRecursion:[tempWindow.subviews objectAtIndex:i]];
        }
    }
}

+ (void)_hideKeyboardRecursion:(UIView*)view
{
    if ([view conformsToProtocol:@protocol(UITextInputTraits)])
    {
        [view resignFirstResponder];
    }
    if ([view.subviews count]>0)
    {
        for (int i = 0; i < [view.subviews count]; i++)
        {
            [self _hideKeyboardRecursion:[view.subviews objectAtIndex:i]];
        }
    }
}

+(void) alertWithTitle:(NSString *)argTitle message:(NSString *)argMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:argTitle
                                                    message:argMessage
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"확인", nil];
    alert.tag = 0;
    [alert show];
}


//날짜 셋팅
+(long long)setMillisecond:(NSDate *)date{
    long long milliseconds = (long long)([date timeIntervalSince1970] * 1000.0);
    return milliseconds;
}

+(NSInteger)getMonth:(long long)millisecond{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(millisecond / 1000)];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    return [components month];
}

+(NSInteger)getYear:(long long)millisecond{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(millisecond / 1000)];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    return [components year];
}

+(NSInteger)getDay:(long long)millisecond{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(millisecond / 1000)];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    return [components day];
}



//날씨
+(NSDictionary*)getWeatherForLocation:(CLLocation*)location
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *strUrl=[NSString stringWithFormat:@"http://api.wunderground.com/api/131bad95922617dc/geolookup/forecast10day/q/%f,%f.json",location.coordinate.latitude,location.coordinate.longitude];
    
    NSString *escapedUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:escapedUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id item) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"Error: %@", error);
    }];
    
//    [request setURL:[NSURL URLWithString:stringURL]];
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSDictionary *dictionary=[stringData objectFromJSONString];
    
    NSDictionary *locationDic=[[NSDictionary alloc] initWithDictionary:[dictionary valueForKey:@"location"]];
    NSLog(@"locations is %@",locationDic);
    
    return [dictionary valueForKey:@"forecast"];
}

+(void)applyRoundCornerWithView:(UIView*)view cornerRadius:(CGFloat)cornerRadius
{
    CALayer *layer = view.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = cornerRadius;
    layer.borderWidth = 0;
}

@end

