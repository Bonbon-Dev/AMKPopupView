//
//  AMKPopupView.m
//  AMKPopupView
//
//  Created by https://github.com/AndyM129/AMKPopupView on 2019/7/18.
//

#import "AMKPopupView.h"
#import <Masonry/Masonry.h>

@implementation AMKPopupView
@synthesize imageMaskView = _imageMaskView;
@synthesize animationDuration = _animationDuration;
@synthesize dismissWhenTapped = _dismissWhenTapped;
@synthesize removeFromSuperviewWhenDismissed = _removeFromSuperviewWhenDismissed;
@synthesize contentView = _contentView;
@synthesize contentViewAnimationBlock = _contentViewAnimationBlock;
@synthesize maskViewAnimationBlock = _maskViewAnimationBlock;
@synthesize willShowBlock = _willShowBlock;
@synthesize didShowBlock = _didShowBlock;
@synthesize willDismissBlock = _willDismissBlock;
@synthesize didDismissBlock = _didDismissBlock;

#pragma mark - Init Methods

- (void)dealloc {
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.hidden = YES;
        self.multipleTouchEnabled = NO;
        self.animationDuration = 0.3;
        self.dismissWhenTapped = NO;
        self.removeFromSuperviewWhenDismissed = YES;
        self.imageMaskView.alpha = 0;
        self.tapGestureRecognizer.numberOfTapsRequired = 1;
        self.contentViewOffset = UIOffsetMake(0, 0);
    }
    return self;
}

#pragma mark - Properties

- (BOOL)isAnimating {
    return (self.status==AMKPopupViewStatusShowing || self.status==AMKPopupViewStatusDismissing) ? YES : NO;
}
- (UIImageView *)imageMaskView {
    if (!_imageMaskView) {
        _imageMaskView = [UIImageView new];
        _imageMaskView.clipsToBounds = YES;
        _imageMaskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        [self addSubview:_imageMaskView];
        [_imageMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    return _imageMaskView;
}

- (UITapGestureRecognizer *)tapGestureRecognizer {
    if (!_tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
        _tapGestureRecognizer.numberOfTapsRequired = 1;
        _tapGestureRecognizer.numberOfTouchesRequired = 1;
        _tapGestureRecognizer.delegate = self;
        [self addGestureRecognizer:_tapGestureRecognizer];
    }
    return _tapGestureRecognizer;
}

- (void)setContentView:(UIView *)contentView {
    if (_contentView == contentView) return;
    [_contentView removeFromSuperview];
    
    contentView.alpha = 0;
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (contentView.frame.size.width > 0) {
            make.width.mas_equalTo(contentView.frame.size.width);
        } else {
            make.width.mas_equalTo(self);
        }
        if (contentView.frame.size.height > 0) {
            make.height.mas_equalTo(contentView.frame.size.height);
        } else {
            make.height.mas_equalTo(self);
        }
        make.centerX.mas_equalTo(self).offset(self.contentViewOffset.horizontal);
        make.centerY.mas_equalTo(self).offset(self.contentViewOffset.vertical);
    }];
    _contentView = contentView;
}

// 默认动画: pop动画显示的Spring实现
- (AMKPopupViewContentAnimationBlock)contentViewAnimationBlock {
    if (!_contentViewAnimationBlock) {
        _contentViewAnimationBlock = ^(UIView *contentView, BOOL showAnimation, NSTimeInterval duration) {
            if (showAnimation) {
                contentView.alpha = 0;
                contentView.transform = CGAffineTransformMakeScale(.3, .3);
                duration += duration * 0.5;
                [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    contentView.alpha = 1.0;
                    contentView.transform = CGAffineTransformMakeScale(1.05, 1.05);
                } completion:nil];
            } else {
                [UIView animateWithDuration:duration animations:^{
                    contentView.alpha = 0;
                    contentView.transform = CGAffineTransformMakeScale(.3, .3);
                }];
            }
        };
    }
    return _contentViewAnimationBlock;
}

- (AMKPopupViewContentAnimationBlock)maskViewAnimationBlock {
    if (!_maskViewAnimationBlock) {
        _maskViewAnimationBlock = ^(UIView *maskView, BOOL showAnimation, NSTimeInterval duration) {
            if (showAnimation) {
                maskView.alpha = 0;
            }
            [UIView animateWithDuration:duration animations:^{
                maskView.alpha = showAnimation ? 1 : 0;
            }];
        };
    }
    return _maskViewAnimationBlock;
}

#pragma mark - Layout Subviews

#pragma mark - Public Methods

#pragma mark - Private Methods

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)sender {
    if (!self.dismissWhenTapped) return;
    if ([self shouldHidesWhenTapped:sender]) {
        [self dismissAnimated:YES];
    }
}

- (BOOL)shouldHidesWhenTapped:(UITapGestureRecognizer *)sender {
    if (!self.contentView) return YES;
    if (!self.contentView.userInteractionEnabled) return YES;
    if (self.contentView.hidden) return YES;
    if (self.contentView.alpha <= 0.005) return YES;
    if (self.isAnimating) return NO;
    if (!CGRectContainsPoint(self.contentView.frame, [sender locationInView:self])) return YES;
    return NO;
}

#pragma mark - Notifications

#pragma mark - KVO

#pragma mark - Delegate

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;  // 不允许同时识别多个手势
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.tapGestureRecognizer) {
        return [self shouldHidesWhenTapped:(UITapGestureRecognizer *)gestureRecognizer];
    }
    return YES;
}

#pragma mark AMKPopupViewProtocol

- (UIView *)defaultSuperview {
    return [UIApplication sharedApplication].delegate.window;
}

- (void)showInView:(UIView *)superview animated:(BOOL)animated {
    if (self.isAnimating) return;
    self.status = AMKPopupViewStatusShowing;
    
    if (!superview) superview = self.defaultSuperview;
    [superview addSubview:self];
    [self layoutSubviews];
    self.hidden = NO;
    self.willShowBlock==nil ?: self.willShowBlock(self);
    self.maskViewAnimationBlock(self.imageMaskView, YES, animated?_animationDuration:0);
    if (self.contentView) self.contentViewAnimationBlock(self.contentView, YES, animated?_animationDuration:0);
    
    __weak __typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((animated?self.animationDuration:0) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.status = AMKPopupViewStatusShown;
        weakSelf.didShowBlock ==nil ?: weakSelf.didShowBlock(weakSelf);
    });
}

- (void)showAnimated {
    [self showInView:nil animated:YES];
}

- (void)dismissAnimated:(BOOL)animated {
    self.status = AMKPopupViewStatusDismissing;
    self.willDismissBlock==nil ?: self.willDismissBlock(self);
    self.maskViewAnimationBlock(self.imageMaskView, NO, animated?_animationDuration:0);
    if (self.contentView) self.contentViewAnimationBlock(self.contentView, NO, animated?_animationDuration:0);
    
    __weak __typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((animated?_animationDuration:0) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.hidden = YES;
        weakSelf.status = AMKPopupViewStatusDismissed;
        weakSelf.removeFromSuperviewWhenDismissed==NO ?: [weakSelf removeFromSuperview];
        weakSelf.didDismissBlock ==nil ?: weakSelf.didDismissBlock(weakSelf);
    });
}

- (void)dismissAnimated {
    [self dismissAnimated:YES];
}

#pragma mark - Override

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if (!self.superview) return;
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - Helper Methods

@end
