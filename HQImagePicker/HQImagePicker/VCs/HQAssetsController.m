//
//  AssetsController.m
//  HQImagePicker
//
//  Created by huangqiang on 2017/5/23.
//  Copyright © 2017年 huangqiang. All rights reserved.
//

#import "HQAssetsController.h"
#import "HQPhotoHandler.h"
#import "HQAssetsCell.h"
#import "HQCollectionModel.h"
#import "HQEditController.h"
#import "HQImagePickerController.h"
@interface HQAssetsController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView * collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowlayout;
@property (strong, nonatomic) NSArray * dataArr;
@end

@implementation HQAssetsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupLayout];
    [self loadData];
}

#pragma mark layout
- (void)creatUI{
    [self.view addSubview:self.collectionView];
    self.navigationItem.title = self.collectionModel ? self.collectionModel.locationTitle:@"相机胶卷";
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick:)];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setupLayout{
    CGFloat viewW = [UIScreen mainScreen].bounds.size.width;
    CGFloat itemW = (viewW-26)/4.0;
    self.collectionView.frame = self.view.bounds;
    self.flowlayout.itemSize = CGSizeMake(itemW, itemW);
    self.flowlayout.minimumLineSpacing = 5;
    self.flowlayout.minimumInteritemSpacing = 5;
    self.flowlayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
}

#pragma mark all click
- (void)leftItemClick:(UIBarButtonItem *)item{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemClick:(UIBarButtonItem *)item{
    HQImagePickerController * nvc = (HQImagePickerController *)self.navigationController;
    [nvc didCancelPickerController];
}

#pragma mark loadData
- (void)loadData{
    self.dataArr = [HQPhotoHandler getPhotoCollections:self.collectionModel];
    [self.collectionView reloadData];
}

#pragma mark UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HQAssetsCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:HQAssetsCellID forIndexPath:indexPath];
    cell.assetModel = self.dataArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    HQEditController * vc = [[HQEditController alloc] init];
    vc.assetModel = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark lazy
- (UICollectionViewFlowLayout *)flowlayout{
    if (!_flowlayout) {
        _flowlayout = [[UICollectionViewFlowLayout alloc] init];
    }
    return _flowlayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowlayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[HQAssetsCell class] forCellWithReuseIdentifier:HQAssetsCellID];
    }
    return _collectionView;
}

@end
