//
//  DatePickerView.h
//  RightNowClient
//
//  Created by 광범 on 2015. 8. 19..
//  Copyright (c) 2015년 박광범. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerViewDelegate <NSObject>

@optional
-(void)setDate:(NSDate *)date;

@end

@interface DatePickerView : UIViewController

@property (nonatomic, assign) id<DatePickerViewDelegate> delegate;

@end
