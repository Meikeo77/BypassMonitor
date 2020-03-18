//
//  UILabel+NimCaculate.h
//  NIM
//
//  Created by MiaoYe on 2016/11/25.
//  Copyright © 2016年 Kingwelan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (NimCaculate)

/**
 *  通过宽度确定高度
 *
 *  @param text     内容
 *  @param width    宽度
 *  @param font     字体
 */
- (void)NimHeightWithString:(NSString *)text andWidth:(CGFloat)width andFont:(UIFont *)font;


/**
 *  通过高度确定宽度
 *
 *  @param text     内容
 *  @param height   高度
 *  @param font     字体
 */
- (void)NimWidthWithString:(NSString *)text andHeight:(CGFloat)height andFont:(UIFont *)font;


/**
 *  设置label从左上角开始
 *
 *  
 */
- (void) NimTextLeftTopAlign;
@end
