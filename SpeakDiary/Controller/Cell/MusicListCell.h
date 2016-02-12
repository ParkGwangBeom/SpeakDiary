//
//  MusicListCell.h
//  SpeakDiary
//
//  Created by 광범 on 2015. 8. 29..
//  Copyright (c) 2015년 박광범. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_MusicName;
-(void)configureCell:(NSString *)item row:(NSInteger)row;
@end
