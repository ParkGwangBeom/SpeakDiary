//
//  UIImage+UIImageExtension.m
//  neo_gooddoc_ios
//
//  Created by yellomobile on 2015. 2. 16..
//  Copyright (c) 2015년 Yellow. All rights reserved.
//

#import "UIImage+UIImageExtension.h"

@implementation UIImage (UIImageExtension)

static NSMutableDictionary *__imageSessions;

+ (NSMutableDictionary *)_imageSessions {
    if (__imageSessions == nil) {
        __imageSessions = [[NSMutableDictionary alloc] init];
    }
    return __imageSessions;
}

+ (NSMutableDictionary *)_sessionForKey:(NSString *)key {
    NSMutableDictionary *data = [self _imageSessions];
    NSMutableDictionary *session = [data objectForKey:key];
    if (session == nil) {
        session = [NSMutableDictionary dictionary];
        [data setObject:session forKey:key];
    }
    return session;
}
+ (UIImage *)_findImageWithName:(NSString *)name {
    NSArray *sessionKeys = [__imageSessions allKeys];
    UIImage *image = nil;
    for (int i = 0; i < [sessionKeys count] && image == nil; i++) {
        NSMutableDictionary *session = [__imageSessions objectForKey:[sessionKeys objectAtIndex:i]];
        image = [session objectForKey:name];
    }
    return image;
}

+ (UIImage *)imageNamed:(NSString *)name forSession:(id)session {
    NSString *key = [NSString stringWithFormat:@"%p",session];
    
    NSMutableDictionary *sessionContainer = [self _sessionForKey:key];
    
    UIImage *image = [sessionContainer objectForKey:name];
    
    if (image != nil) {
        return image;
    } else {
        image = [self _findImageWithName:name]; //다른곳에 등록된 이미지를 찾는다
        
        if (image == nil) {
            NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
            if (path != nil) {
                image = [UIImage imageWithContentsOfFile:path];
            }
        }
        if (image != nil) {
            [sessionContainer setObject:image forKey:name];
        }
        
    }
    return image;
}

+ (void)clearSession:(id)session {
    if (session == nil) return;
    NSString *key = [NSString stringWithFormat:@"%p",session];
    [__imageSessions removeObjectForKey:key];
}

@end
