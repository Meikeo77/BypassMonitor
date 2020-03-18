//
//  BMChannelManagerVC.m
//  BMdebug
//
//  Created by MiaoYe on 2019/1/21.
//  Copyright © 2019 Meikeo. All rights reserved.
//

#import "BMChannelManagerVC.h"
#import "BMChannelManagerTableViewCell.h"
#import "BMChannelEditorVC.h"


@interface BMChannelManagerVC ()<UITableViewDelegate,UITableViewDataSource>;
@property (weak, nonatomic) IBOutlet UITableView *channelTableView;
@property (nonatomic, strong) NSMutableArray *channelArr;
@property (nonatomic, assign) NSInteger editIndex;
@property (nonatomic, assign) NSInteger selectIndex;
@end

@implementation BMChannelManagerVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择或编辑渠道";
    _editIndex = -1;
    _channelTableView.delegate = self;
    _channelTableView.dataSource = self;
    _channelTableView.tableFooterView = [UIView new];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [defaults objectForKey:CHANNEL_LIST];
    _channelArr = [NSMutableArray arrayWithArray:[BMChannelModel mj_objectArrayWithKeyValuesArray:arr]];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction:)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)rightBtnAction:(UIBarButtonItem *)item {
    _editIndex = -1;
    [self performSegueWithIdentifier:@"managerToEdit" sender:nil];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _channelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BMChannelManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BMChannelManagerTableViewCellID"];
    BMChannelModel *model = _channelArr[indexPath.row];
    cell.keyhashLabel.text = [NSString stringWithFormat:@"KEY_HASH：%@",model.KEY_HASH];
    cell.tokenLabel.text = [NSString stringWithFormat:@"TOKEN：%@",model.TOKEN];
    cell.appidLabel.text = [NSString stringWithFormat:@"APP_ID：%@",model.APP_ID];
    cell.appnameLabel.text = [NSString stringWithFormat:@"APP_NAME：%@",model.APP_NAME];
    cell.appversionLabel.text = [NSString stringWithFormat:@"APP_VERSION：%@",model.APP_VERSION];
    cell.sdkversionLabel.text = [NSString stringWithFormat:@"SDK_VERSION：%@",model.SDK_VERSION];
    if ([_channelModel.TOKEN isEqualToString:model.TOKEN]) {
        [cell setCellTitleColor:[UIColor redColor]];
        _selectIndex = indexPath.row;
    }else {
        [cell setCellTitleColor:[UIColor darkGrayColor]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    _channelSelectBlock(_channelArr[indexPath.row]);
    _selectIndex = indexPath.row;
    [self.navigationController popViewControllerAnimated:YES];
}


- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [tableView setEditing:NO animated:YES];
        weakSelf.editIndex = indexPath.row;
        [weakSelf performSegueWithIdentifier:@"managerToEdit" sender:self];

    }];
    
    editAction.backgroundColor = [UIColor NimColorWithHex:Nim_Color_GreenText];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weakSelf.channelArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        NSMutableArray *mutiArr = [[NSMutableArray alloc]init];
        for (BMChannelModel *model in  weakSelf.channelArr) {
            [mutiArr addObject:[model mj_keyValues]];
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:mutiArr forKey:CHANNEL_LIST];
        
        if (indexPath.row == weakSelf.selectIndex) {
            //回调主页，清除数据
            weakSelf.channelSelectBlock([BMChannelModel new]);
        }
    }];
    return @[deleteAction,editAction];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    __weak typeof(self) weakSelf = self;
    if ([segue.identifier isEqualToString:@"managerToEdit"]) {
        BMChannelEditorVC *vc = segue.destinationViewController;
        if (_editIndex >= 0) {
            vc.channelModel = _channelArr[_editIndex];
        }
        vc.channelEditBlock = ^(BMChannelModel * _Nonnull model) {
            if (weakSelf.editIndex >= 0) {
                //更新
                [weakSelf.channelArr replaceObjectAtIndex:weakSelf.editIndex withObject:model];
                //更新TableView
                [weakSelf.channelTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.editIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                if (weakSelf.editIndex == weakSelf.selectIndex) {
                    //更新主页
                    weakSelf.channelSelectBlock(model);
                }
            }else {
                //新增
                [weakSelf.channelArr addObject:model];
                [weakSelf.channelTableView reloadData];
            }
           
            //保存
            NSMutableArray *mutiArr = [[NSMutableArray alloc]init];
            for (BMChannelModel *model in  weakSelf.channelArr) {
                [mutiArr addObject:[model mj_keyValues]];
            }
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:mutiArr forKey:CHANNEL_LIST];
        };
    }
}



@end
