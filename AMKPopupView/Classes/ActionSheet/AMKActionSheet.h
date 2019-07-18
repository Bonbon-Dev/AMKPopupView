//
//  AMKActionSheet.h
//  AMKPopupView
//
//  Created by https://github.com/AndyM129/AMKPopupView on 2019/7/18.
//

#import <AMKPopupView/AMKPopupView.h>

/// 按钮类型
typedef NS_ENUM(NSInteger, AMKActionSheetButtonStyle) {
    AMKActionSheetButtonStyleDefault = 0,       //!< 默认（蓝色）
    AMKActionSheetButtonStyleCancel,            //!< 取消（灰色）
    AMKActionSheetButtonStyleDestructive        //!< 警示（红色）
};

@class AMKActionSheet;
@class AMKActionSheetButton;
typedef void(^AMKActionSheetButtonDidClickBlock)(AMKActionSheet *_Nullable _actionSheet, AMKActionSheetButton *_Nullable _button);
typedef void(^AMKActionSheetButtonInitBlock)(AMKActionSheet *_Nullable _actionSheet, AMKActionSheetButton *_Nullable _button);

#pragma mark -

/// 底部划出菜单的按钮
@interface AMKActionSheetButton : UIButton
@property(nonatomic, assign) AMKActionSheetButtonStyle style;
@property(nonatomic, assign) NSInteger index;
@property(nonatomic, copy, nullable) AMKActionSheetButtonDidClickBlock didClickBlock;
+ (instancetype _Nullable)buttonWithTitle:(NSString *_Nullable)title style:(AMKActionSheetButtonStyle)style didClickBlock:(AMKActionSheetButtonDidClickBlock _Nullable)didClickBlock;
+ (UIColor *_Nullable)titleColorWithStyle:(AMKActionSheetButtonStyle)style;
@end

#pragma mark -

/// 底部划出菜单
@interface AMKActionSheet : AMKPopupView
@property(nonatomic, strong, nullable) UIImageView *contentView;                                            //!< 弹框主体
@property(nonatomic, strong, nullable) UIImageView *contentImageView;                                       //!< 弹框主体上部分显示的图片视图(可通过修改frame.size.height来指定高度)
@property(nonatomic, strong, nullable) UILabel *contentTitleLabel;                                          //!< 弹框主体上部分显示的标题
@property(nonatomic, assign) UIEdgeInsets contentTitleEdgeInsets;                                           //!< 弹框主体上部分显示的标题边缘缩进
@property(nonatomic, strong, nullable) UILabel *contentMessageLabel;                                        //!< 弹框主体上部分显示的信息
@property(nonatomic, assign) UIEdgeInsets contentMessageEdgeInsets;                                         //!< 弹框主体上部分显示的信息边缘缩进
@property(nonatomic, strong, nullable) UIImageView *contentImageBottomSeparatorView;                        //!< 弹框主体上部分显示的图片底部分割线
@property(nonatomic, strong, nullable) UIImageView *contentButtonsView;                                     //!< 弹框主体下部分按钮视图
@property(nonatomic, assign) UIEdgeInsets contentButtonsViewEdgeInsets;                                     //!< 弹框主体下部分按钮视图边缘缩进
@property(nonatomic, strong, nullable) NSMutableArray<AMKActionSheetButton *> *contentButtons;              //!< 弹框主体下部分按钮视图
@property(nonatomic, strong, nullable) NSMutableArray<UIImageView *> *contentButtonBottomSeparatorViews;    //!< 弹框主体下部分按钮底边线

- (instancetype _Nullable)initWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message buttons:(NSArray<UIButton *> *_Nullable)buttons;
+ (instancetype _Nullable)actionSheetWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message buttons:(NSArray<UIButton *> *_Nullable)buttons;
@end

#pragma mark -

/// 辅助方法
@interface AMKActionSheet (AMKActionSheetHelperMethods)
+ (NSMutableAttributedString *_Nullable)attributedStringWithText:(NSString *_Nullable)text;
+ (NSMutableAttributedString *_Nullable)attributedStringWithText:(NSString *_Nullable)text alignment:(NSTextAlignment)alignment lineSpacing:(CGFloat)lineSpacing paragraphSpacing:(CGFloat)paragraphSpacing;
+ (UIImage *_Nullable)imageWithColor:(UIColor *_Nullable)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius;
@end
