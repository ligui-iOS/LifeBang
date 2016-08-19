//
//  LBSongListTableViewCell.m
//  WeatherApp
//
//  Created by ligui on 16/6/20.
//  Copyright © 2016年 ZhenzhenXu. All rights reserved.
//

#import "LBSongListTableViewCell.h"

@implementation LBSongListTableViewCell

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
    self.songNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.frame.size.width, 20)];
    self.songNameLabel.font = CUSTOM_FONT(15);
    self.songNameLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.songNameLabel];
    
    self.artistLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.songNameLabel.frame.origin.y+self.songNameLabel.frame.size.height+3, self.frame.size.width, self.frame.size.height-(self.songNameLabel.frame.origin.y+self.songNameLabel.frame.size.height+10))];
    self.artistLabel.textColor = [UIColor grayColor];
    self.artistLabel.font = CUSTOM_FONT(11);
    [self.contentView addSubview:self.artistLabel];
}
- (void)setCellData:(LBSongModel *)sModel
{
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:sModel.songname];
    [attriStr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x76d5ff)} range:[sModel.songname rangeOfString:self.keyWordStr]];
    self.songNameLabel.attributedText = attriStr;
    
    self.artistLabel.text = sModel.artistname;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
