//
//  JLWaterfallFlowLayout.h
//  JLWaterfallFlow
//
//  Created by Jasy on 16/1/26.
//  Copyright © 2016年 Jasy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JLWaterfallFlowLayoutDelegate;
@interface JLWaterfallFlowLayout : UICollectionViewLayout
@property (nonatomic, assign) UIEdgeInsets sectionInset;
@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, assign) CGFloat itemSpacing;
@property (nonatomic, assign) CGFloat colCount;
@property (nonatomic, weak) id<JLWaterfallFlowLayoutDelegate>delegate;
@end

@protocol JLWaterfallFlowLayoutDelegate <NSObject>

@required
//item heigh
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(JLWaterfallFlowLayout*)collectionViewLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath*)indexPath;

@optional
//section header
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(JLWaterfallFlowLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
//section footer
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(JLWaterfallFlowLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;

@end