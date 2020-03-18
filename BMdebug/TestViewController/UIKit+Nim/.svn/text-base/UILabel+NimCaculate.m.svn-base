//
//  UILabel+BhtCaculate.m
//  NIM
//
//  Created by MiaoYe on 2016/11/25.
//  Copyright © 2016年 Kingwelan. All rights reserved.
//
#import "UILabel+NimCaculate.h"

@implementation UILabel (NimCaculate)


/**
 *  通过宽度确定高度
 *
 *  @param text     内容
 *  @param width    宽度
 *  @param font     字体
 */
- (void)bhtHeightWithString:(NSString *)text andWidth:(CGFloat)width andFont:(UIFont *)font{
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];

    CGRect frame = self.frame;
    frame.size.width = width;
    frame.size.height = rect.size.height;
    self.frame = frame;
    self.font = font;
    self.numberOfLines = 0;
    self.text = text;
    

}


/**
 *  通过高度确定宽度
 *
 *  @param text     内容
 *  @param height   高度
 *  @param font     字体
 */
- (void)bhtWidthWithString:(NSString *)text andHeight:(CGFloat)height andFont:(UIFont *)font{
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
    
    CGRect frame = self.frame;
    frame.size.width = rect.size.width;
    frame.size.height = height;
    self.frame = frame;
    self.font = font;
    self.text = text;
}


/** 设置label左上角对齐 **/

 - (void) textLeftTopAlign
{
     NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
     paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
     
     NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.f], NSParagraphStyleAttributeName:paragraphStyle.copy};
     
     CGSize labelSize = [self.text boundingRectWithSize:CGSizeMake(207, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
     
     CGRect dateFrame =CGRectMake(2, 140, CGRectGetWidth(self.frame)-5, labelSize.height);
     self.frame = dateFrame;
 }


@end
