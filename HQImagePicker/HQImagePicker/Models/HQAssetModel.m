//
//  HQAssetModel.m
//  Photos
//
//  Created by huangqiang on 2017/5/19.
//  Copyright © 2017年 huangqiang. All rights reserved.
//

#import "HQAssetModel.h"

@implementation HQAssetModel
+ (HQAssetModel *)assetModelWithAsset:(PHAsset *)asset{
    return ({
        HQAssetModel * model = [HQAssetModel new];
        model.asset = asset;
        model;
    });
}
@end
