//
//  UUIView+NimCaculate.h
//  NIM
//
//  Created by MiaoYe on 2016/11/25.
//  Copyright © 2016年 Kingwelan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NimCaculate)

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGSize  size;
@property (nonatomic) CGPoint origin;

/**
 *  生成UIView对象
 *
 *  @param frame UIView的frame
 *
 *  @return UIView对象
 */
+ (id) NimNewWithFrame:(CGRect)frame;

/**
 *  生成尺寸为0的UIView对象
 *
 *  @return UIView对象
 */
+ (id) NimNewWithZeroFrame;

/**
 *  设置UIView的位置
 *
 *  @param origin UIView的新位置
 */
- (void)NimSetOriginPos:(CGPoint)origin;

/**
 *  根据坐标设置UIView的位置
 *
 *  @param x x坐标
 *  @param y 有坐标
 */
- (void)NimSetOriginPosWithX:(CGFloat) x Y:(CGFloat) y;

/**
 *  view的y坐标值
 *
 *  @return CGFloat
 */
- (CGFloat)NimTop;

/**
 *  view的y+h
 *
 *  @return CGFloat
 */
- (CGFloat)NimBotttom;

/**
 *  view的x坐标值
 *
 *  @return CGFloat
 */
- (CGFloat)NimLeft;

/**
 *  view的x+w值
 *
 *  @return CGFloat
 */
- (CGFloat)NimRight;

/**
 *  根据UIView生成UIImage对象
 *
 *  @return UIImage对象
 */
- (UIImage *)NimGenImageFromView;

/**
 *  为UIView添加圆角
 *
 *  @param radius 圆角弧度
 */
- (void)NimMakeCornerRadiusWithRadius:(CGFloat)radius;

/** 删除所有子view */
- (void)NimRemoveAllSubViews;



typedef  NS_ENUM(NSInteger, NimBorderType){
    NimBORDER_UP_TYPE      =0,     //上边框
    NimBORDER_DOWN_TYPE,           //下边框
    NimBORDER_LEFT_TYPE ,          //左边框
    NimBORDER_RIGHT_TYPE,          //右边框
};

/**
 *  为view添加边框线条
 *
 *  @param NimBorderType 线条类型，上下左右等
 *  @param color      边线颜色
 */
- (void)NimSetborderColorWithType:(NimBorderType)NimBorderType
                      AndColor:(UIColor *)color
                     AndHeight:(CGFloat)height;


//修改view 锚点
- (void)setAnchorPoint:(CGPoint)anchorPoint;

@end
