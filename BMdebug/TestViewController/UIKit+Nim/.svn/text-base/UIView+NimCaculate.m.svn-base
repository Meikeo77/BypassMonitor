//
//  UIView+NimCaculate.m
//  NIM
//
//  Created by MiaoYe on 2016/11/25.
//  Copyright © 2016年 Kingwelan. All rights reserved.
//

#import "UIView+NimCaculate.h"

@interface UIImage (NimCaculatePrivateAdditions)
- (UIImage *)imageCornerWithRadius:(CGFloat)radius size:(CGSize)size rectCorner:(UIRectCorner)rectCorner;
@end

@implementation UIImage (NimCaculatePrivateAdditions)
- (UIImage *)imageCornerWithRadius:(CGFloat)radius size:(CGSize)size rectCorner:(UIRectCorner)rectCorner
{
    CGRect rect = (CGRect){{0, 0}, size};
    UIGraphicsBeginImageContextWithOptions(rect.size, false, [UIScreen mainScreen].scale);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:rectCorner cornerRadii:CGSizeMake(radius, radius)];
    
    CGContextAddPath(UIGraphicsGetCurrentContext(), path.CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    [self drawInRect:rect];
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output;
}
@end

@implementation UIView (NimCaculate)


+ (id)NimNewWithFrame:(CGRect)frame{
    return [[self alloc] initWithFrame:frame];
}

+ (id)NimNewWithZeroFrame{
    return [self NimNewWithFrame:CGRectZero];
}

- (void)NimSetOriginPos:(CGPoint)origin {
    CGRect newFrame = self.frame;
    newFrame.origin = origin;
    self.frame = newFrame;
}

- (void)NimSetOriginPosWithX:(CGFloat) x Y:(CGFloat) y{
    [self NimSetOriginPos:CGPointMake(x, y)];
}

- (CGFloat) x{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {
    CGRect newFrame = self.frame;
    newFrame.origin.x = x;
    self.frame = newFrame;
}

- (CGFloat) y{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {
    CGRect newFrame = self.frame;
    newFrame.origin.y = y;
    self.frame = newFrame;
}

- (CGFloat) width{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect newFrame = self.frame;
    newFrame.size.width = width;
    self.frame = newFrame;
}

- (CGFloat) height{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect newFrame = self.frame;
    newFrame.size.height = height;
    self.frame = newFrame;
}

- (CGSize)size{
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect newFrame = self.frame;
    newFrame.size = size;
    self.frame = newFrame;
}

- (CGPoint) origin
{
    return self.frame.origin;
}

- (void) setOrigin: (CGPoint) aPoint
{
    CGRect newframe = self.frame;
    newframe.origin = aPoint;
    self.frame = newframe;
}

- (CGFloat) NimTop{
    return self.frame.origin.y;
}

- (CGFloat) NimBotttom{
    return self.frame.origin.y+self.frame.size.height;
}

- (CGFloat) NimLeft{
    return self.frame.origin.x;
}

- (CGFloat) NimRight{
    return self.frame.origin.x + self.frame.size.width;
}


- (CGPoint)trueCenter {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    return UIInterfaceOrientationIsLandscape(orientation) ? CGPointMake(self.center.y, self.center.x) : self.center;
}

- (UIImage *)NimGenImageFromView {
    UIGraphicsBeginImageContext(self.bounds.size);
    if([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    }
    else{
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    image = [UIImage imageWithData:imageData];
    return image;
}

- (void)NimMakeCornerRadiusWithRadius:(CGFloat)radius
{
    [self createCornerRadiusWithRadius:radius rectCorner:UIRectCornerAllCorners];
}

- (void)createCornerRadiusWithRadius:(CGFloat)radius rectCorner:(UIRectCorner)rectCorner
{
    if ([self isKindOfClass:[UIImageView class]]) {
        UIImageView *selfIv = (UIImageView *)self;
        if (selfIv.image) {
            selfIv.image = [selfIv.image imageCornerWithRadius:radius size:selfIv.bounds.size rectCorner:rectCorner];
        }
    } else {
        UIBezierPath *maskPath  = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                        byRoundingCorners:rectCorner
                                                              cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame         = self.bounds;
        maskLayer.path          = maskPath.CGPath;
        self.layer.mask         = maskLayer;
    }
}

- (void) NimRemoveAllSubViews{
    
    for (UIView *v in [self subviews]) {
        [v removeFromSuperview];
    }
}

/*增加一个线条*/
- (void)NimSetborderColorWithType:(NimBorderType)NimBorderType
                      AndColor:(UIColor *)color
                    AndHeight:(CGFloat)height
{
    CALayer *borderLayer = [CALayer layer];
    [self.layer addSublayer:borderLayer];
    borderLayer.backgroundColor = color.CGColor;
    [self setlayerStlye:borderLayer andBhtBorderType:NimBorderType withHeight:height];
}



- (void)setlayerStlye:(CALayer *)borderLayer andBhtBorderType:(NimBorderType)NimBorderType withHeight:(CGFloat)height
{
    switch (NimBorderType) {
        case NimBORDER_UP_TYPE:
            borderLayer.frame = CGRectMake(0, 0, self.width, height);
            break;
        case NimBORDER_DOWN_TYPE:
            borderLayer.frame = CGRectMake(0, self.height-height, self.width, height);
            break;
        case NimBORDER_LEFT_TYPE:
            borderLayer.frame = CGRectMake(0, 0, height, self.height);
            break;
        case NimBORDER_RIGHT_TYPE:
            borderLayer.frame = CGRectMake(self.width-height, 0, height, self.height);
            break;
        default:
            break;
    }
}

//修改view 的锚点
- (void)setAnchorPoint:(CGPoint)anchorPoint
{
    CGPoint oldOrigin = self.frame.origin;
    self.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = self.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    self.center = CGPointMake (self.center.x - transition.x, self.center.y - transition.y);
}




@end

