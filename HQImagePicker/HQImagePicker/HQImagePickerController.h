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
    HQMultipleChoicesLibrary
};
@protocol HQImagePickerControllerDelegate;
@interface HQImagePickerController : UINavigationController
/*资源类型*/
@property (assign, nonatomic) HQImagePickerControllerSourceType sourceType;
/*pickerDelegate*/
@property (weak, nonatomic) id<HQImagePickerControllerDelegate>pickerDelegate;
/*选择数量，单选时次属性无效*/
@property (assign, nonatomic) NSUInteger num;

- (void)didCancelPickerController;
- (void)didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info;
- (void)showErrorMessage;

@end

@protocol HQImagePickerControllerDelegate<NSObject>
@optional
- (void)yy_imagePickerController:(HQImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info;
- (void)yy_imagePickerControllerDidCancel:(HQImagePickerController *)picker;

@end
