//
//  BMCommonConstant.h
//  BypassMonitor
//
//  Created by MiaoYe on 2019/1/7.
//  Copyright © 2019 Meikeo. All rights reserved.
//

#ifndef BMCommonConstant_h
#define BMCommonConstant_h

//如果release状态就不执行NSLog函数
#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
# define NSLog(...) {}
#endif

/** 定义network的错误域 */
#define BMNetworkErrorDomain @"BMNetworkError"

//网络请求
#define BM_URL_ZT                  @"http://10.221.1.14:10000/"
#define BM_NetCode_GetPublicKey    @"get_public_key"       //公钥查询接口
#define BM_NetCode_SysSignIn       @"check_in"             //中台签入
#define BM_NetCode_ChannelReport   @"channel_report"       //信息上报
#define BM_NetCode_PopupReport     @"popup_report"         //弹窗信息上报
#define BM_NetCode_DeviceReport    @"device_info_report"   //设备信息上报
#define BM_NetCode_UrlReport       @"url_report"           //url信息上报

#define BM_RequestURL(URL) [NSString stringWithFormat:@"%@%@",BM_URL_ZT,URL]

//加密签名
#define BM_USER_PWD                @"jdybk_01"
#define BM_INIT_DESKEY             @"8wsqoJ8E"

//数据库
#define BM_SQLIT_NAME              @"bmsqlite3.sqlite"
#define BM_SQ_CREATE_TABLE         @"CREATE TABLE IF NOT EXISTS BYPASS_MONITOR (ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, TYPE INTEGER NOT NULL , CONTENT TEXT NOT NULL, TOKEN TEXT NOT NULL ,APP_ID TEXT NOT NULL,APP_NAME TEXT NOT NULL,APP_VERSION TEXT NOT NULL,SDK_VERSION TEXT NOT NULL,KEY_HASH TEXT NOT NULL);"
#define BM_SQ_DROP_TABLE           @"DROP TABLE BYPASS_MONITOR;"

#define BM_DEBUG_LOG               @"BM_DEBUG_LOG"

#define CHANNEL_LIST  @"channelList"
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height                  //屏幕height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width                   //屏幕width
#define SCREEN_RATIOX ([UIScreen mainScreen].bounds.size.width/375.0)           //以375的屏做的比例
#define IS_IPHONE_5 [[UIScreen mainScreen] bounds].size.height == 568
#define IS_IPHONE_6 [[UIScreen mainScreen] bounds].size.height == 667
#define IS_IPHONE_6_PLUS [[UIScreen mainScreen] bounds].size.height == 736
#define Label_Font_Tag                   333             //不用变化的labeltag
#define Nim_Color_Navigation   0x489fe8        //导航栏蓝色
#define Nim_Color_White        0xffffff        //白色
#define Nim_Color_DefaultLine  0xc4d3d9        //默认线的颜色
#define Nim_Color_TabbarLine   0xdeeff7        //tabbar线的颜色
#define Nim_Color_ListGray     0xe8e8e8        //消息列表分割线灰
#define Nim_Color_DefaultLightText  0xa6b9c0   //默认灰色字体
#define Nim_Color_SearchBarLine     0x66b6fa   //搜索栏线色
#define Nim_Color_RedText           0xff4c4c   //红色字体
#define Nim_Color_GreenText         0x4AD257   //绿色字体
#define Nim_Color_warnView          0xFCD5D8   //警告蓝颜色
#define Nim_Color_GoldenText        0xE5D70B   //金色字体
#define Nim_Color_SystemBack        0xfafafa   //聊天系统消息背景
#define Nim_Color_InfosTitle        0x15495a   //资讯title
#define Nim_Color_DefaultButton     0x2B5BC4          //默认的按钮颜色
#define Nim_Color_DisabledButton    0xA4B7C7          //失效的按钮颜色
#define Nim_Color_HighButton        0x266DA9          //高亮的按钮颜色
#define Nim_Color_WarnBack          0xe7f4ff          //警告栏的背景
#define Nim_Color_DefaultBlue       0x489fe8          //默认的蓝色
#define Nim_Color_BackGround        0xefeff4          //灰的背景色
#define Nim_Color_BlackBackGround   0x111519          //黑色的背景色
#define Nim_Color_Server_TopSelectButton  0x2C60CD    //选中按钮颜色
#define Nim_Color_BlackNavigation 0x1E2126     //黑色导航栏
#define Nim_Color_ServerListLine  0x26292d      //分割线
#define Nim_Color_ServerListContent 0x494D56
#define Nim_Color_ServerListTag   0x8D8E8F


#endif /* BMCommonConstant_h */
