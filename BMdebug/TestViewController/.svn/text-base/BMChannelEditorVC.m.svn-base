//
//  BMChannelEditorVC.m
//  BMdebug
//
//  Created by MiaoYe on 2019/1/21.
//  Copyright © 2019 Meikeo. All rights reserved.
//

#import "BMChannelEditorVC.h"

@interface BMChannelEditorVC ()
@property (weak, nonatomic) IBOutlet UITextField *tokenTextField;
@property (weak, nonatomic) IBOutlet UITextField *appidTextField;
@property (weak, nonatomic) IBOutlet UITextField *appnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *appversionTextField;
@property (weak, nonatomic) IBOutlet UITextField *sdkversionTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UITextField *keyhashTextField;

@end

@implementation BMChannelEditorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑渠道";
    [_sureButton setBackgroundColor:[UIColor NimColorWithHex:Nim_Color_DefaultButton]];
    _sureButton.layer.masksToBounds = YES;
    _sureButton.layer.cornerRadius = 8.0f;
    if (_channelModel) {
        self.tokenTextField.text = _channelModel.TOKEN;
        self.appidTextField.text = _channelModel.APP_ID;
        self.appnameTextField.text = _channelModel.APP_NAME;
        self.appversionTextField.text = _channelModel.APP_VERSION;
        self.sdkversionTextField.text = _channelModel.SDK_VERSION;
        self.keyhashTextField.text = _channelModel.KEY_HASH;
    }else {
        _channelModel = [[BMChannelModel alloc]init];
    }
}

- (IBAction)sureBtnAction:(id)sender {
    if (_tokenTextField.text.length == 0 || _appidTextField.text.length == 0 || _appnameTextField.text.length == 0 || _appversionTextField.text.length == 0 || _sdkversionTextField.text.length == 0 || _keyhashTextField.text.length == 0) {
        [self nimShowMsgHud:@"请输入完整渠道信息"];
    }else {
        _channelModel.TOKEN = _tokenTextField.text;
        _channelModel.APP_ID = _appidTextField.text;
        _channelModel.APP_NAME = _appnameTextField.text;
        _channelModel.APP_VERSION = _appversionTextField.text;
        _channelModel.SDK_VERSION = _sdkversionTextField.text;
        _channelModel.KEY_HASH = _keyhashTextField.text;

        _channelEditBlock(_channelModel);
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
