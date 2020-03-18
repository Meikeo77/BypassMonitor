//
//  UIColor+NimCaculate.m
//  NIM
//
//  Created by MiaoYe on 2016/11/25.
//  Copyright © 2016年 Kingwelan. All rights reserved.
//

#import "UIColor+NimCaculate.h"

@interface NSString (NimCaculatePrivateAdditions)
- (NSUInteger)hexValue;
@end

@implementation NSString (NimCaculatePrivateAdditions)
- (NSUInteger)hexValue {
    NSUInteger result = 0;
    sscanf([self UTF8String], "%lx", (unsigned long *)&result);
    return result;
}
@end

@implementation UIColor (NimCaculate)

+ (UIColor*)NimColorWithHex:(NSUInteger)hex alpha:(CGFloat) alpha{
    
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hex & 0xFF00) >> 8)) / 255.0
                            blue:((float)((hex & 0xFF))) / 255.0
                           alpha:alpha];
}

+ (UIColor*)NimColorWithHex:(NSUInteger)hex{
    return [self NimColorWithHex:hex alpha:1.0];
}

+ (instancetype)NimColorWithHexStr:(NSString *)hex {
    // Remove `#` and `0x`
    if ([hex hasPrefix:@"#"]) {
        hex = [hex substringFromIndex:1];
    } else if ([hex hasPrefix:@"0x"]) {
        hex = [hex substringFromIndex:2];
    }
    // Invalid if not 3, 6, or 8 characters
    NSUInteger length = [hex length];
    if (length != 3 && length != 6 && length != 8) {
        return nil;
    }
    // Make the string 8 characters long for easier parsing
    if (length == 3) {
        NSString *r = [hex substringWithRange:NSMakeRange(0, 1)];
        NSString *g = [hex substringWithRange:NSMakeRange(1, 1)];
        NSString *b = [hex substringWithRange:NSMakeRange(2, 1)];
        hex = [NSString stringWithFormat:@"%@%@%@%@%@%@ff",
               r, r, g, g, b, b];
    } else if (length == 6) {
        hex = [hex stringByAppendingString:@"ff"];
    }
    CGFloat red = [[hex substringWithRange:NSMakeRange(0, 2)] hexValue] / 255.0f;
    CGFloat green = [[hex substringWithRange:NSMakeRange(2, 2)] hexValue] / 255.0f;
    CGFloat blue = [[hex substringWithRange:NSMakeRange(4, 2)] hexValue] / 255.0f;
    CGFloat alpha = [[hex substringWithRange:NSMakeRange(6, 2)] hexValue] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (instancetype)NimColorWithRGB:(NSString *)rgb {
    rgb = [rgb lowercaseString];
    if (![rgb hasPrefix:@"rgb"]) {
        return nil;
    }
    rgb = [rgb stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"rgba( )"]];
    NSArray *values = [rgb componentsSeparatedByString:@","];
    BOOL hasAlpha = values.count == 4;
    if (values.count == 3 || hasAlpha) {
        CGFloat alpha = hasAlpha ? [values[3] floatValue] : 1.0f;
        return [self colorWithRed:[values[0] floatValue] / 255.0f green:[values[1] floatValue] / 255.0f blue:[values[2] floatValue] / 255.0f alpha:alpha];
    }
    return nil;
}

-(UIImage *)NimGenColoredImageWithSize:(CGSize)size {
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

- (CGFloat)NimRed {
    CGColorRef color = self.CGColor;
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color)) != kCGColorSpaceModelRGB) {
        return -1.0f;
    }
    CGFloat const *components = CGColorGetComponents(color);
    return components[0];
}
- (CGFloat)NimGreen {
    CGColorRef color = self.CGColor;
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color)) != kCGColorSpaceModelRGB) {
        return -1.0f;
    }
    CGFloat const *components = CGColorGetComponents(color);
    return components[1];
}
- (CGFloat)NimBlue {
    CGColorRef color = self.CGColor;
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color)) != kCGColorSpaceModelRGB) {
        return -1.0f;
    }
    CGFloat const *components = CGColorGetComponents(color);
    return components[2];
}

- (CGFloat)NimAlpha {
    return CGColorGetAlpha(self.CGColor);
}



@end
