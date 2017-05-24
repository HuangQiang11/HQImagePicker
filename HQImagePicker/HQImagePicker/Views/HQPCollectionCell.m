//
//  HQCollectionCell.m
//  Photos
//
//  Created by huangqiang on 2017/5/19.
//  Copyright © 2017年 huangqiang. All rights reserved.
//

#import "HQPCollectionCell.h"
#import "HQCollectionModel.h"
#import "HQPhotoHandler.h"
#import "HQAssetModel.h"
@interface HQPCollectionCell()
@property (strong, nonatomic) UILabel * nameLabel;
@property (strong, nonatomic) UIImageView * iconImageView;
@end

@implementation HQPCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupLayout];
    }
    return self;
}

- (void)setupLayout{
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.iconImageView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat cellH = self.frame.size.height;
    CGFloat cellW = self.frame.size.width;
    CGFloat imageH = cellH-8*2;
    self.iconImageView.frame = CGRectMake(15, 8, imageH, imageH);
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+8, 0, cellW-imageH-8, cellH);
}

#pragma mark setter getter
- (void)setDataModel:(HQCollectionModel *)dataModel{
    _dataModel = dataModel;
    NSArray * dataArr = [HQPhotoHandler getPhotoCollectionsWithModel:dataModel];
        if (dataArr.count > 0) {
            CGFloat scale = [UIScreen mainScreen].scale;
            HQAssetModel * model = dataArr.lastObject;
            [HQPhotoHandler getPhotoWithAsset:model.asset size:CGSizeMake(100*scale, 100*scale) completion:^(UIImage *result) {
                self.iconImageView.image = result;
            }];
        }else{
            self.iconImageView.image = [UIImage imageNamed:@"icon"];
        }
        self.nameLabel.text = [NSString stringWithFormat:@"%@(%lu)",dataModel.locationTitle,dataArr.count];
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
    }
    return _nameLabel;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}


@end
