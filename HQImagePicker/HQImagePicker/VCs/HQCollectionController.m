//
//  HQCollectionController.m
//  HQImagePicker
//
//  Created by huangqiang on 2017/5/23.
//  Copyright © 2017年 huangqiang. All rights reserved.
//

#import "HQCollectionController.h"
#import "HQPhotoHandler.h"
#import "HQCollectionModel.h"
#import "HQPCollectionCell.h"
#import "HQAssetsController.h"
#import "HQImagePickerController.h"
@interface HQCollectionController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)  UITableView *tableView;
@property (copy, nonatomic) NSArray * dataArr;
@property (weak, nonatomic) HQImagePickerController * nvc;
@end

@implementation HQCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupPhotos];
    [self setupLayout];
}

- (void)creatUI{
    [self.view addSubview:self.tableView];
    self.navigationItem.title = @"照片";
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnItem:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightBtnItem:(UIBarButtonItem *)item{
    [self.nvc didCancelPickerController];
}

- (void)setupLayout{
    self.tableView.frame = self.view.bounds;
}

- (void)setupPhotos{
    [HQPhotoHandler getAssetCollectionsWithCompletion:^(NSArray *sender) {
        _dataArr = [sender copy];
        [self.tableView reloadData];
    } fail:^(NSString * errorStr) {
        [self.nvc showErrorMessage];
    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"abCell";
    HQPCollectionCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HQPCollectionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.dataModel = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HQAssetsController * vc = [[HQAssetsController alloc] init];
    vc.collectionModel = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark setting getting
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (HQImagePickerController *)nvc{
    return  (HQImagePickerController *)self.navigationController;
}

@end
