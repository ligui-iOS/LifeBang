//
//  LBTravelNotesCollectionViewCell.m
//  WeatherApp
//
//  Created by ligui on 16/6/23.
//  Copyright © 2016年 ZhenzhenXu. All rights reserved.
//

#import "LBTravelNotesCollectionViewCell.h"
#import "UIImageView+WebCache.m"
@interface LBTravelNotesCollectionViewCell()
{
    UIImageView *_topImageView;
    UILabel *_titleLabel;
    UILabel *_descriptionLabel;
    UILabel *_contentLabel;
}
@end
@implementation LBTravelNotesCollectionViewCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI
{
    _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width/1.5)];
    [self.contentView addSubview:_topImageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _topImageView.frame.origin.y+_topImageView.frame.size.height, self.frame.size.width, 40)];
    _titleLabel.font = CUSTOM_FONT(18);
    _titleLabel.numberOfLines = 0;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLabel];
    
    _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, _titleLabel.frame.origin.y+_titleLabel.frame.size.height+10, self.frame.size.width-10, 15)];
    _descriptionLabel.font = CUSTOM_FONT(13);
    _descriptionLabel.adjustsFontSizeToFitWidth = YES;
    _descriptionLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_descriptionLabel];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _descriptionLabel.frame.origin.y+_descriptionLabel.frame.size.height+10, self.frame.size.width-30, self.frame.size.height-(_descriptionLabel.frame.origin.y+_descriptionLabel.frame.size.height+10))];
    _contentLabel.font = CUSTOM_FONT(11);
    _contentLabel.numberOfLines = 0;
    [self.contentView addSubview:_contentLabel];
}
- (void)setCellData:(LBTravelNotesModel *)dataModel
{
    [_topImageView sd_setImageWithURL:[NSURL URLWithString:dataModel.headImage] placeholderImage:[UIImage imageNamed:@"travel_placeholder"]];
    
    _titleLabel.text = dataModel.title;
    
    _descriptionLabel.text = [NSString stringWithFormat:@"%@  出发时间：%@  天数：%@",dataModel.userName,dataModel.startTime,dataModel.routeDays];
    
    _contentLabel.text = [NSString stringWithFormat:@"    %@",dataModel.text];
}
@end
