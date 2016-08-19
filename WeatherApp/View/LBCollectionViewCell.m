//
//  LBCollectionViewCell.m
//  WeatherApp
//
//  Created by ligui on 16/2/29.
//  Copyright © 2016年 ZhenzhenXu. All rights reserved.
//

#import "LBCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#define IMAGEURL @"http://tnfs.tngou.net/img"

@implementation LBCollectionViewCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI
{
    self.topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width*1.5)];
    [self.contentView addSubview:self.topImageView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.topImageView.frame.origin.y+self.topImageView.frame.size.height, self.frame.size.width, 20)];
    self.titleLabel.font = CUSTOM_FONT(13);
    [self.contentView addSubview:self.titleLabel];
    
    self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height, self.frame.size.width, self.frame.size.height-(self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height))];
    self.descriptionLabel.font = CUSTOM_FONT(11);
    [self.contentView addSubview:self.descriptionLabel];
}
- (void)setCellData:(LBFoodListModel *)dataModel
{
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEURL,dataModel.img]]];
    self.titleLabel.text = dataModel.name;
    
    self.descriptionLabel.numberOfLines = 0;
    CGFloat height = [LBTool getHeightBoundingRectWithSize:dataModel.foodDescription width:self.frame.size.width fontSize:11];
    self.descriptionLabel.frame = CGRectMake(0, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height, self.frame.size.width, height);
    self.descriptionLabel.text = dataModel.foodDescription;
}
- (void)awakeFromNib {
    // Initialization code
}
@end
