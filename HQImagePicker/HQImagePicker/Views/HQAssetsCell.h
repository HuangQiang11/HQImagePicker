//
//  HQAssetsCell.h
//  HQImagePicker
//
//  Created by huangqiang on 2017/5/23.
//  Copyright © 2017年 huangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HQAssetModel;
extern NSString * const HQAssetsCellID;
@interface HQAssetsCell : UICollectionViewCell
@property (strong, nonatomic)  UIImageView *imageView;
@property (strong, nonatomic) HQAssetModel * assetModel;
@end
