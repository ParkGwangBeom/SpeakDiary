//
//  Emoticon.h
//  SpeakDiary
//
//  Created by 광범 on 2015. 8. 29..
//  Copyright (c) 2015년 박광범. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Emoticon : NSObject

+(NSString *)getEmoticonString:(NSInteger)emoticonType;
+(NSString *)getBigEmoticonString:(NSInteger)emoticonType;
@end
