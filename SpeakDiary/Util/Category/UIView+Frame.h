//
//  UIView+Frame.h
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

#pragma mark - Set Frame

@property (nonatomic) CGPoint	frameOrigin;
@property (nonatomic) CGSize	frameSize;

@property (nonatomic) CGFloat	frameX;
@property (nonatomic) CGFloat	frameY;

@property (nonatomic) CGFloat	frameRight;
@property (nonatomic) CGFloat	frameBottom;

@property (nonatomic) CGFloat	frameWidth;
@property (nonatomic) CGFloat	frameHeight;

@property (nonatomic) CGFloat	centerX;
@property (nonatomic) CGFloat	centerY;

@property (nonatomic) CGFloat   frameBottomLineY;

@end
