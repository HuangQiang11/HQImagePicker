//
//  HQMBTool.m
//  HQImagePicker
//
//  Created by huangqiang on 2017/5/24.
//  Copyright © 2017年 huangqiang. All rights reserved.
//

#import "HQMBTool.h"
#import "MBProgressHUD.h"
@implementation HQMBTool
+(void) showMessage:(NSString *)message{
    [self showMessage:message time:1.0f];
}

+ (void)showMessage:(NSString *)message time:(NSTimeInterval)time{
    if (!message) {
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    // Move to bottm center.
    hud.offset = CGPointMake(0.f, 10);
    //backgroup
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    
    hud.contentColor = [UIColor whiteColor];
    
    [hud hideAnimated:YES afterDelay:time];
}

@end
