//
//  BMChannelManagerTableViewCell.m
//  BMdebug
//
//  Created by MiaoYe on 2019/1/21.
//  Copyright © 2019 Meikeo. All rights reserved.
//

#import "BMChannelManagerTableViewCell.h"

@implementation BMChannelManagerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellTitleColor:(UIColor *)color {
    self.tokenLabel.textColor = color;
    self.appidLabel.textColor = color;
    self.appnameLabel.textColor = color;
    self.appversionLabel.textColor = color;
    self.sdkversionLabel.textColor = color;
    self.keyhashLabel.textColor = color;

}
@end
