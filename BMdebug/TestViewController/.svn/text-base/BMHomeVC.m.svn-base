//
//  BMHomeVC.m
//  BMdebug
//
//  Created by MiaoYe on 2019/1/21.
//  Copyright © 2019 Meikeo. All rights reserved.
//

#import "BMHomeVC.h"
#import "BypassMonitor.h"
#import "BMChannelManagerVC.h"
#import "BMSqliteManager.h"
#import "BMNetworkManager.h"

@interface BMHomeVC () <UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *baseScrollView;
@property (weak, nonatomic) IBOutlet UIView *grayBackView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *saveTypeSegment;
@property (weak, nonatomic) IBOutlet UILabel *keyhashLabel;
@property (weak, nonatomic) IBOutlet UILabel *tokenLabel;
@property (weak, nonatomic) IBOutlet UILabel *appidLabel;
@property (weak, nonatomic) IBOutlet UILabel *appnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *appversionLabel;
@property (weak, nonatomic) IBOutlet UILabel *sdkversionLabel;
@property (weak, nonatomic) IBOutlet UITextField *businessTextView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UITextView *popupTextView;
@property (weak, nonatomic) IBOutlet UILabel *popupPlaceholderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sureImage;
@property (weak, nonatomic) IBOutlet UIImageView *refuseImage;
@property (weak, nonatomic) IBOutlet UIImageView *cancelImage;
@property (weak, nonatomic) IBOutlet UITextView *debugTextView;
@property (weak, nonatomic) IBOutlet UITextField *maxNumTextField;

@property (nonatomic, strong) BMChannelModel *channelModel;
@property (nonatomic, strong) UIPickerView *pickView;
@property (atomic, strong) NSString *debugStr;

@end

@implementation BMHomeVC
{
    NSArray *businessArr;
    NSInteger pickIndex;
    NSInteger popupSelectIndex;
    BOOL isSaveAndUp;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"旁路监测测试应用";
    businessArr = @[@"1-开户",@"2-交易",@"3-银证转账",@"4-理财账户开户",@"5-国债逆回购",@"6-广告",@"7-其他"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackAction)];
    [self.grayBackView addGestureRecognizer:tap];
    
    _popupTextView.delegate = self;
    
    isSaveAndUp = YES;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [defaults objectForKey:CHANNEL_LIST];
    if (!arr) {
        BMChannelModel *model1 = [[BMChannelModel alloc]init];
        
        model1.TOKEN = @"1c6a4c5aaed746ea8d";
        model1.APP_NAME = @"爱上搭建";
        model1.KEY_HASH = @"aaaa";
        model1.APP_ID = @"9C5E7B09-7F53-4134-BC82-A8A2C9FC791C";
        model1.APP_VERSION = @"1.0";
        model1.SDK_VERSION = @"1.0";
        
        
        BMChannelModel *model2 = [[BMChannelModel alloc]init];
        model2.TOKEN = @"1c6a4c5aaed746ea8a";
        model2.APP_NAME = @"案件是哪家";
        model2.KEY_HASH = @"bbbb";
        model2.APP_ID = @"ios_taobao";
        model2.APP_VERSION = @"2.1.0";
        model2.SDK_VERSION = @"1.0";
        
        NSArray *channelArr = @[[model1 mj_keyValues],[model2 mj_keyValues]];
        [defaults setObject:channelArr forKey:CHANNEL_LIST];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDebugLog:) name:BM_DEBUG_LOG object:nil];
    
    _debugStr = @"debug log：";
    __weak typeof(self) weakSelf = self;
    
    if (@available(iOS 10.0, *)) {
        [NSTimer scheduledTimerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
            weakSelf.debugTextView.text = weakSelf.debugStr;
        }];
    } else {
        NSTimer *timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(refreshDebugText) userInfo:nil repeats:YES ];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode: NSRunLoopCommonModes];
    }
}

- (void)refreshDebugText {
    _debugTextView.text = _debugStr;
}

- (void)addDebugLog:(NSNotification *)note {
    _debugStr = [NSString stringWithFormat:@"%@\r**%@",_debugStr,note.userInfo[@"log"]];
}

- (IBAction)clearDebugBtnAction:(id)sender {
    _debugTextView.text = @"debug log：";
    _debugStr = @"debug log：";
}

- (IBAction)startReportBtnAction:(id)sender {
    [self addButtonActionDebug:@"开始上报"];
    [[BMNetworkManager sharedManager] BM_checkAndReadSqliteForUp];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
         [BypassMonitor initBM_Interface];
    });
}

- (IBAction)saveTypeChange:(UISegmentedControl *)sender {
    [self.view endEditing:YES];
    isSaveAndUp = sender.selectedSegmentIndex == 0 ? YES : NO;
}
#pragma mark - 随机提交条数
- (IBAction)randomBtnAction:(id)sender {
    [self.view endEditing:YES];
    if (!_channelModel) {
        [self nimShowMsgHud:@"请选择渠道组织机构"];
    }else if (_maxNumTextField.text.length == 0) {
        [self nimShowMsgHud:@"请输入数据条数"];
    }else if ([_maxNumTextField.text integerValue] > 2000) {
        [self nimShowMsgHud:@"当前允许最大条数2000"];
    }else {
        //生成随机数据
       
        for (int i = 0 ; i < _maxNumTextField.text.intValue; i ++ ) {
            int type = arc4random() % 3;
            switch (type) {
                case 0:
                {
                    //业务随机
                    int businessType = arc4random() % 7 + 1;
                    [[BypassMonitor getInstanceWithToken:_channelModel.TOKEN] commitBusinessByType:businessType
                                                                         APP_ID:_channelModel.APP_ID
                                                                       APP_NAME:_channelModel.APP_NAME
                                                                    APP_VERSION:_channelModel.APP_VERSION
                                                                    SDK_VERSION:_channelModel.SDK_VERSION
                                                                       KEY_HASH:_channelModel.KEY_HASH];
                }
                    break;
                case 1:
                {
                    //url随机
                    NSString *urlStr = [NSString stringWithFormat:@"www.%@.com",[self generateTradeNO]];
                    [[BypassMonitor getInstanceWithToken:_channelModel.TOKEN] commitUrl:urlStr
                                                                                 APP_ID:_channelModel.APP_ID
                                                                               APP_NAME:_channelModel.APP_NAME
                                                                            APP_VERSION:_channelModel.APP_VERSION
                                                                            SDK_VERSION:_channelModel.SDK_VERSION
                                                                               KEY_HASH:_channelModel.KEY_HASH];
                }
                    break;
                case 2:
                {
                    int actionType = arc4random() % 3;
                    //弹窗随机
                    NSString *popStr = [NSString stringWithFormat:@"提示信息:%@",[self generateTradeNO]];
                    [[BypassMonitor getInstanceWithToken:_channelModel.TOKEN] commitPopupContent:popStr
                                                                                      actionType:actionType
                                                                                          APP_ID:_channelModel.APP_ID
                                                                                        APP_NAME:_channelModel.APP_NAME
                                                                                APP_VERSION:_channelModel.APP_VERSION
                                                                                SDK_VERSION:_channelModel.SDK_VERSION
                                                                                    KEY_HASH:_channelModel.KEY_HASH];
                }
                    break;
                default:
                    break;
            }
        }
    }
}

- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = arc4random() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

- (void)addButtonActionDebug:(NSString *)string {
    _debugStr = [NSString stringWithFormat:@"%@\r**点击%@",_debugStr,string];
    [self refreshDebugText];
}

#pragma mark - 业务提交
- (IBAction)businessBtnAction:(id)sender {
    [self.view endEditing:YES];
    if (!_channelModel) {
        [self nimShowMsgHud:@"请选择渠道组织机构"];
    }else {
      
        [self addButtonActionDebug:@"业务提交"];
        NSString *type = [_businessTextView.text substringToIndex:1];
        if (isSaveAndUp) {
            //插入并上传
            [[BypassMonitor getInstanceWithToken:_channelModel.TOKEN] commitBusinessByType:[type intValue]
                                                                                    APP_ID:_channelModel.APP_ID
                                                                                  APP_NAME:_channelModel.APP_NAME
                                                                               APP_VERSION:_channelModel.APP_VERSION
                                                                               SDK_VERSION:_channelModel.SDK_VERSION
                                                                                  KEY_HASH:_channelModel.KEY_HASH];
        }else {
            //只插入
            [[BMSqliteManager sharedManager] justInsertDataType:BMReportType_Channel
                                                      token:_channelModel.TOKEN
                                                    content:type
                                                     APP_ID:_channelModel.APP_ID
                                                   APP_NAME:_channelModel.APP_NAME
                                                APP_VERSION:_channelModel.APP_VERSION
                                                SDK_VERSION:_channelModel.SDK_VERSION
                                                   KEY_HASH:_channelModel.KEY_HASH];
        }
    }
}

#pragma mark - 链接提交
- (IBAction)urlBtnAction:(id)sender {
    [self.view endEditing:YES];
    if (!_channelModel) {
        [self nimShowMsgHud:@"请选择渠道组织机构"];
    }else if (_urlTextField.text.length == 0){
         [self nimShowMsgHud:@"请输入链接"];
    }else {
        [self addButtonActionDebug:@"链接提交"];
        if (isSaveAndUp) {
            //插入并上传
            [[BypassMonitor getInstanceWithToken:_channelModel.TOKEN] commitUrl:_urlTextField.text
                                                                         APP_ID:_channelModel.APP_ID
                                                                       APP_NAME:_channelModel.APP_NAME
                                                                    APP_VERSION:_channelModel.APP_VERSION
                                                                    SDK_VERSION:_channelModel.SDK_VERSION
                                                                       KEY_HASH:_channelModel.KEY_HASH];
        }else {
            //只插入
            [[BMSqliteManager sharedManager] justInsertDataType:BMReportType_Url
                                                      token:_channelModel.TOKEN
                                                    content:_urlTextField.text
                                                     APP_ID:_channelModel.APP_ID
                                                   APP_NAME:_channelModel.APP_NAME
                                                APP_VERSION:_channelModel.APP_VERSION
                                                SDK_VERSION:_channelModel.SDK_VERSION
                                                   KEY_HASH:_channelModel.KEY_HASH];
        }
    }
}

#pragma mark - 弹窗提交
- (IBAction)popupBtnAction:(id)sender {
    [self.view endEditing:YES];
    if (!_channelModel) {
        [self nimShowMsgHud:@"请选择渠道组织机构"];
    }else if (_popupTextView.text.length == 0){
        [self nimShowMsgHud:@"请输入弹窗内容"];
    }else {
        [self addButtonActionDebug:@"弹窗提交"];
        if (isSaveAndUp) {
            //插入并上传
            [[BypassMonitor getInstanceWithToken:_channelModel.TOKEN] commitPopupContent:_popupTextView.text
                                                                              actionType:popupSelectIndex
                                                                                  APP_ID:_channelModel.APP_ID
                                                                                APP_NAME:_channelModel.APP_NAME
                                                                             APP_VERSION:_channelModel.APP_VERSION
                                                                             SDK_VERSION:_channelModel.SDK_VERSION
                                                                                KEY_HASH:_channelModel.KEY_HASH];
        }else {
            //只插入
            [[BMSqliteManager sharedManager] justInsertDataType:BMReportType_Popup
                                                      token:_channelModel.TOKEN
                                                    content:[NSString stringWithFormat:@"%ld,%@",popupSelectIndex,_popupTextView.text]
                                                     APP_ID:_channelModel.APP_ID
                                                   APP_NAME:_channelModel.APP_NAME
                                                APP_VERSION:_channelModel.APP_VERSION
                                                SDK_VERSION:_channelModel.SDK_VERSION
                                                   KEY_HASH:_channelModel.KEY_HASH];
        }
    }
}



- (void)tapBackAction {
    __weak typeof(self) weakSelf = self;
    if (_pickView) {
        [UIView animateWithDuration:0.3 animations:^{
            
            [weakSelf.pickView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200)];
            
        } completion:^(BOOL finished) {
            
            [weakSelf.pickView removeFromSuperview];
            weakSelf.pickView = nil;
            weakSelf.grayBackView.hidden = YES;
        }];
    }
}


- (IBAction)businessSelectBtnAction:(id)sender {
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;
    if (!_pickView) {
        //出现pickView
        self.grayBackView.hidden = NO;
        [self.view addSubview:self.pickView];
        self.pickView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200);
        [UIView animateWithDuration:0.3 animations:^{
            
            [weakSelf.pickView setFrame:CGRectMake(0, SCREEN_HEIGHT-200, SCREEN_WIDTH, 200)];
            
        } completion:^(BOOL finished) {
        }];
    }else {
        //移除pickView
        [UIView animateWithDuration:0.3 animations:^{
            
            [weakSelf.pickView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200)];
            
        } completion:^(BOOL finished) {
            [weakSelf.pickView removeFromSuperview];
            weakSelf.pickView = nil;
            weakSelf.grayBackView.hidden = YES;
        }];
    }
}

- (IBAction)sureBtnAction:(id)sender {
    popupSelectIndex = BMActionType_YES;
    _sureImage.image = [UIImage imageNamed:@"Financ_Select"];
    _refuseImage.image = [UIImage imageNamed:@"Financ_unSelect"];
    _cancelImage.image = [UIImage imageNamed:@"Financ_unSelect"];
    
}
- (IBAction)refuseBtnAction:(id)sender {
    popupSelectIndex = BMActionType_NO;
    _sureImage.image = [UIImage imageNamed:@"Financ_unSelect"];
    _refuseImage.image = [UIImage imageNamed:@"Financ_Select"];
    _cancelImage.image = [UIImage imageNamed:@"Financ_unSelect"];
}
- (IBAction)cancelBtnAction:(id)sender {
    popupSelectIndex = BMActionType_Cancel;
    _sureImage.image = [UIImage imageNamed:@"Financ_unSelect"];
    _refuseImage.image = [UIImage imageNamed:@"Financ_unSelect"];
    _cancelImage.image = [UIImage imageNamed:@"Financ_Select"];
}



#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView == _popupTextView) {
        if ([text isEqualToString:@""]) {
            if (range.location == 0) {
                _popupPlaceholderLabel.hidden = NO;
            }else {
                _popupPlaceholderLabel.hidden = YES;
            }
        }else {
            if (range.location == 0 && range.length == 0) {
                _popupPlaceholderLabel.hidden = YES;
            }
        }
    }
    return YES;
}

- (UIPickerView *)pickView {
    if (!_pickView) {
        _pickView = [[UIPickerView alloc]init];
        _pickView.backgroundColor = [UIColor NimColorWithHex:Nim_Color_Navigation];
        _pickView.delegate = self;
        _pickView.dataSource = self;
    }
    return _pickView;
}

#pragma mark - pickviewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return businessArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return businessArr[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    pickIndex = (int)row;
    _businessTextView.text = businessArr[row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textColor = [UIColor whiteColor];
        pickerLabel.numberOfLines = 0;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:17.0]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"homeToManager"]) {
        BMChannelManagerVC *vc = segue.destinationViewController;
        vc.channelModel = _channelModel;
        __weak typeof(self) weakSelf = self;
        vc.channelSelectBlock = ^(BMChannelModel * _Nonnull model) {
            weakSelf.channelModel = model;
            weakSelf.keyhashLabel.text = [NSString stringWithFormat:@"KEY_HASH：%@",model.KEY_HASH];
            weakSelf.tokenLabel.text = [NSString stringWithFormat:@"TOKEN：%@",model.TOKEN];
            weakSelf.appidLabel.text = [NSString stringWithFormat:@"APP_ID：%@",model.APP_ID];
            weakSelf.appnameLabel.text = [NSString stringWithFormat:@"APP_NAME：%@",model.APP_NAME];
            weakSelf.appversionLabel.text = [NSString stringWithFormat:@"APP_VERSION：%@",model.APP_VERSION];
            weakSelf.sdkversionLabel.text = [NSString stringWithFormat:@"SDK_VERSION：%@",model.SDK_VERSION];
        };
    }
}

@end
