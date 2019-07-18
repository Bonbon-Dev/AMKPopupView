//
//  AMKActionSheet.m
//  AMKPopupView
//
//  Created by https://github.com/AndyM129/AMKPopupView on 2019/7/18.
//

#import "AMKActionSheet.h"
#import <Masonry/Masonry.h>

@implementation AMKActionSheetButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIColor *highlightedBackgroundColor = [UIColor colorWithWhite:0 alpha:0.02];
        UIImage *highlightedBackgroundImage = [AMKActionSheet imageWithColor:highlightedBackgroundColor size:CGSizeMake(5, 5) cornerRadius:0];
        
        self.index = NSNotFound;
        self.style = AMKActionSheetButtonStyleDefault;
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
        [self addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

+ (instancetype)buttonWithTitle:(NSString *)title style:(AMKActionSheetButtonStyle)style didClickBlock:(AMKActionSheetButtonDidClickBlock)didClickBlock {
    AMKActionSheetButton *button = [[self alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    button.style = style;
    button.didClickBlock = didClickBlock;
    return button;
}

- (void)setStyle:(AMKActionSheetButtonStyle)style {
    _style = style;
    [self setTitleColor:[self.class titleColorWithStyle:style] forState:UIControlStateNormal];
}

- (void)didClick:(id)sender {
    id actionSheet = self;
    do {
        actionSheet = [actionSheet nextResponder];
        if ([actionSheet isKindOfClass:AMKActionSheet.class]) {
            break;
        }
    } while (actionSheet != nil);
    self.didClickBlock == nil ?: self.didClickBlock(actionSheet, self);
}

+ (UIColor *_Nullable)titleColorWithStyle:(AMKActionSheetButtonStyle)style {
    if (style == AMKActionSheetButtonStyleCancel) return [UIColor colorWithRed:102/255.0 green:108/255.0 blue:125/255.0 alpha:1/1.0];
    if (style == AMKActionSheetButtonStyleDestructive) return [UIColor colorWithRed:255/255.0 green:69/255.0 blue:69/255.0 alpha:1/1.0];
    return [UIColor colorWithRed:4/255.0 green:125/255.0 blue:254/255.0 alpha:1/1.0];
}

@end

@implementation AMKActionSheet

+ (void)demo {
    static NSTimeInterval delay = 1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        delay = 0;
        AMKActionSheet *actionSheet = [[AMKActionSheet alloc] init];
//        actionSheet.popupPriority = arc4random() % 500;
        //actionSheet.contentImageView.frame = CGRectMake(0, 0, 0, 230);
        actionSheet.contentTitleLabel.text = [NSString stringWithFormat:@"这里是主标题，最多显示一行，后面是测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本"];
        actionSheet.contentMessageLabel.text = @"这里是内容区，最多显示两行，后面是测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本";
        [actionSheet.contentButtons addObject:[AMKActionSheetButton buttonWithTitle:@"警示操作 - 再次确认" style:AMKActionSheetButtonStyleDestructive didClickBlock:^(AMKActionSheet *actionSheet, AMKActionSheetButton *button) {
            NSLog(@"点击了 %@ 的 `%@` 按钮", actionSheet, button.currentTitle);
            [actionSheet setDidDismissBlock:^(AMKPopupView *actionSheet) {
                NSLog(@"%@ 已移除", actionSheet);
                [self demo];
            }];
            [actionSheet dismissAnimated:YES];
        }]];
        [actionSheet.contentButtons addObject:[AMKActionSheetButton buttonWithTitle:@"普通操作" style:AMKActionSheetButtonStyleDefault didClickBlock:^(AMKActionSheet *actionSheet, AMKActionSheetButton *button) {
            NSLog(@"点击了 %@ 的 `%@` 按钮", actionSheet, button.currentTitle);
        }]];
        [actionSheet.contentButtons addObject:[AMKActionSheetButton buttonWithTitle:@"取消" style:AMKActionSheetButtonStyleCancel didClickBlock:^(AMKActionSheet *actionSheet, AMKActionSheetButton *button) {
            NSLog(@"点击了 %@ 的 `%@` 按钮", actionSheet, button.currentTitle);
            [actionSheet dismissAnimated:YES];
        }]];
        [actionSheet showInView:nil animated:YES];
    });
}

#pragma mark - Init Methods

- (void)dealloc {
    [_contentMessageLabel removeObserver:self forKeyPath:@"text"];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        self.AMK_viewLevel = AMKViewLevelMiddleHigher;
//        self.popupPriority = AMKPopupViewMiddleHigherPriority;
        self.dismissWhenTapped = YES;
        self.animationDuration = 0.3;
        self.maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        self.contentTitleEdgeInsets = UIEdgeInsetsMake(15, 30, 5, 30);
        self.contentMessageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 30);
    }
    return self;
}

- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message buttons:(NSArray<AMKActionSheetButton *> *)buttons {
    if (self = [self init]) {
        self.contentTitleLabel.text = title;
        self.contentMessageLabel.text = message;
        self.contentButtons = [NSMutableArray arrayWithArray:buttons];
    }
    return self;
};

+ (instancetype)actionSheetWithTitle:(nullable NSString *)title message:(nullable NSString *)message buttons:(NSArray<AMKActionSheetButton *> *)buttons {
    return [[AMKActionSheet alloc] initWithTitle:title message:message buttons:buttons];
};

#pragma mark - Properties

- (AMKPopupViewContentAnimationBlock)contentViewAnimationBlock {
    if (!_contentViewAnimationBlock) {
        _contentViewAnimationBlock = ^(UIView *contentView, BOOL showAnimation, NSTimeInterval duration) {
            if (showAnimation) {
                [contentView.superview layoutSubviews];
                contentView.transform = CGAffineTransformMakeTranslation(0, contentView.frame.size.height);
                [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    contentView.transform = CGAffineTransformMakeTranslation(0, 0);
                } completion:nil];
            } else {
                [UIView animateWithDuration:duration animations:^{
                    contentView.transform = CGAffineTransformMakeTranslation(0, contentView.frame.size.height);
                }];
            }
        };
    }
    return _contentViewAnimationBlock;
}

- (UIImageView *)contentView {
    if (!_contentView) {
        _contentView = [[UIImageView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.userInteractionEnabled = YES;
        [self addSubview:_contentView];
    }
    return (UIImageView *)_contentView;
}

- (void)setContentView:(UIImageView *)contentView {
    NSAssert(NO, @"自定义页面，请勿赋值");
}

- (UIImageView *)contentImageView {
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] init];
        _contentImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_contentImageView];
    }
    return _contentImageView;
}

- (UILabel *)contentTitleLabel {
    if (!_contentTitleLabel) {
        _contentTitleLabel = [[UILabel alloc] init];
        _contentTitleLabel.numberOfLines = 1;
        _contentTitleLabel.font = [UIFont boldSystemFontOfSize:16];
        _contentTitleLabel.textColor = [UIColor colorWithRed:51/255.0 green:59/255.0 blue:81/255.0 alpha:1/1.0];
        _contentTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentImageView addSubview:_contentTitleLabel];
    }
    return _contentTitleLabel;
}

- (UILabel *)contentMessageLabel {
    if (!_contentMessageLabel) {
        _contentMessageLabel = [[UILabel alloc] init];
        _contentMessageLabel.numberOfLines = 2;
        _contentMessageLabel.font = [UIFont systemFontOfSize:13];
        _contentMessageLabel.textColor = [UIColor colorWithRed:102/255.0 green:108/255.0 blue:125/255.0 alpha:1/1.0];
        _contentMessageLabel.textAlignment = NSTextAlignmentCenter;
        [_contentMessageLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        [self.contentImageView addSubview:_contentMessageLabel];
    }
    return _contentMessageLabel;
}

- (UIImageView *)contentImageBottomSeparatorView {
    if (!_contentImageBottomSeparatorView) {
        _contentImageBottomSeparatorView = [[UIImageView alloc] init];
        _contentImageBottomSeparatorView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1/1.0];
        [self.contentImageView addSubview:_contentImageBottomSeparatorView];
    }
    return _contentImageBottomSeparatorView;
}

- (UIImageView *)contentButtonsView {
    if (!_contentButtonsView) {
        _contentButtonsView = [[UIImageView alloc] init];
        _contentButtonsView.userInteractionEnabled = YES;
        _contentButtonsView.backgroundColor = self.contentView.backgroundColor;
        [self.contentView addSubview:_contentButtonsView];
    }
    return _contentButtonsView;
}

- (NSMutableArray<AMKActionSheetButton *> *)contentButtons {
    if (!_contentButtons) {
        _contentButtons = [NSMutableArray array];
    }
    return _contentButtons;
}

#pragma mark - Layout Subviews

- (void)layoutContentView {
    CGFloat bottomInsets = 100; // 为了防止弹性动画时，底部走光，所以底部的视图留出一些在屏幕外
    
    // 内容视图
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.width.mas_equalTo(self.mas_width);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    // 上半部分
    [self.contentImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView);
        if (self.contentImageView.frame.size.height) {
            make.height.mas_equalTo(self.contentImageView.frame.size.height).priorityLow();
        }
        make.height.mas_greaterThanOrEqualTo(90);
        if (!self.contentButtons.count) {
            make.bottom.mas_equalTo(self.contentView);
        }
    }];
    
    // 标题
    [self.contentTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.contentMessageLabel.text.length) {
            make.top.mas_equalTo(self.contentTitleEdgeInsets.top);
        } else {
            make.centerY.mas_equalTo(self.contentImageView);
        }
        make.left.mas_equalTo(self.contentTitleEdgeInsets.left);
        make.right.mas_equalTo(-self.contentTitleEdgeInsets.right);
    }];
    
    // 信息
    [self.contentMessageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.contentTitleLabel.text.length) {
            make.top.mas_equalTo(self.contentTitleLabel.mas_bottom).offset(self.contentTitleEdgeInsets.bottom + self.contentMessageEdgeInsets.top);
        } else {
            make.centerY.mas_equalTo(self.contentImageView);
        }
        make.left.mas_equalTo(self.contentTitleEdgeInsets.left);
        make.right.mas_equalTo(-self.contentTitleEdgeInsets.right);
    }];
    
    // 上半部分底部分割线
    [self.contentImageBottomSeparatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.width.bottom.mas_equalTo(self.contentImageView);
        if (self.contentButtons.count) {
            make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
        } else {
            make.height.mas_equalTo(0);
        }
    }];
    
    // 若有按钮，则绘制按钮视图
    if (self.contentButtons.count) {
        [self.contentButtonsView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentImageView.mas_bottom);
            make.left.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView);
            //make.height.mas_equalTo(200);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(bottomInsets);
        }];
        
        // 循环添加按钮
        for (NSInteger i=0; i<self.contentButtons.count; i++) {
            // 取出当前按钮
            AMKActionSheetButton *button = self.contentButtons[i];
            if (button.superview && button.superview!=self.contentButtonsView) {
                [button removeFromSuperview];
            }
            if (!button.superview) {
                [self.contentButtonsView addSubview:button];
            }
            button.index = i;
            
            // 布局按钮
            [button mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                if (i == 0) {
                    make.top.mas_equalTo(0);
                } else {
                    make.top.mas_equalTo(self.contentButtons[i-1].mas_bottom);
                }
                make.height.mas_equalTo(65);
                if (i == self.contentButtons.count-1) {
                    make.bottom.mas_equalTo(-bottomInsets);
                    
                    //make.bottom.mas_equalTo(self.contentButtonsView.mas_bottom);
                }
            }];
            
            // 取出当前分割线
            UIImageView *separatorView = i<self.contentButtonBottomSeparatorViews.count ? self.contentButtonBottomSeparatorViews[i] : nil;
            if (!separatorView) {
                separatorView = [[UIImageView alloc] init];
                [self.contentButtonBottomSeparatorViews addObject:separatorView];
            }
            if (separatorView.superview && separatorView.superview!=self.contentButtonsView) {
                [button removeFromSuperview];
            }
            if (!separatorView.superview) {
                [self.contentButtonsView addSubview:separatorView];
            }
            separatorView.backgroundColor =  [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1/1.0];
            
            // 布局分割线
            [separatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(button);
                if (i < self.contentButtons.count-1) {
                    make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
                } else {
                    make.height.mas_equalTo(0);
                }
            }];
        }
    }
}

#pragma mark - Public Methods

//- (void)showInView:(UIView *)superview animated:(BOOL)animated {
//    [super showInView:superview animated:animated];
//    AMKActionSheet.currentActionSheet = self;
//}
//
//- (void)dismissAnimated:(BOOL)animated {
//    [self dismissAnimated:animated];
//    if (AMKActionSheet.currentActionSheet == self) {
//        AMKActionSheet.currentActionSheet = nil;
//    }
//}

#pragma mark - Private Methods

#pragma mark - Notifications

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isKindOfClass:UILabel.class] && [keyPath isEqualToString:@"text"]) {
        UILabel *lable = object;
        id newValue = [change objectForKey:NSKeyValueChangeNewKey];
        if (newValue) {
            lable.attributedText = [self.class attributedStringWithText:newValue];
        }
    }
}

#pragma mark - Delegate

#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutContentView];
}

#pragma mark - Helper Methods

+ (NSMutableAttributedString *)attributedStringWithText:(NSString *)text {
    return [self.class attributedStringWithText:text alignment:NSTextAlignmentCenter lineSpacing:5 paragraphSpacing:0];
}

+ (NSMutableAttributedString *)attributedStringWithText:(NSString *)text alignment:(NSTextAlignment)alignment lineSpacing:(CGFloat)lineSpacing paragraphSpacing:(CGFloat)paragraphSpacing {
    if (!text || !text.length) return nil;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = lineSpacing;
    paragraphStyle.paragraphSpacing = paragraphSpacing;
    paragraphStyle.alignment = alignment;
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    return attributedString;
}

+ (UIImage *_Nullable)imageWithColor:(UIColor *_Nullable)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:cornerRadius];
    [roundedRect fillWithBlendMode:kCGBlendModeNormal alpha:1];
    CGContextStrokePath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
