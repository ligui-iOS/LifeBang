//
//  CurrentCell.m
//  CityChoose
//
//  Created by Eric MiAo on 15/8/27.
//  Copyright (c) 2015年 Eric MiAo. All rights reserved.
//

#import "EMCurrentCell.h"
#import "EMCityChoose.h"

@implementation EMCurrentCell

- (void)awakeFromNib {
    // Initialization code
    }

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cityLabel = [[UILabel alloc]init];
        _cityLabel.font = CUSTOM_FONT(17);
        _cityLabel.textAlignment = 1;
        _cityLabel.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
        if (SCREEN_WIDTH == 320) {
            _cityLabel.frame = CGRectMake(10, 10, 70, 35);
            
        }else if (SCREEN_WIDTH == 375) {
            _cityLabel.frame = CGRectMake(10, 10, 80, 40);
          
        }else {
            _cityLabel.frame = CGRectMake(10, 10, 100, 50);
            
        }
        [self.contentView addSubview:_cityLabel];
        _GPSLabel = [[UILabel alloc]init];
        _GPSLabel.font = CUSTOM_FONT(17);
        _GPSLabel.textAlignment = 1;
        _GPSLabel.text = @"GPS定位";
        _GPSLabel.backgroundColor = [UIColor clearColor];
        _GPSLabel.textColor = [UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1];
        if (SCREEN_WIDTH == 320) {
            _GPSLabel.frame = CGRectMake(80, 10, 100, 35);
            
        }else if (SCREEN_WIDTH == 375) {
            _GPSLabel.frame = CGRectMake(80, 10, 105, 40);
            
        }else {
            _GPSLabel.frame = CGRectMake(80, 10, 125, 50);
            
        }
        [self.contentView addSubview:_GPSLabel];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com