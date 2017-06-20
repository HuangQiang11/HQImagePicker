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
#import "HQAssetModel.h"
#import "HQMBTool.h"
@interface HQAssetsController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView * collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowlayout;
@property (copy, nonatomic) NSArray * dataArr;
@property (assign, nonatomic) NSUInteger num;
@property (strong, nonatomic) NSMutableDictionary * selectDict;
@property (strong, nonatomic) UIToolbar * bar;
@property (weak, nonatomic) HQImagePickerController * nvc;
@end

@implementation HQAssetsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupLayout];
}

#pragma mark layout
- (void)creatUI{
    [self.view addSubview:self.collectionView];
    if (self.nvc.sourceType == HQMultipleChoicesLibrary) {
        [self.view addSubview:self.bar];
    }
    self.navigationItem.title = self.collectionModel ? self.collectionModel.locationTitle:@"相机胶卷";
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick:)];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setupLayout{
    CGFloat viewW = [UIScreen mainScreen].bounds.size.width;
    CGFloat viewH = [UIScreen mainScreen].bounds.size.height;
    CGFloat itemW = (viewW-26)/4.0;
    self.flowlayout.itemSize = CGSizeMake(itemW, itemW);
    self.flowlayout.minimumLineSpacing = 5;
    self.flowlayout.minimumInteritemSpacing = 5;
    self.flowlayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    if (self.nvc.sourceType == HQMultipleChoicesLibrary){
        self.collectionView.frame = CGRectMake(0, 0, viewW, viewH-49);
        self.bar.frame = CGRectMake(0,viewH-49, viewW, 49);
    }else{
        self.collectionView.frame = self.view.bounds;
    }
}

#pragma mark all click
- (void)leftItemClick:(UIBarButtonItem *)item{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemClick:(UIBarButtonItem *)item{
    [self.nvc didCancelPickerController];
}

- (void)doneItem:(UIBarButtonItem *)item{
    if (self.selectDict.count == self.num) {
        NSMutableArray <UIImage *>* arr = @[].mutableCopy;
        NSMutableArray <UIImage *>* arr1 = @[].mutableCopy;
        dispatch_group_t group = dispatch_group_create();
        [self.selectDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, HQAssetModel *  _Nonnull obj, BOOL * _Nonnull stop) {
            [arr addObject:obj.assetImage];
            dispatch_group_enter(group);
            [HQPhotoHandler getPhotoWithAsset:obj.asset size:PHImageManagerMaximumSize completion:^(UIImage *result) {
                [arr1 addObject:result];
                dispatch_group_leave(group);
            }];
            }];
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            NSDictionary * info = @{
                                    HQImagePickerControllerEditedImage:arr,
                                    HQImagePickerControllerOriginalImage:arr1
                                    };
            [self.nvc didFinishPickingMediaWithInfo:info];
        });
       
    }else{
        [HQMBTool showMessage:@"选中数量未达到要求值！"];
    }
}

#pragma mark loadData
- (void)loadData{
    if (self.nvc.sourceType == HQMultipleChoicesLibrary) {
        self.num = self.nvc.num;
        self.selectDict = @{}.mutableCopy;
    }
    [HQPhotoHandler getPhotoCollectionsWithModel:self.collectionModel completion:^(NSArray * sender) {
        _dataArr = [sender copy];
        [self.collectionView reloadData];
    } fail:^(NSString * errorStr) {
        [self.nvc showErrorMessage];
    }];
}

#pragma mark UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HQAssetsCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:HQAssetsCellID forIndexPath:indexPath];
    cell.assetModel = self.dataArr[indexPath.row];
    cell.selectBtn.hidden = !self.selectDict;
    cell.selectBtn.selected = self.selectDict[[NSString stringWithFormat:@"%zd",indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.num > 0) {
//        nvc.sourceType == HQMultipleChoicesLibrary
        NSString * key = [NSString stringWithFormat:@"%zd",indexPath.row];
        if (self.selectDict[key]) {
            [self.selectDict removeObjectForKey:key];
        }else{
            if (self.selectDict.count == self.num) {
                [HQMBTool showMessage:@"选中数量已超过最大值！"];
            }else{
                 [self.selectDict setObject:self.dataArr[indexPath.row] forKey:key];
            }
        }
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }else{
//        nvc.sourceType == HQPhotoLibrary
        HQEditController * vc = [[HQEditController alloc] init];
        vc.assetModel = self.dataArr[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark setting getting
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

- (UIToolbar *)bar{
    if (!_bar) {
        _bar = [[UIToolbar alloc] init];
        [_bar setBarTintColor:[UIColor blackColor]];
        [_bar setTintColor:[UIColor whiteColor]];
        UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem * doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneItem:)];
        [_bar setItems:@[spaceItem,doneItem]];
    }
    return _bar;
}

- (HQImagePickerController *)nvc{
    return  (HQImagePickerController *)self.navigationController;
}

@end
