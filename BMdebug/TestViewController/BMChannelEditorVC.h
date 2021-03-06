//
//  BMChannelEditorVC.h
//  BMdebug
//
//  Created by MiaoYe on 2019/1/21.
//  Copyright © 2019 Meikeo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMChannelEditorVC : BMBaseViewController
@property (nonatomic, strong) BMChannelModel *channelModel;
@property (nonatomic) void(^channelEditBlock)(BMChannelModel *model);

@end

NS_ASSUME_NONNULL_END
