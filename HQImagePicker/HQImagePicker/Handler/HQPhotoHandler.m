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

+ (NSArray<HQAssetModel *> *)getPhotoCollections:(HQCollectionModel *)model{
    if (model == nil) {
        PHFetchResult * smartAlbums1 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
        if (smartAlbums1 > 0) {
            model = [HQCollectionModel collectionModelWithLocationTitle:@"相机胶卷" collection:smartAlbums1.firstObject];
        }
    }
    
    PHFetchResult * fetchResult = [PHAsset fetchAssetsInAssetCollection:model.collection options:nil];
    NSMutableArray * dataArr = @[].mutableCopy;
    for (PHAsset * asset in fetchResult) {
        [dataArr addObject:[HQAssetModel assetModelWithAsset:asset]];
    }
    return [dataArr copy];
}

+ (void)getAssetCollections:(HQPhotoHandlerBlock)success{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showErrorMessage];
            });
        }else{
           
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    
                     NSMutableArray * dataArr = @[].mutableCopy;
                     //相机胶卷
                    PHFetchResult * smartAlbums1 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
                    if (smartAlbums1 > 0) {
                        [dataArr addObject:[HQCollectionModel collectionModelWithLocationTitle:@"相机胶卷" collection:smartAlbums1.firstObject]];
                    }
                    
                    //SelfPortraits 自拍
                    PHFetchResult * smartAlbums2 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumSelfPortraits options:nil];
                    if (smartAlbums2 > 0) {
                        [dataArr addObject:[HQCollectionModel collectionModelWithLocationTitle:@"自拍" collection:smartAlbums2.firstObject]];
                    }
                    
                     //Panoramas 全景
                    PHFetchResult * smartAlbums3 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumPanoramas options:nil];
                    if (smartAlbums3 > 0) {
                         [dataArr addObject:[HQCollectionModel collectionModelWithLocationTitle:@"全景照片" collection:smartAlbums3.firstObject]];
                    }
                    
                    //Favorites 收藏
                    PHFetchResult * smartAlbums4 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumFavorites options:nil];
                    if (smartAlbums4 > 0) {
                        [dataArr addObject:[HQCollectionModel collectionModelWithLocationTitle:@"个人收藏" collection:smartAlbums4.firstObject]];
                    }
                    
                    //RecentlyAdded 最近添加
                    PHFetchResult * smartAlbums5 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumRecentlyAdded options:nil];
                    if (smartAlbums5 > 0) {
                        [dataArr addObject:[HQCollectionModel collectionModelWithLocationTitle:@"最近添加" collection:smartAlbums5.firstObject]];
                    }

                      //Bursts 连拍
                    PHFetchResult * smartAlbums6 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumBursts options:nil];
                    if (smartAlbums6 > 0) {
                        [dataArr addObject:[HQCollectionModel collectionModelWithLocationTitle:@"连拍快照" collection:smartAlbums6.firstObject]];
                    }
                    
                      //Screenshots 截屏
                    PHFetchResult * smartAlbums7 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumScreenshots options:nil];
                    if (smartAlbums7 > 0) {
                         [dataArr addObject:[HQCollectionModel collectionModelWithLocationTitle:@"屏幕快拍" collection:smartAlbums7.firstObject]];
                    }
                    
                     //DepthEffect 深景效果
                    PHFetchResult * smartAlbums8 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumDepthEffect options:nil];
                    if (smartAlbums8 > 0) {
                        [dataArr addObject:[HQCollectionModel collectionModelWithLocationTitle:@"深景效果" collection:smartAlbums8.firstObject]];
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
                    }
                }];
            
        }
    });
}

+ (void)showErrorMessage{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设备的\"设置-隐私-照片\"选项中，允许访问你的手机相册" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:cancelAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
}

@end
