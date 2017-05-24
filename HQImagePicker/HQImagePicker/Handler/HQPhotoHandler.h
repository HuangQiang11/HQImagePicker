//
//  HQPhotoHandle.h
//  Photos
//
//  Created by huangqiang on 2017/5/18.
//  Copyright © 2017年 huangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
@class HQAssetModel;
@class HQCollectionModel;
typedef void(^HQPhotoHandlerBlock) (id);
typedef void(^HQPhotoHandlerFailBlock)(id);
@interface HQPhotoHandler : NSObject
+ (void)getAssetCollectionsWithCompletion:(HQPhotoHandlerBlock)success fail:(HQPhotoHandlerFailBlock)fail;
+ (NSArray<HQAssetModel *>*)getPhotoCollectionsWithModel:(HQCollectionModel *)model;
+ (void)getPhotoCollectionsWithModel:(HQCollectionModel *)model completion:(HQPhotoHandlerBlock)success fail:(HQPhotoHandlerFailBlock)fail;
+ (void)getPhotoWithAsset:(PHAsset *)asset size:(CGSize)size completion:(void (^)(UIImage * result))resultHandler;
@end
