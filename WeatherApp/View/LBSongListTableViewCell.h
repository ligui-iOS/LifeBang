//
//  LBSongListTableViewCell.h
//  WeatherApp
//
//  Created by ligui on 16/6/20.
//  Copyright © 2016年 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBSongModel.h"

@interface LBSongListTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *songNameLabel;
@property (nonatomic, strong) UILabel *artistLabel;
@property (nonatomic, strong) NSString *keyWordStr;
- (void)setCellData:(LBSongModel *)sModel;
@end
