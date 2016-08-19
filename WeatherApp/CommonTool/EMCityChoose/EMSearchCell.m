//
//  EMSearchCell.m
//  renrenxing
//
//  Created by apple01 on 15/9/1.
//  Copyright (c) 2015年 ControlStrength. All rights reserved.
//

#import "EMSearchCell.h"

@implementation EMSearchCell

- (void)awakeFromNib {
    // Initialization code   
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
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