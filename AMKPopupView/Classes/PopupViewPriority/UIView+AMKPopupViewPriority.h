//
//  AMKPopupView+AMKPopupViewPriority.h
//  AMKPopupView
//
//  Created by https://github.com/AndyM129/AMKPopupView on 2019/7/18.
//

#import "AMKPopupView.h"

NS_ASSUME_NONNULL_BEGIN

/// 弹窗显示优先级
typedef NSInteger const AMKPopupPriority;
static AMKPopupPriority AMKPopupViewDefaultPriority              = 0;
static AMKPopupPriority AMKPopupViewLowPriority                  = 100;
static AMKPopupPriority AMKPopupViewLowHigherPriority            = 250;
static AMKPopupPriority AMKPopupViewMiddlePriority               = 500;
static AMKPopupPriority AMKPopupViewMiddleHigherPriority         = 750;
static AMKPopupPriority AMKPopupViewHighPriority                 = 1000;


/// 弹窗视图优先级处理
@interface UIView (AMKPopupViewPriority)

/// 显示优先级调试开关，默认值为 YES
@property(nonatomic, assign, class) BOOL amk_popupPriorityDebugEnable;

/// 显示优先级，默认值为 AMKPopupViewDefaultPriority
@property(nonatomic, assign) AMKPopupPriority amk_popupPriority;

/// 当前视图所有弹窗子视图
- (NSArray<UIView<AMKPopupViewProtocol> *> *)amk_subPopupViews;

@end

NS_ASSUME_NONNULL_END
