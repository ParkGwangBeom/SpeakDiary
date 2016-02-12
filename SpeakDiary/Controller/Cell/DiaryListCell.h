//
//  DiaryListCell.h
//  SpeakDiary
//
//  Created by 광범 on 2015. 8. 29..
//  Copyright (c) 2015년 박광범. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Entity;

@interface DiaryListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_Date;
@property (weak, nonatomic) IBOutlet UILabel *lb_addr;
@property (weak, nonatomic) IBOutlet UIImageView *iv_Emoticon;
@property (weak, nonatomic) IBOutlet UIImageView *iv_Weader;
@property (weak, nonatomic) IBOutlet UILabel *lb_Content;

-(void)configureCell:(Entity *)item row:(NSInteger)row;
@end
