//
//  HotCitysCell.m
//  CityChoose
//
//  Created by Eric MiAo on 15/8/27.
//  Copyright (c) 2015年 Eric MiAo. All rights reserved.
//

#import "EMHotCitysCell.h"
#import "EMCityChoose.h"

@implementation EMHotCitysCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *nameArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"hotCityName"];
        NSInteger numberOfCity = [[[NSUserDefaults standardUserDefaults]objectForKey:@"hotCityNumber"] integerValue];
        for (int i = 0; i < numberOfCity; i ++) {
            UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
            aButton.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
            [aButton setTitle:[nameArray objectAtIndex:i] forState:UIControlStateNormal];
            aButton.titleLabel.font = CUSTOM_FONT(17);
            [aButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [aButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            aButton.tag = 10000 + i;
            [aButton addTarget:self action:@selector(buttonMethod:) forControlEvents:UIControlEventTouchUpInside];
            if (SCREEN_WIDTH == 320) {
                aButton.frame = CGRectMake(10+(i%3*80), 10+(i/3)*45, 70, 35);
                
            }else if (SCREEN_WIDTH == 375) {
                aButton.frame = CGRectMake(10+(i%3*90), 10+(i/3)*50, 80, 40);
                
            }else {
                aButton.frame = CGRectMake(10+(i%3*110), 10+(i/3)*60, 100, 50);
                
            }
            [_buttonArray addObject:aButton];
            [self.contentView addSubview:aButton];
        }
        
    }
    return self;
}

- (void)buttonMethod:(UIButton *)sender {
    NSInteger aTag = sender.tag - 10000;
    NSString *aStr = [NSString stringWithFormat:@"%ld",aTag];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:aStr forKey:@"tag"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"cityNameNotification" object:self userInfo:dic];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com