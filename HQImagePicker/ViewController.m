//
//  ViewController.m
//  HQImagePicker
//
//  Created by huangqiang on 2017/5/23.
//  Copyright © 2017年 huangqiang. All rights reserved.
//

#import "ViewController.h"
#import "HQImagePickerController.h"
@interface ViewController ()<HQImagePickerControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *singleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)singleBtnClick:(id)sender {
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * photoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }];
    UIAlertAction * albumAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        /*单选 + 可编辑*/
        HQImagePickerController * picker = [[HQImagePickerController alloc] init];
        picker.pickerDelegate = self;
        picker.sourceType = HQPhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    UIAlertAction * cacelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertVC addAction:photoAction];
    [alertVC addAction:albumAction];
    [alertVC addAction:cacelAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (IBAction)doubleBtnClick:(id)sender {
    /*多选*/
    HQImagePickerController * picker = [[HQImagePickerController alloc] init];
    picker.pickerDelegate = self;
    picker.sourceType = HQMultipleChoicesLibrary;
    picker.num = 2;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)takePhoto{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

#pragma mark HQImagePickerControllerDelegate
- (void)yy_imagePickerController:(HQImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    if (picker.sourceType == HQPhotoLibrary) {
        self.singleImageView.image = info[HQImagePickerControllerEditedImage];
    }else if(picker.sourceType == HQMultipleChoicesLibrary){
        NSArray * arr = info[HQImagePickerControllerOriginalImage];
        self.leftImageView.image = arr[0];
        self.rightImageView.image = arr[1];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)yy_imagePickerControllerDidCancel:(HQImagePickerController *)picker{
     [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.singleImageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
