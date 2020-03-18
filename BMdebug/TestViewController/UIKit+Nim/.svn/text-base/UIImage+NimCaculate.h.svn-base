//
//  UIImage+NimCaculate.h
//  NIM
//
//  Created by MiaoYe on 2016/11/25.
//  Copyright © 2016年 Kingwelan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (NimCaculate)

/**
 *  从当前图片按新的尺寸生成新的图片
 *
 *  @param size 新图片的尺寸
 *
 *  @return UIImage对象
 */
- (UIImage *)NimResizeImageWithSize:(CGSize)size;

/**
 *  从当前图片按新的尺寸生成新的图片, size x scale值
 *
 *  @param size 新图片的尺寸
 *
 *  @return UIImage对象
 */
- (UIImage *)NimResizeImageWithScaleAndeSize:(CGSize)size;

/**
 *  根据背景色和尺寸生成图片
 *
 *  @param color 图片的背景色
 *  @param size  图片的尺寸
 *
 *  @return UIImage对象
 */
+ (UIImage *)NimImageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *  根据背景色生成图片
 *
 *  @param color 图片的背景色
 *
 *  @return UIImage对象
 */
+ (UIImage *)NimImageWithColor:(UIColor *)color;

/**
 @brief 调整用于聊天显示的图片尺寸
 @return 调整后的图片尺寸
 */
+ (CGSize)adjustMessageImageSizeWithOriginSize:(CGSize)imageSize;

@end
