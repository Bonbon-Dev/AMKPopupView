//
//  AMKPopupViewProtocol.h
//  AMKPopupView
//
//  Created by Andy Meng on 2019/7/18.
//

#import <Foundation/Foundation.h>

/// AMKPopupView 弹窗协议
@protocol AMKPopupViewProtocol <NSObject>
@required
- (UIView * _Nonnull)defaultSuperview;                                      //!< 默认父视图
- (void)showInView:(UIView *_Nullable)superview animated:(BOOL)animated;    //!< 显示方法
- (void)showAnimated;                                                       //!< 显示方法
- (void)dismissAnimated:(BOOL)animated;                                     //!< 移除方法
- (void)dismissAnimated;                                                    //!< 移除方法
@end
