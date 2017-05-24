//
//  HQPhotoHandle.m
//  Photos
//
//  Created by huangqiang on 2017/5/18.
//  Copyright © 2017年 huangqiang. All rights reserved.
//

#import "HQPhotoHandler.h"
#import "HQCollectionModel.h"
#import "UIImage+HQPhoto.h"
#import "HQAssetModel.h"
#import "HQMBTool.h"
@implementation HQPhotoHandler
+ (void)getPhotoWithAsset:(PHAsset *)asset size:(CGSize)size completion:(void (^)(UIImage * result))resultHandler{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHImageRequestOptions * option = [[PHImageRequestOptions alloc] init];
        option.resizeMode = PHImageRequestOptionsResizeModeFast;
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            UIImage * image = nil;
            if (CGSizeEqualToSize(size, PHImageManagerMaximumSize)) {
                //原图
                image = result;
            }else{
                //缩略图
                image = [result cutSpuarePhoto];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                resultHandler ? resultHandler(image):nil;
            });
        }];
    });
}

+ (NSArray<HQAssetModel *>*)getPhotoCollectionsWithModel:(HQCollectionModel *)model{
    PHFetchResult * fetchResult = [PHAsset fetchAssetsInAssetCollection:model.collection options:nil];
    NSMutableArray * dataArr = @[].mutableCopy;
    for (PHAsset * asset in fetchResult) {
        [dataArr addObject:[HQAssetModel assetModelWithAsset:asset]];
    }
    return dataArr;
}

+ (void)getPhotoCollectionsWithModel:(HQCollectionModel *)model completion:(HQPhotoHandlerBlock)success fail:(HQPhotoHandlerFailBlock)fail{
    if (model != nil) {
        NSArray * dataArr = [self getPhotoCollectionsWithModel:model];
        success ? success(dataArr):nil;
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
            if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    fail?fail(@"denied or restricted"):nil;
                });
            }else{
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    if (status == PHAuthorizationStatusAuthorized) {/*授权成功*/
                        //相机胶卷
                        PHFetchResult * smartAlbums1 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
                        for (PHAssetCollection * collection in smartAlbums1) {
                            if ([collection.localizedTitle isEqual:@"Camera Roll"]) {
                                HQCollectionModel * nModel = [HQCollectionModel collectionModelWithLocationTitle:@"相机胶卷" collection:collection];
                                NSArray * dataArr = [self getPhotoCollectionsWithModel:nModel];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    success ? success(dataArr):nil;
                                });
                            }
                        }
                    }else{/*授权失败*/
                        dispatch_async(dispatch_get_main_queue(), ^{
                            fail?fail(@"fail Authorized"):nil;
                        });
                    }
                }];
            }
        });
    }
}

+ (void)getAssetCollectionsWithCompletion:(HQPhotoHandlerBlock)success fail:(HQPhotoHandlerFailBlock)fail{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                fail ? fail(@"denied or restricted"):nil;
            });
        }else{
            
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {/*授权成功*/
                    
                    NSMutableArray * dataArr = @[].mutableCopy;
                    //相机胶卷
                    PHFetchResult * smartAlbums1 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
                    for (PHAssetCollection * collection in smartAlbums1) {
                        if ([collection.localizedTitle isEqual:@"Camera Roll"]) {
                            [dataArr addObject:[HQCollectionModel collectionModelWithLocationTitle:@"相机胶卷" collection:collection]];
                        }
                    }
                    
                    //SelfPortraits 自拍
                    PHFetchResult * smartAlbums2 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumSelfPortraits options:nil];
                    for (PHAssetCollection * collection in smartAlbums2) {
                        if ([collection.localizedTitle isEqual:@"Selfies"]) {
                            [dataArr addObject:[HQCollectionModel collectionModelWithLocationTitle:@"自拍" collection:collection]];
                        }
                    }
                    
                    //Panoramas 全景
                    PHFetchResult * smartAlbums3 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumPanoramas options:nil];
                    for (PHAssetCollection * collection in smartAlbums3) {
                        if ([collection.localizedTitle isEqual:@"Panoramas"]) {
                            [dataArr addObject:[HQCollectionModel collectionModelWithLocationTitle:@"全景照片" collection:collection]];
                        }
                    }
                    
                    //Favorites 收藏
                    PHFetchResult * smartAlbums4 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumFavorites options:nil];
                    for (PHAssetCollection * collection in smartAlbums4) {
                        if ([collection.localizedTitle isEqual:@"Favorites"]) {
                            [dataArr addObject:[HQCollectionModel collectionModelWithLocationTitle:@"个人收藏" collection:collection]];
                        }
                    }
                    
                    //RecentlyAdded 最近添加
                    PHFetchResult * smartAlbums5 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumRecentlyAdded options:nil];
                    for (PHAssetCollection * collection in smartAlbums5) {
                        if ([collection.localizedTitle isEqual:@"Recently Added"]) {
                            [dataArr addObject:[HQCollectionModel collectionModelWithLocationTitle:@"最近添加" collection:collection]];
                        }
                    }
                    
                    //Bursts 连拍
                    PHFetchResult * smartAlbums6 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumBursts options:nil];
                    for (PHAssetCollection * collection in smartAlbums6) {
                        if ([collection.localizedTitle isEqual:@"Bursts"]) {
                            [dataArr addObject:[HQCollectionModel collectionModelWithLocationTitle:@"连拍快照" collection:collection]];
                        }
                    }
                    
                    //Screenshots 截屏
                    PHFetchResult * smartAlbums7 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumScreenshots options:nil];
                    for (PHAssetCollection * collection in smartAlbums7) {
                        if ([collection.localizedTitle isEqual:@"Screenshots"]) {
                            [dataArr addObject:[HQCollectionModel collectionModelWithLocationTitle:@"屏幕快拍" collection:collection]];
                        }
                    }
                    
                    //DepthEffect 深景效果
                    PHFetchResult * smartAlbums8 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumDepthEffect options:nil];
                    for (PHAssetCollection * collection in smartAlbums8) {
                        if ([collection.localizedTitle isEqual:@"Depth Effect"]) {
                            [dataArr addObject:[HQCollectionModel collectionModelWithLocationTitle:@"深景效果" collection:collection]];
                        }
                    }
                    
                    //用户到逻辑相册
                    PHFetchResult * smartAlbums9 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
                    for (PHAssetCollection * collection in smartAlbums9) {
                        if (collection.estimatedAssetCount != 0) {
                            NSLog(@"AlbumRegular:%@",collection.localizedTitle);
                            [dataArr addObject:[HQCollectionModel collectionModelWithLocationTitle:collection.localizedTitle collection:collection]];
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success ? success(dataArr):nil;
                    });
                }else{/*授权失败*/
                    dispatch_async(dispatch_get_main_queue(), ^{
                        fail ? fail(@"fail Authorized"):nil;
                    });
                }
            }];
        }
    });

}

@end
