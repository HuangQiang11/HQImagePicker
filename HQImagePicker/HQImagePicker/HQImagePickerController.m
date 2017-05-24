//
//  HQImagePickerController.m
//  HQImagePicker
//
//  Created by huangqiang on 2017/5/23.
//  Copyright © 2017年 huangqiang. All rights reserved.
//

#import "HQImagePickerController.h"
#import "HQCollectionController.h"
#import "HQAssetsController.h"
#import "HQMBTool.h"
NSString *const HQImagePickerControllerOriginalImage = @"HQImagePickerControllerOriginalImage";
NSString *const HQImagePickerControllerEditedImage = @"HQImagePickerControllerEditedImage";
@interface HQImagePickerController ()<UIGestureRecognizerDelegate>

@end

@implementation HQImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupBarStyle];
    [self setupGesture];
    self.viewControllers = @[[HQCollectionController new],[HQAssetsController new]];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.sourceType == HQMultipleChoicesLibrary && self.num <= 0) {
        [HQMBTool showMessage:@"数量出错！"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setupGesture{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)setupBarStyle{
    UINavigationBar * bar = [UINavigationBar appearance];
    [bar setBarTintColor:[UIColor blackColor]];
    [bar setTintColor:[UIColor whiteColor]];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

#pragma mark common method
- (void)didCancelPickerController{
    if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(yy_imagePickerControllerDidCancel:)]) {
        [self.pickerDelegate yy_imagePickerControllerDidCancel:self];
    }
}

- (void)didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(yy_imagePickerController:didFinishPickingMediaWithInfo:)]) {
        [self.pickerDelegate yy_imagePickerController:self didFinishPickingMediaWithInfo:info];
    }
}

- (void)showErrorMessage{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设备的\"设置-隐私-照片\"选项中，允许访问你的手机相册" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.viewControllers.count == 1) {
        return  NO;
    }
    return YES;
}

#pragma mark 禁止转屏
- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
