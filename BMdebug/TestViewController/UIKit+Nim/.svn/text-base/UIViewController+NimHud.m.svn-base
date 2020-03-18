//
//  UIViewController+NimHud.m
//  NIM
//
//  Created by MiaoYe on 2017/1/19.
//  Copyright © 2017年 Kingwelan. All rights reserved.
//

#import "UIViewController+NimHud.h"
#import <objc/runtime.h>

char* const ASSOCIATION_MUTABLE_HUD_INFO = "ASSOCIATION_MUTABLE_HUD_INFO";

@implementation UIViewController (NimHud)

- (void)setHud:(MBProgressHUD *)hud {
    objc_setAssociatedObject(self,ASSOCIATION_MUTABLE_HUD_INFO,hud,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)setWarnHud:(MBProgressHUD *)warnHud {
     objc_setAssociatedObject(self,ASSOCIATION_MUTABLE_HUD_INFO,warnHud,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MBProgressHUD *)hud {
    MBProgressHUD* hud = objc_getAssociatedObject(self,ASSOCIATION_MUTABLE_HUD_INFO);
    return hud;
}

- (MBProgressHUD *)warnHud {
    MBProgressHUD* hud = objc_getAssociatedObject(self,ASSOCIATION_MUTABLE_HUD_INFO);
    return hud;
}

- (void) nimLoading:(NSString *)str {
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.hidden = NO;
    self.hud.labelText = str;
    self.hud.mode = MBProgressHUDModeIndeterminate;
    [self.hud show:YES];
    [self.view bringSubviewToFront:self.hud];

}

- (void)nimLoading:(NSString *)hint initWithView:(UIView *)view {
    
    MBProgressHUD *hud = (MBProgressHUD *)[view viewWithTag:10101];
    if(hud == nil){
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.tag = 10101;
        [view addSubview:hud];
    }
    hud.hidden = NO;
    hud.labelText = hint;
    hud.mode = MBProgressHUDModeIndeterminate;
}

- (void)nimHideLoadinginitWithView:(UIView *)view {
    
    MBProgressHUD *hud = (MBProgressHUD *)[view viewWithTag:10101];
    hud.hidden = YES;
    
}


/**
 *  隐藏等待框
 */
- (void) nimHideLoading{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.hud removeFromSuperview];
    self.hud = nil;
}

/**
 *  显示完成信息
 *
 *  @param hint 提示信息
 */
- (void) nimShowMsgHud:(NSString*)hint{

    dispatch_async(dispatch_get_main_queue(), ^{
        [self nimHideLoading];
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = hint;
        self.hud.yOffset = -100;
        [self.hud hide:YES afterDelay:1.5];
    });
}


- (void) nimShowMsgHud:(NSString*)hint yoffSet:(CGFloat)offset{
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.labelText = hint;
    self.hud.yOffset = offset;
    [self.hud hide:YES afterDelay:1.5];
}

- (void) nimwidowShowMsgHud:(NSString *)hint {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = hint;
        self.hud.yOffset = -100;
        [self performSelector:@selector(hideLoadHUD) withObject:nil afterDelay:1.5];
    });
}

- (void)hideLoadHUD{
    
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
}


@end
