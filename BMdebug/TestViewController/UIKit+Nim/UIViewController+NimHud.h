//
//  UIViewController+NimHud.h
//  NIM
//
//  Created by MiaoYe on 2017/1/19.
//  Copyright © 2017年 Kingwelan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIViewController (NimHud)
@property (nonatomic, strong) MBProgressHUD *hud;

/**
 等待图标

 @param str 提示信息
 */
- (void)nimLoading:(NSString *)str;

/**
 隐藏等待框
 */
- (void)nimHideLoading;

- (void)nimLoading:(NSString *)hint initWithView:(UIView *)view;
- (void)nimHideLoadinginitWithView:(UIView *)view;

- (void) nimShowMsgHud:(NSString*)hint;
- (void) nimShowMsgHud:(NSString*)hint yoffSet:(CGFloat)offset;

- (void) nimwidowShowMsgHud:(NSString *)hint;

@end
