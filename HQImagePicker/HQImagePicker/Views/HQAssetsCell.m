//
//  HQAssetsCell.m
//  HQImagePicker
//
//  Created by huangqiang on 2017/5/23.
//  Copyright © 2017年 huangqiang. All rights reserved.
//

#import "HQAssetsCell.h"
#import "HQAssetModel.h"
#import "HQPhotoHandler.h"

const NSString * const HQAssetsCellID = @"HQAssetsCellID";
@implementation HQAssetsCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = ({
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.bounds];
            imageView;
        });
        
        _selectBtn = ({
            UIButton * selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)-25, 5, 20, 20)];
            [selectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
            [selectBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
            selectBtn.userInteractionEnabled = NO;
            selectBtn;
        });
        
        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:_selectBtn];
    }
    return self;
}

- (void)setAssetModel:(HQAssetModel *)assetModel{
    _assetModel = assetModel;
    CGFloat scale = [UIScreen mainScreen].scale;
    if (assetModel.assetImage) {
        self.imageView.image = assetModel.assetImage;
    }else{
        [HQPhotoHandler getPhotoWithAsset:assetModel.asset size:CGSizeMake(80*scale, 80*scale) completion:^(UIImage *result) {
            self.imageView.image = result;
            //缓存数据
            assetModel.assetImage = result;
        }];
    }
}
@end
