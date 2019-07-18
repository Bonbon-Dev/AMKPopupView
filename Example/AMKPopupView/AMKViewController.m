//
//  AMKViewController.m
//  AMKPopupView
//
//  Created by https://github.com/AndyM129/AMKPopupView on 07/18/2019.
//  Copyright (c) 2019 Andy Meng. All rights reserved.
//

#import "AMKViewController.h"
#import <Masonry/Masonry.h>
#import <YYWebImage/YYWebImage.h>
#import <AMKPopupView/AMKPopupView.h>
#import <AMKPopupView/UIView+AMKPopupViewPriority.h>
#import <AMKPopupView/AMKActionSheet.h>
#import "AMKGuideView.h"

typedef NS_ENUM(NSInteger, AMKTableViewRowType) {
    AMKTableViewRowTypePopupCustomViewTitle = 0,
    AMKTableViewRowTypePopupCustomView,
    AMKTableViewRowTypeCustomPopupViewTitle,
    AMKTableViewRowTypeCustomActionSheetView,
    AMKTableViewRowTypeCustomActionSheetView2,
    AMKTableViewRowTypeCustomActionSheetViewWithPriority,
    AMKTableViewRowTypeOtherCustomPopupViewTitle,
    AMKTableViewRowTypeGuideView,
    AMKTableViewRowTypeCount,
};

@interface AMKViewController () <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong, nullable) UITableView *tableView;
@end

@implementation AMKViewController

#pragma mark - Life Circle

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"AMKPopupView Demo";
    self.hidesBottomBarWhenPushed = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - Properties

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view);
            make.top.mas_equalTo(self.view);
            make.right.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view);
        }];
    }
    return _tableView;
}

#pragma mark - Data & Networking

#pragma mark - Layout Subviews

#pragma mark - Public Methods

#pragma mark - Private Methods

// case AMKTableViewRowTypePopupCustomView: return @"创建通用弹窗，并显示自定义视图";
// 须 #import <AMKPopupView/AMKPopupView.h>
- (void)testPopupCustomView {
    // 自定义视图
    UIImageView *contentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
    contentView.layer.cornerRadius = 5;
    contentView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [contentView yy_setImageWithURL:[NSURL URLWithString:@"https://raw.githubusercontent.com/AndyM129/ImageHosting/master/images/20190718121123.png"] options:YYWebImageOptionSetImageWithFadeAnimation];
    
    // 创建通用弹窗，以弹出指定视图
    AMKPopupView *popupView = [[AMKPopupView alloc] init];
    popupView.contentView = contentView;
    popupView.dismissWhenTapped = YES;
    [popupView showInView:self.view animated:YES];
}

// case AMKTableViewRowTypeCustomActionSheetView: return @"创建自定义菜单";
// 须 #import <AMKPopupView/AMKActionSheet.h>
- (void)testCustomActionSheetView {
    __weak __typeof(self) weakSelf = self;
    AMKActionSheet *actionSheet = [[AMKActionSheet alloc] init];
    actionSheet.contentTitleLabel.text = [NSString stringWithFormat:@"这里是主标题，最多显示一行，后面是测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本"];
    actionSheet.contentMessageLabel.text = @"这里是内容区，最多显示两行，后面是测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本";
    [actionSheet.contentButtons addObject:[AMKActionSheetButton buttonWithTitle:@"警示操作 - 再次确认" style:AMKActionSheetButtonStyleDestructive didClickBlock:^(AMKActionSheet *actionSheet, AMKActionSheetButton *button) {
        NSLog(@"点击了 %@ 的 `%@` 按钮", actionSheet, button.currentTitle);
        [actionSheet setDidDismissBlock:^(AMKPopupView *actionSheet) {
            NSLog(@"%@ 已移除", actionSheet);
            [weakSelf testCustomActionSheetView];
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
}

// case AMKTableViewRowTypeCustomActionSheetView2: return @"创建自定义菜单：示例2";
// 须 #import <AMKPopupView/AMKActionSheet.h>
- (void)testCustomActionSheetView2 {
    AMKActionSheet *actionSheet = [[AMKActionSheet alloc] init];
    actionSheet.contentTitleLabel.text = @"流量提醒";
    actionSheet.contentMessageLabel.text = @"正在使用移动网络，继续播放运营商会收取流量费";
    [actionSheet.contentButtons addObject:[AMKActionSheetButton buttonWithTitle:@"继续播放" style:AMKActionSheetButtonStyleDefault didClickBlock:^(AMKActionSheet *actionSheet, AMKActionSheetButton *button) {
        NSLog(@"点击了 %@ 的 `%@` 按钮：关闭弹窗，开始播放，下次听书再次提示", actionSheet, button.currentTitle);
        [actionSheet dismissAnimated:YES];
    }]];
    [actionSheet.contentButtons addObject:[AMKActionSheetButton buttonWithTitle:@"继续播放，且不再提醒" style:AMKActionSheetButtonStyleDestructive didClickBlock:^(AMKActionSheet *actionSheet, AMKActionSheetButton *button) {
        NSLog(@"点击了 %@ 的 `%@` 按钮：关闭弹窗，开始播放，不在提示", actionSheet, button.currentTitle);
        [actionSheet dismissAnimated:YES];
    }]];
    [actionSheet.contentButtons addObject:[AMKActionSheetButton buttonWithTitle:@"取消" style:AMKActionSheetButtonStyleCancel didClickBlock:^(AMKActionSheet *actionSheet, AMKActionSheetButton *button) {
        NSLog(@"点击了 %@ 的 `%@` 按钮：关闭弹窗，停在当前页面，暂停播放", actionSheet, button.currentTitle);
        [actionSheet dismissAnimated:YES];
    }]];
    [actionSheet showInView:nil animated:YES];
}

// case AMKTableViewRowTypeCustomActionSheetViewWithPriority: return @"创建自定义菜单：弹窗优先级";
// 须 #import <AMKPopupView/UIView+AMKPopupViewPriority.h>
// 须 #import <AMKPopupView/AMKActionSheet.h>
- (void)testCustomActionSheetViewWithPriority {
    UIView.amk_popupPriorityDebugEnable = YES;
    
    __weak __typeof(self) weakSelf = self;
    AMKActionSheet *actionSheet = [[AMKActionSheet alloc] init];
    actionSheet.amk_popupPriority = arc4random() % 500;
    actionSheet.contentTitleLabel.text = [NSString stringWithFormat:@"弹窗优先级测试（该弹窗优先级为%ld）", actionSheet.amk_popupPriority];
    actionSheet.contentMessageLabel.text = [NSString stringWithFormat:@"仅当有更高优的弹窗显示时才会顶替掉该弹窗 而无需先手动关掉之前的弹窗 (点击取消可退出测试)"];
    [actionSheet.contentButtons addObject:[AMKActionSheetButton buttonWithTitle:@"再弹一个窗" style:AMKActionSheetButtonStyleDestructive didClickBlock:^(AMKActionSheet *actionSheet, AMKActionSheetButton *button) {
        [weakSelf testCustomActionSheetViewWithPriority];
    }]];
    [actionSheet.contentButtons addObject:[AMKActionSheetButton buttonWithTitle:@"取消" style:AMKActionSheetButtonStyleCancel didClickBlock:^(AMKActionSheet *actionSheet, AMKActionSheetButton *button) {
        [actionSheet dismissAnimated:YES];
    }]];
    [actionSheet showInView:nil animated:YES];
}

// case AMKTableViewRowTypeGuideView: return @"创建新手引导";
// 须 #import <AMKPopupView/AMKPopupView.h>
- (void)testGuideView {
    AMKGuideView *guideView = [[AMKGuideView alloc] init];
    [guideView setDidDismissBlock:^(AMKPopupView *popupView) {
        NSLog(@"关闭了新手引导页：%@", popupView);
    }];
    [self.view addSubview:guideView];
    [guideView showInView:self.view ifNeeded:YES animated:YES];
}

#pragma mark - Notifications

#pragma mark - KVO

#pragma mark - Delegate

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return AMKTableViewRowTypeCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    cell.contentView.backgroundColor = [self tableView:tableView shouldHighlightRowAtIndexPath:indexPath] ? [UIColor whiteColor] : [UIColor colorWithWhite:.9 alpha:1];
    cell.textLabel.text = [self descriptionWithTableViewRowType:indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    SEL selector = [self selectorWithTableViewRowType:indexPath.row];
    return [self respondsToSelector:selector] ? YES : NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
#   pragma clang diagnostic push
#   pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    SEL selector = [self selectorWithTableViewRowType:indexPath.row];
    if ([self respondsToSelector:selector]) {
        [self performSelector:[self selectorWithTableViewRowType:indexPath.row]];
    }
#   pragma clang diagnostic pop
}

#pragma mark - Override

#pragma mark - Helper Methods

- (NSString *)descriptionWithTableViewRowType:(AMKTableViewRowType)type {
    switch (type) {
        case AMKTableViewRowTypePopupCustomViewTitle: return @"如下为通用弹窗示例";
        case AMKTableViewRowTypePopupCustomView: return @"\t创建通用弹窗，并显示自定义视图";
        case AMKTableViewRowTypeCustomPopupViewTitle: return @"如下为自定义弹窗示例";
        case AMKTableViewRowTypeCustomActionSheetView: return @"\t创建自定义菜单";
        case AMKTableViewRowTypeCustomActionSheetView2: return @"\t创建自定义菜单：示例2";
        case AMKTableViewRowTypeCustomActionSheetViewWithPriority: return @"\t创建自定义菜单：弹窗优先级";
        case AMKTableViewRowTypeOtherCustomPopupViewTitle: return @"其他";
        case AMKTableViewRowTypeGuideView: return @"\t创建新手引导";
        default: return @"";
    }
}

- (SEL)selectorWithTableViewRowType:(AMKTableViewRowType)type {
    switch (type) {
        case AMKTableViewRowTypePopupCustomViewTitle: return nil;
        case AMKTableViewRowTypePopupCustomView: return @selector(testPopupCustomView);
        case AMKTableViewRowTypeCustomPopupViewTitle: return nil;
        case AMKTableViewRowTypeCustomActionSheetView: return @selector(testCustomActionSheetView);
        case AMKTableViewRowTypeCustomActionSheetView2: return @selector(testCustomActionSheetView2);
        case AMKTableViewRowTypeCustomActionSheetViewWithPriority: return @selector(testCustomActionSheetViewWithPriority);
        case AMKTableViewRowTypeOtherCustomPopupViewTitle: return nil;
        case AMKTableViewRowTypeGuideView: return @selector(testGuideView);
        default: return nil;
    }
}

@end
