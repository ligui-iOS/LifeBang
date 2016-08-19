//
//  LBMovieListTableViewCell.m
//  WeatherApp
//
//  Created by ligui on 16/7/8.
//  Copyright © 2016年 ZhenzhenXu. All rights reserved.
//

#import "LBMovieListTableViewCell.h"
#import "HCSStarRatingView.h"
#import "UIImageView+WebCache.h"

@implementation LBMovieListTableViewCell
{
    HCSStarRatingView *starRatingView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI
{
    self.movieImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 3, 62, 95)];
    self.movieImageView.layer.masksToBounds = YES;
    self.movieImageView.layer.cornerRadius = 3;
    [self.contentView addSubview:self.movieImageView];
    
    self.movieNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.movieImageView.frame.origin.x+self.movieImageView.frame.size.width+5, 3, self.frame.size.width-(self.movieImageView.frame.origin.x+self.movieImageView.frame.size.width+3), 20)];
    self.movieNameLabel.font = CUSTOM_FONT(15);
    self.movieNameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.movieNameLabel];
    
    self.directorLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.movieNameLabel.frame.origin.x, self.movieNameLabel.frame.origin.y+self.movieNameLabel.frame.size.height+2, self.movieNameLabel.frame.size.width, 15)];
    self.directorLabel.textColor = [UIColor grayColor];
    self.directorLabel.font = CUSTOM_FONT(11);
    [self.contentView addSubview:self.directorLabel];
    
    self.artistLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.directorLabel.frame.origin.x, self.directorLabel.frame.origin.y+self.directorLabel.frame.size.height+2, self.directorLabel.frame.size.width, 15)];
    self.artistLabel.textColor = [UIColor grayColor];
    self.artistLabel.font = CUSTOM_FONT(11);
    [self.contentView addSubview:self.artistLabel];
    
    self.movieTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.artistLabel.frame.origin.x, self.artistLabel.frame.origin.y+self.artistLabel.frame.size.height+2, self.artistLabel.frame.size.width, 15)];
    self.movieTypeLabel.textColor = [UIColor grayColor];
    self.movieTypeLabel.font = CUSTOM_FONT(11);
    [self.contentView addSubview:self.movieTypeLabel];
    
    self.ratingLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.artistLabel.frame.origin.x+110, self.movieTypeLabel.frame.origin.y+self.movieTypeLabel.frame.size.height+2, 100, 15)];
    self.ratingLabel.textColor = [UIColor blackColor];
    self.ratingLabel.font = CUSTOM_FONT(11);
    [self.contentView addSubview:self.ratingLabel];

}
- (void)setCellData:(LBMovieListModel *)sModel
{
    self.movieNameLabel.text = [NSString stringWithFormat:@"%@(%@)",sModel.title,sModel.year];
    
    [self.movieImageView sd_setImageWithURL:[NSURL URLWithString:sModel.images[@"small"]] placeholderImage:[UIImage imageNamed:@"travel_placeholder"]];
    
    NSMutableString *directorStr = [[NSMutableString alloc] initWithString:@"导演："];
    if (sModel.directors.count>1) {
        for (NSString *str in sModel.directors) {
            if (str == sModel.directors[0]) {
                [directorStr appendFormat:@"%@",str];
            }else {
                [directorStr appendFormat:@"/%@",str];
            }
        }
    }else {
        if (!sModel.directors||sModel.directors.count == 0) {
            return;
        }
        [directorStr appendString:[[sModel.directors firstObject] objectForKey:@"name"]];
    }
    self.directorLabel.text = directorStr;
    
    NSMutableString *artistStr = [[NSMutableString alloc] initWithString:@"主演："];
    if (sModel.casts.count>1) {
        for (NSDictionary *dict in sModel.casts) {
            if (dict == sModel.casts[0]) {
                [artistStr appendFormat:@"%@",dict[@"name"]];
            }else {
                [artistStr appendFormat:@"/%@",dict[@"name"]];
            }

        }
    }else {
        if (!sModel.casts||sModel.casts.count == 0) {
            return;
        }
        [artistStr appendString:[[sModel.casts firstObject] objectForKey:@"name"]];
    }
    self.artistLabel.text = artistStr;
    
    NSMutableString *typeStr = [[NSMutableString alloc] initWithString:@"类型："];
    if (sModel.genres.count>1) {
        for (NSString *str in sModel.genres) {
            if (str == sModel.genres[0]) {
                [typeStr appendFormat:@"%@",str];
            }else {
                [typeStr appendFormat:@"/%@",str];
            }
        }
    }else {
        if (!sModel.genres||sModel.genres.count == 0) {
            return;
        }
        [typeStr appendString:[sModel.genres firstObject]];
    }
    self.movieTypeLabel.text = typeStr;
    
//    for (UIView *subview in self) {
//        if ([subview isKindOfClass:[HCSStarRatingView class]]) {
//            [subview removeFromSuperview];
//        }
//    }
    if (starRatingView) {
        [starRatingView removeFromSuperview];
        starRatingView = nil;
    }
    
    starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(self.movieTypeLabel.frame.origin.x, self.movieTypeLabel.frame.origin.y+self.movieTypeLabel.frame.size.height+2, 100, 20)];
    starRatingView.allowsHalfStars = YES;
    starRatingView.maximumValue = [sModel.rating[@"max"] floatValue]/2;
    starRatingView.minimumValue = [sModel.rating[@"min"] floatValue];
    starRatingView.value = [sModel.rating[@"average"] floatValue]/2;
    starRatingView.tintColor = [UIColor redColor];
    [self.contentView addSubview:starRatingView];
    
    self.ratingLabel.text = [NSString stringWithFormat:@"评分：%.1f",[sModel.rating[@"average"] floatValue]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
