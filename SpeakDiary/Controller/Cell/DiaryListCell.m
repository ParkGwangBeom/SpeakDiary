//
//  DiaryListCell.m
//  SpeakDiary
//
//  Created by 광범 on 2015. 8. 29..
//  Copyright (c) 2015년 박광범. All rights reserved.
//

#import "DiaryListCell.h"

#import "Entity.h"

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

@implementation DiaryListCell

-(void)configureCell:(Entity *)item row:(NSInteger)row{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.lb_Content.text = item.title;
    self.lb_addr.text = item.addr;
    self.lb_Date.text = [NSString stringWithFormat:@"%ld일",[item.day integerValue]];
    
    [self.lb_Date adjustsWidth];
    self.iv_Emoticon.frameX = self.lb_Date.frameRight + 3.0f;
    self.iv_Weader.frameX = self.iv_Emoticon.frameRight + 1.0;
    
    [self.iv_Emoticon setImage:[UIImage imageNamed:[Emoticon getEmoticonString:[item.emoticon integerValue]]]];

    [self setWeatherImage:item];
}


-(void)setWeatherImage:(Entity *)item{
    UIImage *weatherImage;
    if([item.weader integerValue] == 1){
        weatherImage = [UIImage imageNamed:@"icn_Sun_Big.png"];
    }else if([item.weader integerValue] == 2){
        weatherImage = [UIImage imageNamed:@"icn_Rain_Big.png"];
    }else if([item.weader integerValue] == 3){
        weatherImage = [UIImage imageNamed:@"icn_Cloud_Big.png"];
    }else if([item.weader integerValue] == 4){
        weatherImage = [UIImage imageNamed:@"icn_Sun_Big.png"];
    }else{
        weatherImage = [UIImage imageNamed:@"icn_Sun_Big.png"];
    }
    self.iv_Weader.image = weatherImage;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
