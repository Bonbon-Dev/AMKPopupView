//
//  AMKPopupView.h
//  AMKPopupView
//
//  Created by https://github.com/AndyM129/AMKPopupView on 2019/7/18.
//

#import <UIKit/UIKit.h>
#import "AMKPopupViewProtocol.h"

/// 弹窗显示状态
typedef NS_ENUM(NSInteger, AMKPopupViewStatus) {
    AMKPopupViewStatusDismissed,       //!< 弹窗显示状态：未显示
    AMKPopupViewStatusShowing,         //!< 弹窗显示状态：显示动画中
    AMKPopupViewStatusShown,           //!< 弹窗显示状态：正在显示
    AMKPopupViewStatusDismissing,      //!< 弹窗显示状态：移除动画中
};

/// 回调定义
@class AMKPopupView;
typedef void(^AMKPopupViewContentAnimationBlock)(UIView *animationView, BOOL showAnimation, NSTimeInterval duration); //!< 视图的显隐动画
typedef void(^AMKPopupViewAnimationCallbackBlock)(AMKPopupView *popupView);                                           //!< 弹窗视图显隐动画的回调

/// 弹窗视图
@interface AMKPopupView : UIView <AMKPopupViewProtocol, UIGestureRecognizerDelegate> {
@protected
    UIImageView *_imageMaskView;                                                        //!< 遮罩背景
    CGFloat _animationDuration;                                                         //!< 动画时长
    BOOL _animating;                                                                    //!< 是否正在动画
    BOOL _dismissWhenTapped;                                                            //!< 点击背景移除弹框（默认NO）
    BOOL _removeFromSuperviewWhenDismissed;                                             //!< 移除时并从父视图移除（默认Yes）
    UIView *_contentView;                                                               //!< 弹窗主体自定义视图
    AMKPopupViewContentAnimationBlock _contentViewAnimationBlock;                       //!< 内容视图的显隐动画
    AMKPopupViewContentAnimationBlock _maskViewAnimationBlock;                          //!< 遮罩视图的显隐动画
    AMKPopupViewAnimationCallbackBlock _willShowBlock;                                  //!< 弹窗视图的将要开始显示动画的回调
    AMKPopupViewAnimationCallbackBlock _didShowBlock;                                   //!< 弹窗视图的完成隐藏动画的回调
    AMKPopupViewAnimationCallbackBlock _willDismissBlock;                               //!< 弹窗视图的将要开始移除动画的回调
    AMKPopupViewAnimationCallbackBlock _didDismissBlock;                                //!< 弹窗视图的完成隐藏动画的回调
}
@property(nonatomic, strong) UIImageView *imageMaskView;                                //!< 遮罩背景
@property(nonatomic, assign) CGFloat animationDuration;                                 //!< 动画时长
@property(nonatomic, assign) AMKPopupViewStatus status;                                 //!< 显示状态
@property(nonatomic, readonly) BOOL isAnimating;                                        //!< 是否正在动画
@property(nonatomic, assign) BOOL dismissWhenTapped;                                    //!< 点击背景移除弹框（默认NO）
@property(nonatomic, assign) BOOL removeFromSuperviewWhenDismissed;                     //!< 移除时并从父视图移除（默认Yes）
@property(nonatomic, strong) UIView *contentView;                                       //!< 弹窗主体自定义视图（须指定size，否则与弹窗视图等大）
@property(nonatomic, assign) UIOffset contentViewOffset;                                //!< 弹窗主体自定义视图居中偏移
@property(nonatomic, strong) UITapGestureRecognizer * tapGestureRecognizer;             //!< 点击手势
@property(nonatomic, copy) AMKPopupViewContentAnimationBlock contentViewAnimationBlock; //!< 内容视图的显隐动画
@property(nonatomic, copy) AMKPopupViewContentAnimationBlock maskViewAnimationBlock;    //!< 遮罩视图的显隐动画
@property(nonatomic, copy) AMKPopupViewAnimationCallbackBlock willShowBlock;            //!< 弹窗视图的将要开始显示动画的回调
@property(nonatomic, copy) AMKPopupViewAnimationCallbackBlock didShowBlock;             //!< 弹窗视图的完成隐藏动画的回调
@property(nonatomic, copy) AMKPopupViewAnimationCallbackBlock willDismissBlock;         //!< 弹窗视图的将要开始移除动画的回调
@property(nonatomic, copy) AMKPopupViewAnimationCallbackBlock didDismissBlock;          //!< 弹窗视图的完成隐藏动画的回调

- (BOOL)shouldHidesWhenTapped:(UITapGestureRecognizer *)sender;                         //!< 点击检测，可由子类重写
@end
