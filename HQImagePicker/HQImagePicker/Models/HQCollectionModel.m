//
//  HQCollectionModel.m
//  Photos
//
//  Created by huangqiang on 2017/5/19.
//  Copyright © 2017年 huangqiang. All rights reserved.
//

#import "HQCollectionModel.h"

@implementation HQCollectionModel
+ (HQCollectionModel *)collectionModelWithLocationTitle:(NSString *)name collection:(PHAssetCollection *)collection{
    return ({
        HQCollectionModel * model = [HQCollectionModel new];
        model.locationTitle = name;
        model.collection = collection;
        model;
    });
}

@end
