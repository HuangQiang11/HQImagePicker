//
//  HQCollectionModel.h
//  Photos
//
//  Created by huangqiang on 2017/5/19.
//  Copyright © 2017年 huangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
@interface HQCollectionModel : NSObject
@property (copy, nonatomic) NSString * locationTitle;
@property (strong, nonatomic) PHAssetCollection * collection;
+ (HQCollectionModel *)collectionModelWithLocationTitle:(NSString *)name collection:(PHAssetCollection *)collection;
@end
