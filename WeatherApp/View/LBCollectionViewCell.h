//
//  LBCollectionViewCell.h
//  WeatherApp
//
//  Created by ligui on 16/2/29.
//  Copyright © 2016年 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBFoodListModel.h"

@interface LBCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *topImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;
-(void)setCellData:(LBFoodListModel *)dataModel;
@end
