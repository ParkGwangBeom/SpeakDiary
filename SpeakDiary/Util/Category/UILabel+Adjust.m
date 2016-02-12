//
//  UILabel+Adjust.m
//

#import "UILabel+Adjust.h"
#import "UIView+Frame.h"

@implementation UILabel (Adjust)

- (void)adjustsHeight
{
	if (self.text.length == 0) {
		self.frameHeight = self.font.lineHeight;
		return;
	}
	
	CGFloat maxHeight_ = CGFLOAT_MAX;
	if (self.numberOfLines > 0) {
		maxHeight_ = ceilf((CGFloat)self.font.lineHeight*self.numberOfLines);
	}
	
	self.frameHeight = ceilf([self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frameWidth, maxHeight_) lineBreakMode:self.lineBreakMode].height);
}

- (void)adjustsWidthWithMax:(CGFloat)max
{
	CGSize titleSize_ = CGSizeZero;
	
	if ([self respondsToSelector:@selector(attributedText)]) {
		NSAttributedString *attributedText_ = self.attributedText;
		if (attributedText_.length > 0) {
			titleSize_ = attributedText_.size;
		}
	}
	
	if (CGSizeEqualToSize(titleSize_, CGSizeZero)) {
		titleSize_ = [self.text sizeWithFont:self.font forWidth:CGFLOAT_MAX lineBreakMode:self.lineBreakMode];
	}
	
	CGFloat	maxWidth_ = ceilf((max==0.0f?CGFLOAT_MAX:max));
	
	self.frameWidth	= ceilf([self.text sizeWithFont:self.font forWidth:maxWidth_ lineBreakMode:self.lineBreakMode].width);
}

- (void)adjustsWidth
{
	[self adjustsWidthWithMax:0.0f];
}

@end
