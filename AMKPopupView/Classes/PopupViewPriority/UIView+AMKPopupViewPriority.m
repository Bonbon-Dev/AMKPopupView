//
//  AMKPopupView+AMKPopupViewPriority.m
//  AMKPopupView
//
//  Created by https://github.com/AndyM129/AMKPopupView on 2019/7/18.
//

#import "UIView+AMKPopupViewPriority.h"
#import <objc/runtime.h>
#import "Aspects.h"

@implementation UIView (AMKPopupViewPriority)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        void (^__method_swizzling)(SEL, SEL) = ^(SEL sel, SEL _sel) {
            Method method = class_getInstanceMethod(self, sel);
            Method _method = class_getInstanceMethod(self, _sel);
            if (class_addMethod(self, sel, method_getImplementation(_method), method_getTypeEncoding(_method))) {
                class_replaceMethod(self, _sel, method_getImplementation(method), method_getTypeEncoding(method));
            } else {
                method_exchangeImplementations(method, _method);
            }
        };
        __method_swizzling(@selector(init), @selector(UIView_AMKPopupViewProtocol_init));
    });
}

- (instancetype)UIView_AMKPopupViewProtocol_init {
    id instance = [self UIView_AMKPopupViewProtocol_init];
    
    // 仅 Hook AMKPopupViewProtocol 弹窗实例
    if ([instance conformsToProtocol:@protocol(AMKPopupViewProtocol)]) {
        
        // Hook -showInView:animated: 方法：若在当前弹窗显示的时候，已经有弹窗在显示 则比较二者优先级，若"当前>=之前的"则先自动移除之前的，否则当前这个就不显示了。。
        NSError *error = nil;
        UIView<AMKPopupViewProtocol> *popupView = instance;
        __weak typeof(popupView) weakPopupview = popupView;
        __weak typeof(self) weakself = self;
        
        [popupView aspect_hookSelector:@selector(showInView:animated:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> aspectInfo, UIView *superview, BOOL animated) {
            if (!superview) superview = weakPopupview.defaultSuperview;
            
            NSInvocation *originalInvocation = aspectInfo.originalInvocation;
            UIView<AspectInfo, AMKPopupViewProtocol> *popupView = aspectInfo.instance;
            NSMutableArray<UIView<AMKPopupViewProtocol> *> *showingHighPriorityPopupViews = [NSMutableArray array]; //!< 正在显示的高优弹窗
            NSArray<UIView *> *showingPopupViews = superview.amk_subPopupViews;
            NSEnumerator *showingPopupViewsEnumerator = showingPopupViews.reverseObjectEnumerator;
            UIView<AMKPopupViewProtocol> *showingPopupView = nil;
            while ((showingPopupView = showingPopupViewsEnumerator.nextObject)) {
                if (showingPopupView == weakself) continue;
                
                if (showingPopupView.amk_popupPriority <= popupView.amk_popupPriority) {
                    [showingPopupView dismissAnimated:NO];
                    if (UIView.amk_popupPriorityDebugEnable) NSLog(@"先移除之前的弹窗：%@", showingPopupView);
                } else {
                    [showingHighPriorityPopupViews addObject:showingPopupView];
                }
            }
            
            if (!showingHighPriorityPopupViews.count) {
                [originalInvocation invoke];
                if (UIView.amk_popupPriorityDebugEnable) NSLog(@"没有更高优的弹窗，故继续显示当前弹窗：%@", popupView);
            } else {
                if (UIView.amk_popupPriorityDebugEnable) NSLog(@"此时有更高优的弹窗在显示，所以当前弹窗就不显示了：%@", @{@"popupView":popupView?:@"", @"showingHighPriorityPopupViews":showingHighPriorityPopupViews?:@""});
            }
        } error:&error];
        if (error && UIView.amk_popupPriorityDebugEnable) NSLog(@"AMKPopupView -showInView:animated: 方法 hook 失败：%@", error);
    }
    return instance;
}

static BOOL kAMKPopupPriorityDebugEnable = YES;

+ (BOOL)amk_popupPriorityDebugEnable {
    return kAMKPopupPriorityDebugEnable;
}

+ (void)setAmk_popupPriorityDebugEnable:(BOOL)amk_popupPriorityDebugEnable {
    kAMKPopupPriorityDebugEnable = amk_popupPriorityDebugEnable;
}

- (NSInteger)amk_popupPriority {
    return [objc_getAssociatedObject(self, @selector(amk_popupPriority)) integerValue];
}

- (void)setAmk_popupPriority:(NSInteger)amk_popupPriority {
    objc_setAssociatedObject(self, @selector(amk_popupPriority), @(amk_popupPriority), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray<UIView<AMKPopupViewProtocol> *> *)amk_subPopupViews {
    NSArray<UIView<AMKPopupViewProtocol> *> *subviews = self.subviews;
    NSIndexSet *popupViewsIndexSet = [subviews indexesOfObjectsPassingTest:^BOOL(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        return [view conformsToProtocol:@protocol(AMKPopupViewProtocol)] ? YES : NO;
    }];
    NSArray<UIView<AMKPopupViewProtocol> *> *subPopupViews = [subviews objectsAtIndexes:popupViewsIndexSet];
    return subPopupViews;
}

@end
