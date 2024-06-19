//
//  CenteredButton.m
//  ESSideBar
//
//  Created by Viking on 2018. 05. 18..
//  Copyright © 2018. Astron Informatikai Kft. All rights reserved.
//

#import "CenteredButton.h"

@implementation CenteredButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect rect = [super titleRectForContentRect: contentRect];
    return CGRectMake(0,
                      contentRect.size.height - rect.size.height - 5,
                      contentRect.size.width,
                      rect.size.height + 5);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGRect rect = [super imageRectForContentRect: contentRect];
    CGRect titleRect = [self titleRectForContentRect: contentRect];
    
    return CGRectMake(contentRect.size.width / 2.0 - rect.size.width / 2.0,
                      (contentRect.size.height - titleRect.size.height)/2.0 - rect.size.height/2.0,
                      rect.size.width,
                      rect.size.height);
}

- (CGSize)intrinsicContentSize {
    CGSize imageSize = [super intrinsicContentSize];
    
    if (self.imageView.image) {
        UIImage* image = self.imageView.image;
        CGFloat labelHeight = 0.0;
        
        CGSize labelSize = [self.titleLabel sizeThatFits: CGSizeMake([self contentRectForBounds: self.bounds].size.width, CGFLOAT_MAX)];
        if (CGSizeEqualToSize(imageSize, labelSize)) {
            labelHeight = imageSize.height;
        }
        
        return CGSizeMake(MAX(labelSize.width, imageSize.width), image.size.height + labelHeight + 30);
    }
    
    return imageSize;
}

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self centerTitleLabel];
    }
    return self;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self centerTitleLabel];
    }
    return self;
}

- (void)centerTitleLabel {
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    //self.titleLabel.font = [UIFont fontWithName:@"Teko-Regular" size:12.0];
    self.titleLabel.numberOfLines = 2;
    
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 0;
    style.lineHeightMultiple = 0.75;
    style.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString* attributedTitle = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text attributes:@{ NSParagraphStyleAttributeName: style }];
    
    self.titleLabel.attributedText = attributedTitle;
    //[self setTitleColor:COLOR_TEXT_LIGHT forState:UIControlStateNormal];
}

@end
