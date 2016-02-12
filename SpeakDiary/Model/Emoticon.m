//
//  Emoticon.m
//  SpeakDiary
//
//  Created by 광범 on 2015. 8. 29..
//  Copyright (c) 2015년 박광범. All rights reserved.
//

#import "Emoticon.h"

enum{
    k1 = 0,
    k2,
    k3,
    k4,
    k5,
    k6,
    k7
};

@implementation Emoticon

+(NSString *)getEmoticonString:(NSInteger)emoticonType{
    NSString *ImageString;
    
    switch (emoticonType) {
        case k1:{
            ImageString = @"icn_Smile.png";
        }break;
            
        case k2:{
            ImageString = @"icn_Sad.png";
        }break;
            
        case k3:{
            ImageString = @"icn_Love.png";
        }break;
    }
    
    return ImageString;
}

+(NSString *)getBigEmoticonString:(NSInteger)emoticonType{
    NSString *ImageString;
    
    switch (emoticonType) {
        case k1:{
            ImageString = @"icn_Smile_Big.png";
        }break;
            
        case k2:{
            ImageString = @"icn_Sad_Big.png";
        }break;
            
        case k3:{
            ImageString = @"icn_Love_Big.png";
        }break;
    }
    
    return ImageString;
}

@end
