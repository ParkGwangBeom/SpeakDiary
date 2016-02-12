//
//  EmoticonView.h
//  SpeakDiary
//
//  Created by 광범 on 2015. 8. 29..
//  Copyright © 2015년 박광범. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EmoticonViewDelegate <NSObject>

-(void)clickEmoticon:(NSInteger)emoticonType;
-(void)PopupClose;

@end

@interface EmoticonView : UIViewController

@property (nonatomic, assign) id<EmoticonViewDelegate> delegate;

@end
