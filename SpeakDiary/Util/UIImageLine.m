//
//  UIImageLine.m
//  RightNow
//
//  Created by 광범 on 2015. 8. 26..
//  Copyright (c) 2015년 RightNow. All rights reserved.
//

#import "UIImageLine.h"

@implementation UIImageLine

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self setupLine];
}

-(void)setupLine{
    [self setBackgroundColor:[UIColor colorWithRed:212.0f/255.0f green:212.0f/255.0f blue:212.0f/255.0f alpha:1.0f]];
    self.frameHeight = 0.5;
    self.frameY = self.frameY + 0.5f;
}

@end
