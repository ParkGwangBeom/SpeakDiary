//
//  ActivityView.m
//  HMM
//
//  Created by DoYoung Kim on 10/26/12.
//  Copyright (c) 2012 HMM. All rights reserved.
//

#import "ActivityView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ActivityView
@synthesize originalView = _originalView, labelWidth = _labelWidth;

static ActivityView *activityView = nil;

/*
 currentActivityView
 
 Returns the currently displayed activity view, or nil if there isn't one.
 
 Written by DJS 2009-07.
 */

+ (ActivityView *)currentActivityView;
{
    return activityView;
}

/*
 activityViewForView:
 
 Creates and adds an activity view centered within the specified view, using the label "Loading...".  Returns the activity view, already added as a subview of the specified view.
 
 Written by DJS 2009-07.
 */

+ (ActivityView *)activityViewForView:(UIView *)addToView;
{
    return [self activityViewForView:addToView withLabel:NSLocalizedString(@"로딩중...", @"Default ActivtyView label text") width:0];
}

/*
 activityViewForView:withLabel:
 
 Creates and adds an activity view centered within the specified view, using the specified label.  Returns the activity view, already added as a subview of the specified view.
 
 Written by DJS 2009-07.
 */

+ (ActivityView *)activityViewForView:(UIView *)addToView withLabel:(NSString *)labelText;
{
    return [self activityViewForView:addToView withLabel:labelText width:0];
}

/*
 activityViewForView:withLabel:width:
 
 Creates and adds an activity view centered within the specified view, using the specified label and a fixed label width.  The fixed width is useful if you want to change the label text while the view is visible.  Returns the activity view, already added as a subview of the specified view.
 
 Written by DJS 2009-07.
 */

+ (ActivityView *)activityViewForView:(UIView *)addToView withLabel:(NSString *)labelText width:(NSUInteger)labelWidth;
{
    // Not autoreleased, as it is basically a singleton:
    return [[self alloc] initForView:addToView withLabel:labelText width:labelWidth];
}

/*
 initForView:withLabel:width:
 
 Designated initializer.  Configures the activity view using the specified label text and width, and adds as a subview of the specified view.
 
 Written by DJS 2009-07.
 */

- (ActivityView *)initForView:(UIView *)addToView withLabel:(NSString *)labelText width:(NSUInteger)labelWidth;
{
	if (!(self = [super initWithFrame:CGRectZero]))
		return nil;
	
    // Immediately remove any existing activity view:
    if (activityView)
        [[self class] removeView];
    
    // Remember the new view (it is already retained):
    activityView = self;
    
    // Allow subclasses to change the view to which to add the activity view (e.g. to cover the keyboard):
    self.originalView = addToView;
    addToView = [self viewForView:addToView];
    
    // Configure this view (the background) and the label text (the label is automatically created):
    [self setupBackground];
    self.labelWidth = labelWidth;
    self.activityLabel.text = labelText;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon_alyac"] ofType:@"png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    
    self.iv_Loding.image = image;

    [image release];
    image = nil;
    
    // Assembile the subviews (the border and indicator are automatically created):
	[addToView addSubview:self];
    [self addSubview:self.borderView];

    [self.borderView addSubview:self.iv_Loding];
//    [self.borderView addSubview:self.activityIndicator];
    [self.borderView addSubview:self.activityLabel];
    
	// Animate the view in, if appropriate:
	[self animateShow];
    
	return self;
}

- (void)dealloc;
{
    _activityLabel = nil;
//    _activityIndicator = nil;
    _iv_Loding = nil;
    _borderView = nil;
    _originalView = nil;
    activityView = nil;
    [super dealloc];
}

/*
 removeView
 
 Immediately removes and releases the view without any animation.
 
 Written by DJS 2009-07.
 */

+ (void)removeView;
{
    if (!activityView)
        return;
    
    [activityView removeFromSuperview];
    
    activityView = nil;
}

/*
 viewForView:
 
 Returns the view to which to add the activity view.  By default returns the same view.  Subclasses may override this to change the view.
 
 Written by DJS 2009-07.
 */

- (UIView *)viewForView:(UIView *)view;
{
    return view;
}

/*
 enclosingFrame
 
 Returns the frame to use for the activity view.  Defaults to the superview's bounds.  Subclasses may override this to use something different, if desired.
 
 Written by DJS 2009-07.
 */

- (CGRect)enclosingFrame;
{
    return self.superview.bounds;
}

/*
 setupBackground
 
 Configure the background of the activity view.
 
 Written by DJS 2009-07.
 */

- (void)setupBackground;
{
	self.opaque = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

/*
 borderView
 
 Returns the view to contain the activity indicator and label.  By default this view is transparent.
 
 Written by DJS 2009-07.
 */

- (UIView *)borderView;
{
    if (!_borderView)
    {
        _borderView = [[UIView alloc] initWithFrame:CGRectZero];
        
        _borderView.opaque = NO;
        _borderView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    
    return _borderView;
}

/*
 activityIndicator
 
 Returns the activity indicator view, creating it if necessary.
 
 Written by DJS 2009-07.
 */

//- (UIActivityIndicatorView *)activityIndicator;
//{
//    if (!_activityIndicator)
//    {
//        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        [_activityIndicator startAnimating];
//    }
//    
//    return _activityIndicator;
//}

/*
 activityLabel
 
 Returns the activity label, creating it if necessary.
 
 Written by DJS 2009-07.
 */

- (UILabel *)activityLabel;
{
    if (!_activityLabel)
    {
        _activityLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        _activityLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        [_activityLabel setTextAlignment:NSTextAlignmentCenter];
        _activityLabel.textColor = [UIColor blackColor];
        _activityLabel.backgroundColor = [UIColor clearColor];
        _activityLabel.shadowColor = [UIColor whiteColor];
        _activityLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    }
    
    return _activityLabel;
}

/*
 layoutSubviews
 
 Positions and sizes the various views that make up the activity view, including after rotation.
 
 Written by DJS 2009-07.
 */

- (void)layoutSubviews;
{
    self.frame = [self enclosingFrame];
    
    // If we're animating a transform, don't lay out now, as can't use the frame property when transforming:
    if (!CGAffineTransformIsIdentity(self.borderView.transform))
        return;
    
    CGSize textSize = [self.activityLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[UIFont systemFontSize]]}];
    
    // Use the fixed width if one is specified:
    if (self.labelWidth > 10)
        textSize.width = self.labelWidth;
    
    self.activityLabel.frame = CGRectMake(self.activityLabel.frame.origin.x, self.activityLabel.frame.origin.y, textSize.width, textSize.height);
    self.iv_Loding.frame = CGRectMake(0.0f, 0.0f, 100.0f, 100.0f);
    
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon_alyac"] ofType:@"png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    
    [self.iv_Loding setImage:image];
    
    [image release];
    image = nil;

    
    // Calculate the size and position for the border view: with the indicator to the left of the label, and centered in the receiver:
	CGRect borderFrame = CGRectZero;
    borderFrame.size.width = self.iv_Loding.frame.size.width + textSize.width + 25.0;
    borderFrame.size.height = self.iv_Loding.frame.size.height + 10.0;
    borderFrame.origin.x = floor(0.5 * (self.frame.size.width - borderFrame.size.width));
    borderFrame.origin.y = floor(0.5 * (self.frame.size.height - borderFrame.size.height));
    self.borderView.frame = borderFrame;
	
    // Calculate the position of the indicator: vertically centered and at the left of the border view:
    CGRect indicatorFrame = self.iv_Loding.frame;
	indicatorFrame.origin.x = 10.0;
	indicatorFrame.origin.y = 0.5 * (borderFrame.size.height - indicatorFrame.size.height);
    self.iv_Loding.frame = indicatorFrame;
    
    // Calculate the position of the label: vertically centered and at the right of the border view:
	CGRect labelFrame = self.activityLabel.frame;
    labelFrame.origin.x = borderFrame.size.width - labelFrame.size.width - 10.0;
	labelFrame.origin.y = floor(0.5 * (borderFrame.size.height - labelFrame.size.height));
    self.activityLabel.frame = labelFrame;
}

/*
 animateShow
 
 Animates the view into visibility.  Does nothing for the simple activity view.
 
 Written by DJS 2009-07.
 */

- (void)animateShow;
{
    // Does nothing by default
}

/*
 animateRemove
 
 Animates the view out of visibiltiy.  Does nothng for the simple activity view.
 
 Written by DJS 2009-07.
 */

- (void)animateRemove;
{
    // Does nothing by default
}

@end


// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------


@implementation BezelActivityView

/*
 viewForView:
 
 Returns the view to which to add the activity view.  For the bezel style, if there is a keyboard displayed, the view is changed to the keyboard's superview.
 
 Written by DJS 2009-07.
 */

- (UIView *)viewForView:(UIView *)view;
{
    UIView *keyboardView = [[UIApplication sharedApplication] keyboardView];
    
    if (keyboardView)
        view = keyboardView.superview;
    
    return view;
}

/*
 enclosingFrame
 
 Returns the frame to use for the activity view.  For the bezel style, if there is a keyboard displayed, the frame is changed to cover the keyboard too.
 
 Written by DJS 2009-07.
 */

- (CGRect)enclosingFrame;
{
    CGRect frame = [super enclosingFrame];
    
    if (self.superview != self.originalView)
        frame = [self.originalView convertRect:self.originalView.bounds toView:self.superview];
    
    return frame;
}

/*
 setupBackground
 
 Configure the background of the activity view.
 
 Written by DJS 2009-07.
 */

- (void)setupBackground;
{
    [super setupBackground];
    
	self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
}

/*
 borderView
 
 Returns the view to contain the activity indicator and label.  The bezel style has a semi-transparent rounded rectangle.
 
 Written by DJS 2009-07.
 */

- (UIView *)borderView;
{
    if (!_borderView)
    {
        [super borderView];
        
        _borderView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _borderView.layer.cornerRadius = 10.0;
    }
    
    return _borderView;
}

/*
 activityIndicator
 
 Returns the activity indicator view, creating it if necessary.
 
 Written by DJS 2009-07.
 */

//- (UIActivityIndicatorView *)activityIndicator;
//{
//    if (!_activityIndicator)
//    {
//        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        [_activityIndicator startAnimating];
//    }
//    
//    return _activityIndicator;
//}

/*
 activityLabel
 
 Returns the activity label, creating it if necessary.
 
 Written by DJS 2009-07.
 */

- (UILabel *)activityLabel;
{
    if (!_activityLabel)
    {
        _activityLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        _activityLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
        _activityLabel.textAlignment = NSTextAlignmentCenter;
        _activityLabel.textColor = [UIColor whiteColor];
        _activityLabel.backgroundColor = [UIColor clearColor];
    }
    
    return _activityLabel;
}

- (UIImageView *)iv_Loding;
{
    if (!_iv_Loding)
    {
        _iv_Loding = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    
    return _iv_Loding;
}

/*
 layoutSubviews
 
 Positions and sizes the various views that make up the activity view, including after rotation.
 
 Written by DJS 2009-07.
 */

- (void)layoutSubviews;
{
    // If we're animating a transform, don't lay out now, as can't use the frame property when transforming:
    if (!CGAffineTransformIsIdentity(self.borderView.transform))
        return;
    
    self.frame = [self enclosingFrame];

    CGSize textSize = [self.activityLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[UIFont systemFontSize]]}];
    
    // Use the fixed width if one is specified:
    if (self.labelWidth > 10)
        textSize.width = self.labelWidth;
    
    // Require that the label be at least as wide as the indicator, since that width is used for the border view:
    if (textSize.width < self.iv_Loding.frame.size.width)
        textSize.width = self.iv_Loding.frame.size.width + 10.0;
    
    DLog(@"%f",self.iv_Loding.frame.size.width);
    // If there's no label text, don't need to allow height for it:
    if (self.activityLabel.text.length == 0)
        textSize.height = 0.0;
    
    self.iv_Loding.frame = CGRectMake(0.0f, 0.0f, 100.0f, 100.0f);
    
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"alyac_spin_1"] ofType:@"png"];
    UIImage *image1 = [[UIImage alloc] initWithContentsOfFile:path];

    NSString *path2 = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"alyac_spin_2"] ofType:@"png"];
    UIImage *image2 = [[UIImage alloc] initWithContentsOfFile:path2];

    NSString *path3 = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"alyac_spin_3"] ofType:@"png"];
    UIImage *image3 = [[UIImage alloc] initWithContentsOfFile:path3];

    NSString *path4 = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"alyac_spin_4"] ofType:@"png"];
    UIImage *image4 = [[UIImage alloc] initWithContentsOfFile:path4];

    NSString *path5 = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"alyac_spin_5"] ofType:@"png"];
    UIImage *image5 = [[UIImage alloc] initWithContentsOfFile:path5];

    NSString *path6 = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"alyac_spin_6"] ofType:@"png"];
    UIImage *image6 = [[UIImage alloc] initWithContentsOfFile:path6];

    NSString *path7 = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"alyac_spin_7"] ofType:@"png"];
    UIImage *image7 = [[UIImage alloc] initWithContentsOfFile:path7];

    NSString *path8 = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"alyac_spin_8"] ofType:@"png"];
    UIImage *image8 = [[UIImage alloc] initWithContentsOfFile:path8];

    NSArray *aniAr = [NSArray arrayWithObjects:image1, image2, image3, image4, image5, image6, image7, image8, nil];
    
    [image1 release];image1 = nil;
    [image2 release];image2 = nil;
    [image3 release];image3 = nil;
    [image4 release];image4 = nil;
    [image5 release];image5 = nil;
    [image6 release];image6 = nil;
    [image7 release];image7 = nil;
    [image8 release];image8 = nil;
    
    self.iv_Loding.animationImages = aniAr;
    self.iv_Loding.animationDuration = 0.7;

    [self.iv_Loding startAnimating];
    
    DLog(@"%f",self.iv_Loding.frame.size.width);
    DLog(@"%f",self.activityLabel.frame.size.width);
    
    self.activityLabel.frame = CGRectMake(self.activityLabel.frame.origin.x, self.activityLabel.frame.origin.y, textSize.width, textSize.height);
    
     DLog(@"%f",self.iv_Loding.frame.size.width);
     DLog(@"%f",self.activityLabel.frame.size.width);
    
    // Calculate the size and position for the border view: with the indicator vertically above the label, and centered in the receiver:
	CGRect borderFrame = CGRectZero;
    borderFrame.size.width = textSize.width + 30.0;
    borderFrame.size.height = self.iv_Loding.frame.size.height + textSize.height + 40.0;
    borderFrame.origin.x = floor(0.5 * (self.frame.size.width - borderFrame.size.width));
    borderFrame.origin.y = floor(0.5 * (self.frame.size.height - borderFrame.size.height));
    self.borderView.frame = borderFrame;
	
    // Calculate the position of the indicator: horizontally centered and near the top of the border view:
    CGRect indicatorFrame = self.iv_Loding.frame;
	indicatorFrame.origin.x = 0.5 * (borderFrame.size.width - indicatorFrame.size.width);
	indicatorFrame.origin.y = 20.0;
    self.iv_Loding.frame = indicatorFrame;
    
    // Calculate the position of the label: horizontally centered and near the bottom of the border view:
	CGRect labelFrame = self.activityLabel.frame;
    labelFrame.origin.x = floor(0.5 * (borderFrame.size.width - labelFrame.size.width));
	labelFrame.origin.y = borderFrame.size.height - labelFrame.size.height - 10.0;
    self.activityLabel.frame = labelFrame;
}

/*
 animateShow
 
 Animates the view into visibility.  For the bezel style, fades in the background and zooms the bezel down from a large size.
 
 Written by DJS 2009-07.
 */

- (void)animateShow;
{
    self.alpha = 0.0;
    self.borderView.transform = CGAffineTransformMakeScale(3.0, 3.0);
    
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];            // Uncomment to see the animation in slow motion
	
    self.borderView.transform = CGAffineTransformIdentity;
    self.alpha = 1.0;
    
	[UIView commitAnimations];
}

/*
 animateRemove
 
 Animates the view out, deferring the removal until the animation is complete.  For the bezel style, fades out the background and zooms the bezel down to half size.
 
 Written by DJS 2009-07.
 */

- (void)animateRemove;
{
    [self.iv_Loding stopAnimating];
    self.borderView.transform = CGAffineTransformIdentity;
    
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];            // Uncomment to see the animation in slow motion
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(removeAnimationDidStop:finished:context:)];
	
    self.borderView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    self.alpha = 0.0;
    
	[UIView commitAnimations];
}

- (void)removeAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
{
    [[self class] removeView];
}

/*
 removeViewAnimated:
 
 Animates the view out from the superview and releases it, or simply removes and releases it immediately if not animating.
 
 Written by DJS 2009-07.
 */

+ (void)removeViewAnimated:(BOOL)animated;
{
    if (!activityView)
        return;
    
    if (animated)
        [activityView animateRemove];
    else
        [[self class] removeView];
}

@end


// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------


@implementation KeyboardActivityView

/*
 activityView
 
 Creates and adds a keyboard-style activity view, using the label "Loading...".  Returns the activity view, already covering the keyboard, or nil if the keyboard isn't currently displayed.
 
 Written by DJS 2009-07.
 */

+ (KeyboardActivityView *)activityView;
{
    return [self activityViewWithLabel:NSLocalizedString(@"Loading...", @"Default ActivtyView label text")];
}

/*
 activityViewWithLabel:
 
 Creates and adds a keyboard-style activity view, using the specified label.  Returns the activity view, already covering the keyboard, or nil if the keyboard isn't currently displayed.
 
 Written by DJS 2009-07.
 */

+ (KeyboardActivityView *)activityViewWithLabel:(NSString *)labelText;
{
    UIView *keyboardView = [[UIApplication sharedApplication] keyboardView];
    
    if (!keyboardView)
        return nil;
    else
        return (KeyboardActivityView *)[self activityViewForView:keyboardView withLabel:labelText];
}

/*
 viewForView:
 
 Returns the view to which to add the activity view.  For the keyboard style, returns the same view (which will already be the keyboard).
 
 Written by DJS 2009-07.
 */

- (UIView *)viewForView:(UIView *)view;
{
    return view;
}

/*
 animateShow
 
 Animates the view into visibility.  For the keyboard style, simply fades in.
 
 Written by DJS 2009-07.
 */

- (void)animateShow;
{
    self.alpha = 0.0;
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	
    self.alpha = 1.0;
    
	[UIView commitAnimations];
}

/*
 animateRemove
 
 Animates the view out, deferring the removal until the animation is complete.  For the keyboard style, simply fades out.
 
 Written by DJS 2009-07.
 */

- (void)animateRemove;
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(removeAnimationDidStop:finished:context:)];
	
    self.alpha = 0.0;
    
	[UIView commitAnimations];
}

/*
 setupBackground
 
 Configure the background of the activity view.
 
 Written by DJS 2009-07.
 */

- (void)setupBackground;
{
    [super setupBackground];
    
	self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
}

/*
 borderView
 
 Returns the view to contain the activity indicator and label.  The keyboard style has a transparent border.
 
 Written by DJS 2009-07.
 */

- (UIView *)borderView;
{
    if (!_borderView)
        [super borderView].backgroundColor = nil;
    
    return _borderView;
}

@end


// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------


@implementation UIApplication (KeyboardView)

//  keyboardView
//
//  Copyright Matt Gallagher 2009. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.

- (UIView *)keyboardView;
{
	NSArray *windows = [self windows];
	for (UIWindow *window in [windows reverseObjectEnumerator])
	{
		for (UIView *view in [window subviews])
		{
            printf("%s\n", object_getClassName(view));
			if (!strcmp(object_getClassName(view), "UIKeyboard") || !strcmp(object_getClassName(view), "UIPeripheralHostView"))
			{
				return view;
			}
		}
	}
	
	return nil;
}

@end
