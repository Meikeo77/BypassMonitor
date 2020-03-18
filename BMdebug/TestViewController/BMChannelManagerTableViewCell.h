//
//  BMChannelManagerTableViewCell.h
//  BMdebug
//
//  Created by MiaoYe on 2019/1/21.
//  Copyright © 2019 Meikeo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BMChannelManagerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tokenLabel;
@property (weak, nonatomic) IBOutlet UILabel *appidLabel;
@property (weak, nonatomic) IBOutlet UILabel *appnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *appversionLabel;
@property (weak, nonatomic) IBOutlet UILabel *sdkversionLabel;
@property (weak, nonatomic) IBOutlet UILabel *keyhashLabel;

- (void)setCellTitleColor:(UIColor *)color;
@end

