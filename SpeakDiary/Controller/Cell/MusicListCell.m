//
//  MusicListCell.m
//  SpeakDiary
//
//  Created by 광범 on 2015. 8. 29..
//  Copyright (c) 2015년 박광범. All rights reserved.
//

#import "MusicListCell.h"

@implementation MusicListCell

-(void)configureCell:(NSString *)item row:(NSInteger)row{
    self.lb_MusicName.text = item;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
