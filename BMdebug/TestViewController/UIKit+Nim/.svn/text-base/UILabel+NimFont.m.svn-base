//
//  UILabel+NimFont.m
//  NIM
//
//  Created by MiaoYe on 2017/7/19.
//  Copyright © 2017年 Kingwelan. All rights reserved.
//

#import "UILabel+NimFont.h"
#import <objc/runtime.h>

@implementation UILabel (NimFont)

+ (void)load{
    //利用running time运行池的方法在程序启动的时候把两个方法替换 适用Xib建立的label
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(imp, myImp);  //交换方法
}

- (id)myInitWithCoder:(NSCoder*)aDecode{
    [self myInitWithCoder:aDecode];
    if (self) {
        //部分不想改变字体的 把tag值设置成LabelFontSize值的跳过
        if (IS_IPHONE_6_PLUS) {
            
            if(self.tag != Label_Font_Tag) {
                CGFloat fontSize = self.font.pointSize;
                self.font = [UIFont systemFontOfSize:fontSize*1.2];
            }
        }
    }
    return self;
}

@end
