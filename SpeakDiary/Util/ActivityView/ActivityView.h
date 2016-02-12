//
//  ActivityView.h
//  HMM
//
//  Created by DoYoung Kim on 10/26/12.
//  Copyright (c) 2012 HMM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityView : UIView
{
    UIView *_originalView;
    UIView *_borderView;
//    UIActivityIndicatorView *_activityIndicator;
    UIImageView *_iv_Loding;
    UILabel *_activityLabel;
    NSUInteger _labelWidth;
}

// The view to contain the activity indicator and label.  The bezel style has a semi-transparent rounded rectangle, others are fully transparent:
@property (nonatomic, readonly) UIView *borderView;

// The activity indicator view; automatically created on first access:
//@property (nonatomic, readonly) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIImageView *iv_Loding;

// The activity label; automatically created on first access:
@property (nonatomic, readonly) UILabel *activityLabel;

// A fixed width for the label text, or zero to automatically calculate the text size (normally set on creation of the view object):
@property (nonatomic) NSUInteger labelWidth;

//  Returns the currently displayed activity view, or nil if there isn't one:
+ (ActivityView *)currentActivityView;

// Creates and adds an activity view centered within the specified view, using the label "Loading...".  Returns the activity view, already added as a subview of the specified view:
+ (ActivityView *)activityViewForView:(UIView *)addToView;

// Creates and adds an activity view centered within the specified view, using the specified label.  Returns the activity view, already added as a subview of the specified view:
+ (ActivityView *)activityViewForView:(UIView *)addToView withLabel:(NSString *)labelText;

// Creates and adds an activity view centered within the specified view, using the specified label and a fixed label width.  The fixed width is useful if you want to change the label text while the view is visible.  Returns the activity view, already added as a subview of the specified view:
+ (ActivityView *)activityViewForView:(UIView *)addToView withLabel:(NSString *)labelText width:(NSUInteger)labelWidth;

// Designated initializer.  Configures the activity view using the specified label text and width, and adds as a subview of the specified view:
- (ActivityView *)initForView:(UIView *)addToView withLabel:(NSString *)labelText width:(NSUInteger)labelWidth;

// Immediately removes and releases the view without any animation:
+ (void)removeView;

@end


// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------


// These methods are exposed for subclasses to override to customize the appearance and behavior; see the implementation for details:

@interface ActivityView ()

@property (nonatomic, retain) UIView *originalView;

- (UIView *)viewForView:(UIView *)view;
- (CGRect)enclosingFrame;
- (void)setupBackground;
- (void)animateShow;
- (void)animateRemove;

@end


// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------


@interface BezelActivityView : ActivityView
{
}

// Animates the view out from the superview and releases it, or simply removes and releases it immediately if not animating:
+ (void)removeViewAnimated:(BOOL)animated;

@end


// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------


@interface KeyboardActivityView : BezelActivityView
{
}

// Creates and adds a keyboard-style activity view, using the label "Loading...".  Returns the activity view, already covering the keyboard, or nil if the keyboard isn't currently displayed:
+ (KeyboardActivityView *)activityView;

// Creates and adds a keyboard-style activity view, using the specified label.  Returns the activity view, already covering the keyboard, or nil if the keyboard isn't currently displayed:
+ (KeyboardActivityView *)activityViewWithLabel:(NSString *)labelText;

@end


// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------


@interface UIApplication (KeyboardView)

- (UIView *)keyboardView;

@end;

