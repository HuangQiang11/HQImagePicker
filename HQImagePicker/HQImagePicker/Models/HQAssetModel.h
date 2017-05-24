//
//  HQAssetModel.h
//  Photos
//
//  Created by huangqiang on 2017/5/19.
//  Copyright © 2017年 huangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
@interface HQAssetModel : NSObject
@property (strong, nonatomic) PHAsset * asset;
@property (strong, nonatomic) UIImage * assetImage;
+ (HQAssetModel *)assetModelWithAsset:(PHAsset *)asset;
@end
