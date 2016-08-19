//
//  LBMovieListTableViewCell.h
//  WeatherApp
//
//  Created by ligui on 16/7/8.
//  Copyright © 2016年 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBMovieListModel.h"

@interface LBMovieListTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *movieImageView;
@property (nonatomic, strong) UILabel *movieNameLabel;
@property (nonatomic, strong) UILabel *artistLabel;
@property (nonatomic, strong) UILabel *directorLabel;
@property (nonatomic, strong) UILabel *movieTypeLabel;
@property (nonatomic, strong) NSString *keyWordStr;
@property (nonatomic, strong) UILabel *ratingLabel;
- (void)setCellData:(LBMovieListModel *)sModel;
@end
