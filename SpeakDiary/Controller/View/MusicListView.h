//
//  MusicListView.h
//  SpeakDiary
//
//  Created by 광범 on 2015. 8. 29..
//  Copyright (c) 2015년 박광범. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MusicListViewDelegate <NSObject>

-(void)clickMusic:(NSString *)musicName;
-(void)PopupClose;

@end

@interface MusicListView : UIViewController

@property (nonatomic, assign) id<MusicListViewDelegate> delegate;
@end
