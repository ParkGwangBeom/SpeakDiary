//
//  NSString+HttpUrlCheck.m
//  RightNow
//
//  Created by yellomobile on 2015. 7. 23..
//  Copyright (c) 2015년 RightNow. All rights reserved.
//

#import "NSString+HttpUrlCheck.h"

@implementation NSString (HttpUrlCheck)

+(NSString *)stringWithHttpCheck:(NSString *)stringUrl{
    NSString *strUrl = NULL_TO_EMPTY_STRING(stringUrl);
    NSString *checkStringUrl = @"";
    if(strUrl.length > 0){
        NSRange range = NSMakeRange(0,5);
        NSString *afterURL;
        afterURL = [strUrl substringWithRange:range];
        if (![afterURL isEqualToString:@"http:"]) {
            strUrl = [NSString stringWithFormat:@"http://%@",strUrl];
        }
        NSArray *arr_str = [strUrl componentsSeparatedByString:@" "];
        checkStringUrl = arr_str[0];
    }
    return checkStringUrl;
}

@end
