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
        [self.contentView addSubview:_imageView];
    }
    return self;
}

- (void)setAssetModel:(HQAssetModel *)assetModel{
    _assetModel = assetModel;
    CGFloat scale = [UIScreen mainScreen].scale;
    [HQPhotoHandler getPhotoWithAsset:assetModel.asset size:CGSizeMake(80*scale, 80*scale) completion:^(UIImage *result) {
        self.imageView.image = result;
    }];
}
@end
