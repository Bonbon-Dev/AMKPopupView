//
//  AMKGuideView.h
//  AMKPopupView_Example
//
//  Created by https://github.com/AndyM129/AMKPopupView on 2019/7/18.
//  Copyright (c) 2019 Andy Meng. All rights reserved.
//

#import <AMKPopupView/AMKPopupView.h>

NS_ASSUME_NONNULL_BEGIN

/** 新手引导页 */
@interface AMKGuideView : AMKPopupView

/** ifNeeded为YES时，仅未显示过引导页时才显示 */
- (void)showInView:(UIView *_Nullable)superview ifNeeded:(BOOL)ifNeeded animated:(BOOL)animated;

@end


NS_ASSUME_NONNULL_END
