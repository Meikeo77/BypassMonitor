//
//  UIImage+NimCaculate.m
//  NIM
//
//  Created by MiaoYe on 2016/11/25.
//  Copyright © 2016年 Kingwelan. All rights reserved.
//


#import "UIImage+NimCaculate.h"

@implementation UIImage (NimCaculate)

/**
 @brief 调整用于聊天显示的图片尺寸
 @return 调整后的图片尺寸
 */
+ (CGSize)adjustMessageImageSizeWithOriginSize:(CGSize)imageSize
{
    CGFloat kImageFixedSize = SCREEN_WIDTH/2;
    
    CGSize showSize = CGSizeMake(kImageFixedSize, kImageFixedSize);
    // 长宽比
    if (imageSize.height == 0 || imageSize.width == 0) {
        return showSize;
    }
    // 计算长宽比
    CGFloat ratio = imageSize.width / imageSize.height;
    
    if (ratio <= 1) {  // 如果width小于或者等于height, 保存height固定，width根据height的缩放的比例计算
        showSize.height = kImageFixedSize;
        showSize.width = kImageFixedSize / imageSize.height * imageSize.width;
    } else { // 如果width大于height, 设置width为固定值，height根据width的缩放的比例计算
        showSize.width = kImageFixedSize;
        showSize.height = kImageFixedSize / imageSize.width * imageSize.height;;
    }
    
    int tempW = (int)showSize.width;
    int tempH = (int)showSize.height;
    showSize.width = tempW;
    showSize.height = tempH;
    
    return showSize;
}


- (UIImage *)NimResizeImageWithSize:(CGSize)size{
    
    UIGraphicsBeginImageContextWithOptions(size, NO ,0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0, size.width, size.height);
    [self drawInRect:imageRect];
    UIImage* imgSized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imgSized;
}

- (UIImage *)NimResizeImageWithScaleAndeSize:(CGSize)size{
    
    return [self NimResizeImageWithSize:CGSizeMake(size.width*[UIScreen mainScreen].scale, size.height*[UIScreen mainScreen].scale)];
    
}

+ (UIImage *)NimImageWithColor:(UIColor *)color size:(CGSize)size{
    
//    CGRect rect = CGRectMake(0, 0, size.width, size.height);
//    
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, color.CGColor);
//    CGContextFillRect(context, rect);
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return img;
    
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

+ (UIImage *)NimImageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
