//
//  AMKGuideView.m
//  AMKPopupView_Example
//
//  Created by https://github.com/AndyM129/AMKPopupView on 2019/7/18.
//  Copyright (c) 2019 Andy Meng. All rights reserved.
//

#import "AMKGuideView.h"

@implementation AMKGuideView

#pragma mark - Init Methods

- (void)dealloc {
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.maskView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:.9];
        self.dismissWhenTapped = YES;
        self.contentViewAnimationBlock = ^(UIView *contentView, BOOL showAnimation, NSTimeInterval duration) {
            if (showAnimation) {
                contentView.alpha = 0;
            }
            [UIView animateWithDuration:duration animations:^{
                contentView.alpha = showAnimation ? 1 : 0;
            }];
        };
        self.contentView = ({
            UIImage *image = [UIImage imageNamed:@"amk_guide_n"];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = image;
            imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
            imageView;
        });
    }
    return self;
}

#pragma mark - Properties

#pragma mark - Layout Subviews

#pragma mark - Public Methods

- (void)showInView:(UIView *_Nullable)superview ifNeeded:(BOOL)ifNeeded animated:(BOOL)animated {
    static BOOL hasShown = NO;
    
    if (!ifNeeded || !hasShown) {
        [self showInView:superview animated:animated];
    }
}

#pragma mark - Private Methods

#pragma mark - Notifications

#pragma mark - KVO

#pragma mark - Delegate

#pragma mark - Override

#pragma mark - Helper Methods


@end
