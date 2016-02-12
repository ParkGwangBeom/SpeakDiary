//
//  UIImageView+ContentFileImage.m
//  neo_gooddoc_ios
//
//  Created by yellomobile on 2015. 7. 1..
//  Copyright (c) 2015년 Yellow. All rights reserved.
//

#import "UIImageView+ContentFileImage.h"

@implementation UIImageView (ContentFileImage)

+ (NSString *)imageWithFilePath:(NSString *)fileName {
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *filePath = [bundlePath stringByAppendingPathComponent:fileName];
    
    return filePath;
}
@end
