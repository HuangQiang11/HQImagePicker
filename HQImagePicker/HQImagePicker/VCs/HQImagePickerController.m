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
