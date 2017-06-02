//
//  HQEditController.m
//  HQImagePicker
//
//  Created by huangqiang on 2017/5/23.
//  Copyright © 2017年 huangqiang. All rights reserved.
//

#import "HQEditController.h"
#import "HQAssetModel.h"
#import "HQPhotoHandler.h"
#import "HQImagePickerController.h"
static const CGFloat kMaxScale = 3.0;
static const CGFloat kMinScale  = 1.0;
static const CGFloat kLineWidth = 1.0;
@interface HQEditController ()<UIScrollViewDelegate>{
    CGFloat scrollViewWH;
}
@property (strong, nonatomic) UIScrollView * scrollView;
@property (strong, nonatomic) UIImageView * imageView;
@property (strong, nonatomic) UIImage * imageSource;
@property (assign, nonatomic) CGSize imageSize;
@property (strong, nonatomic) UIToolbar * bar;
@end

@implementation HQEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
    [self addGesture];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupLayout];
    [self addLayers];
    [self loadData];
}

#pragma mark loadData
- (void)loadData{
    [HQPhotoHandler getPhotoWithAsset:self.assetModel.asset size:PHImageManagerMaximumSize completion:^(UIImage *result) {
        self.imageSource = result;
        [self countImageSize];
    }];
}

#pragma mark layout
- (void)setupLayout{
    CGFloat viewW = CGRectGetWidth(self.view.frame);
    scrollViewWH = viewW;
    self.scrollView.frame = CGRectMake(0, 0, scrollViewWH, scrollViewWH);
    self.scrollView.center = self.view.center;
    self.bar.frame = CGRectMake(0, CGRectGetHeight(self.view.frame)-49, CGRectGetWidth(self.view.frame), 49);
}

- (void)addLayers{
    CAShapeLayer *shapeLayer = ({
        UIBezierPath *bPath = [UIBezierPath bezierPathWithRect:self.view.frame];
        UIBezierPath *bsPath = [UIBezierPath bezierPathWithRect:self.scrollView.frame];
        [bPath appendPath:bsPath];
        bPath.usesEvenOddFillRule = YES;
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.fillColor = [UIColor blackColor].CGColor;
        shapeLayer.fillRule = kCAFillRuleEvenOdd;
        shapeLayer.path = bPath.CGPath;
        shapeLayer.opacity = 0.6;
        shapeLayer;
    });
    
    CAShapeLayer * borderLayer = ({
        CAShapeLayer * borderLayer = [CAShapeLayer layer];
        UIBezierPath * borderPath = [UIBezierPath bezierPathWithRect:CGRectMake(CGRectGetMinX(self.scrollView.frame)+kLineWidth/2.0, CGRectGetMinY(self.scrollView.frame)+kLineWidth/2.0, CGRectGetWidth(self.scrollView.frame)-kLineWidth, CGRectGetWidth(self.scrollView.frame)-kLineWidth)];
        borderLayer.path = borderPath.CGPath;
        borderLayer.fillColor = [UIColor clearColor].CGColor;
        borderLayer.strokeColor = [UIColor whiteColor].CGColor;
        borderLayer.lineWidth = kLineWidth;
        borderLayer;
    });
    
    [self.view.layer addSublayer:shapeLayer];
    [self.view.layer addSublayer:borderLayer];
    [self.view addSubview:self.bar];
}

- (void)creatUI{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor blackColor];
    self.view.clipsToBounds = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
}

#pragma mark private method
- (void)countImageSize{
    CGFloat imageHeight = scrollViewWH * (self.imageSource.size.height / self.imageSource.size.width);
    CGFloat imageWidth = scrollViewWH;
    if (imageHeight < scrollViewWH) {
        imageWidth = scrollViewWH * (imageWidth / imageHeight);
        imageHeight = scrollViewWH;
    }
    self.imageSize = CGSizeMake(imageWidth, imageHeight);
    
    self.imageView.frame = CGRectMake(0, 0, self.imageSize.width, self.imageSize.height);
    self.scrollView.contentSize = CGSizeMake(self.imageSize.width + 0.25, self.imageSize.height + 0.25);
    self.scrollView.contentOffset = CGPointMake(0.5 * (self.imageSize.width - scrollViewWH), 0.5 * (self.imageSize.height - scrollViewWH));
    
    self.imageView.image = self.imageSource = [self resizeImageAppropriately];
}

- (void)addGesture{
    UITapGestureRecognizer * tap = ({
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tap.numberOfTapsRequired = 2;
        tap;
    });
    [self.scrollView addGestureRecognizer:tap];
}

- (UIImage *)resizeImageAppropriately {
    UIGraphicsBeginImageContextWithOptions(self.imageSize, NO, [UIScreen mainScreen].scale * 2);
    [self.imageSource drawInRect:CGRectMake(0, 0, self.imageSize.width, self.imageSize.height)];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

// 使contentSize大于frame，bounce一直有效
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if (scale == 1.0) {
        scrollView.contentSize = CGSizeMake(self.imageSize.width + 0.25, self.imageSize.height + 0.25);
    }
}

#pragma mark all click
- (void)tapAction:(UITapGestureRecognizer *)tap{
    if (self.scrollView.zoomScale > kMinScale) {
        [self.scrollView setZoomScale:kMinScale animated:YES];
    } else {
        CGPoint location = [tap locationInView:self.scrollView];
        CGRect zoomRect = CGRectZero;
        zoomRect.size.height = tap.view.frame.size.height / kMaxScale;
        zoomRect.size.width  = tap.view.frame.size.width  / kMaxScale;
        zoomRect.origin.x = location.x - (zoomRect.size.width  / 2.0);
        zoomRect.origin.y = location.y - (zoomRect.size.height / 2.0) + self.scrollView.contentInset.top;
        [self.scrollView zoomToRect:zoomRect animated:YES];
    }
}

- (void)clipImage {
    CGRect clipRange = CGRectMake(- self.scrollView.contentOffset.x,
                                  - self.scrollView.contentOffset.y,
                                  self.imageView.frame.size.width,
                                  self.imageView.frame.size.height);
    
    CGRect maskRange = CGRectMake(0, 0, self.scrollView.frame.size.height,
                                  self.scrollView.frame.size.height);
    
    UIBezierPath * bezierPath = nil;
    bezierPath = [UIBezierPath bezierPathWithRoundedRect:maskRange cornerRadius:0];
    UIGraphicsBeginImageContextWithOptions(self.scrollView.frame.size, NO, [UIScreen mainScreen].scale);
    [bezierPath addClip];
    [self.imageSource drawInRect:clipRange];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    HQImagePickerController * picker = (HQImagePickerController*)self.navigationController;
    [picker didFinishPickingMediaWithInfo:@{HQImagePickerControllerEditedImage:image,HQImagePickerControllerOriginalImage:self.imageSource}];
}

- (void)cancelItem:(UIBarButtonItem *)item{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneItem:(UIBarButtonItem *)item{
    [self clipImage];
}

#pragma mark lazy
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.clipsToBounds = NO;
        _scrollView.minimumZoomScale = kMinScale;
        _scrollView.maximumZoomScale = kMaxScale;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UIToolbar *)bar{
    if (!_bar) {
        _bar = [[UIToolbar alloc] init];
        _bar.barStyle = UIBarStyleBlack;
        [_bar setTintColor:[UIColor whiteColor]];
        UIBarButtonItem * cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelItem:)];
        UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem * doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneItem:)];
        [_bar setItems:@[cancelItem,spaceItem,doneItem]];
    }
    return _bar;
}

@end
