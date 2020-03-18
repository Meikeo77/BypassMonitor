//
//  UIColor+NimCaculate.h
//  NIM
//
//  Created by MiaoYe on 2016/11/25.
//  Copyright © 2016年 Kingwelan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (NimCaculate)

/**
 *  使用16进制，生成UIColor颜色对象
 *
 *  @param hex 16进制数值，eg: 0xffffff
 *
 *  @return UIColor对象
 */
+ (UIColor*)NimColorWithHex:(NSUInteger)hex;

/**
 *  使用16进制，生成UIColor颜色对象，带透明度
 *
 *  @param hex   16进制数值，eg: 0xffffff
 *  @param alpha 透明度，eg:0.1，1.0
 *
 *  @return UIColor对象
 */
+ (UIColor*)NimColorWithHex:(NSUInteger)hex alpha:(CGFloat) alpha;

/**
 *  使用16进制串，生成UIColor颜色对象
 *
 *  @param hex 16进制的字符串，接受3种格式，@"#efefef",@"0xefefef","efefef"
 *
 *  @return UIColor对象
 */
+ (UIColor*)NimColorWithHexStr:(NSString *)hex;

/**
 *  使用rgb格式，生成UIColor颜色对象
 *
 *  @param rgb rgb表示字符串，eg:rgb(255, 0, 0)`, `rgba(100, 200, 300, 0.4)`
 *
 *  @return UIColor对象
 */
+ (UIColor*)NimColorWithRGB:(NSString *)rgb;

/**
 *  根据颜色值和尺寸生成图片
 *
 *  @param size 图片尺寸
 *
 *  @return UIImage对象
 */
-(UIImage *)NimGenColoredImageWithSize:(CGSize)size;

/**
 *  红色值
 *
 *  @return CGFloat
 */
- (CGFloat)NimRed;

/**
 *  绿色值
 *
 *  @return CGFloat
 */
- (CGFloat)NimGreen;

/**
 *  蓝色值
 *
 *  @return CGFloat
 */
- (CGFloat)NimBlue;

/**
 *  透明度
 *
 *  @return CGFloat
 */
- (CGFloat)NimAlpha;



@end
