//
//  XXLyricsView.m
//  LZXMusicPlayer
//
//  Created by twzs on 16/6/29.
//  Copyright © 2016年 LZX. All rights reserved.
//

#import "XXLyricsView.h"
#import "XXLyricsModel.h"
#import "XXLyricsData.h"
#import "XXLyricFind.h"


@interface XXLyricsView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) UITableView  *table;

@property (nonatomic, strong) NSArray  *lrcArray;

@property (nonatomic, assign) NSInteger  index;

@end

@implementation XXLyricsView

- (NSArray *)lrcArray
{
    if (nil == _lrcArray) {
        _lrcArray = [NSArray array];
    }
    return _lrcArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.5;
        [self addTableView];
    }
    return self;
}

- (void)addTableView
{
    UITableView *table = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    table.backgroundColor = [UIColor clearColor];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.contentInset = UIEdgeInsetsMake(self.bounds.size.height * 0.5, 0, self.bounds.size.height * 0.5, 0);
    table.delegate     = self;
    table.dataSource   = self;
    [self addSubview:table];
    self.table         = table;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lrcArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell        = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle          = UITableViewCellSelectionStyleNone;
    
    XXLyricsModel *lrcModel      = self.lrcArray[indexPath.row];
    
    cell.textLabel.text          = lrcModel.lrc;
    
    if (self.index == indexPath.row) {
        
        cell.textLabel.textColor = [UIColor greenColor];
        
        cell.textLabel.font      = CUSTOM_FONT(20);
        
    } else {
        
        cell.textLabel.textColor = [UIColor whiteColor];
        
        cell.textLabel.font      = CUSTOM_FONT(16);

    }
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;

    return cell;
}

- (void)setPlayerModel:(XXTableModel *)playerModel
{
    _playerModel          = playerModel;
    
    [[XXLyricsData shareLyrics] setLrcModel:playerModel];
    
    self.lrcArray = [XXLyricsData lrcs];
    
    [self.table reloadData];
    
}

- (void)setCurrenTime:(NSTimeInterval)currenTime
{
    if (currenTime < _currenTime) {
    
        self.index = 0;
    }

    _currenTime = currenTime;
    
    [XXLyricFind currentWithNextPLayLyircCurrentPlayTime:currenTime lyricModel:^(NSString *currentLrc, NSString *nextLrc, float scale, NSInteger index) {

        // 记录 当前播放的是哪一行
        self.index = index;
        
        [self.table reloadData];
        
        // 当前播放的歌词滚动到中间位置
        [self.table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }];
    
}

@end
