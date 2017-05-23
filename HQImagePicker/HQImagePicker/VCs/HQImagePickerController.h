//
//  HQImagePickerController.h
//  HQImagePicker
//
//  Created by huangqiang on 2017/5/23.
//  Copyright © 2017年 huangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const HQImagePickerControllerOriginalImage;
extern NSString *const HQImagePickerControllerEditedImage;
typedef NS_ENUM(NSInteger, HQImagePickerControllerSourceType) {
    HQPhotoLibrary,
    HQCamera,
    HQMultipleChoicesLibrary
};
@protocol HQImagePickerControllerDelegate;


@interface HQImagePickerController : UINavigationController
@property (assign, nonatomic) HQImagePickerControllerSourceType sourceType;
/*
    多选时，次属性无效
 */
@property (weak, nonatomic) id<HQImagePickerControllerDelegate>pickerDelegate;
- (void)didCancelPickerController;
- (void)didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info;
@end

@protocol HQImagePickerControllerDelegate<NSObject>
@optional
- (void)yy_imagePickerController:(HQImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info;
- (void)yy_imagePickerControllerDidCancel:(HQImagePickerController *)picker;

@end
