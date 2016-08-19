//
//

#import "MyLayout.h"

#define         COLUMN       2

@interface MyLayout ()
{
    UIEdgeInsets _insets;
    CGFloat _itemSpacing;
    CGFloat _lineSpacing;
}
@property(nonatomic,retain)NSMutableArray * attrArray;

@property(nonatomic,retain)NSMutableArray * columnArray;

@end

@implementation MyLayout

-(NSMutableArray *)attrArray
{
    if (_attrArray == nil) {
        _attrArray = [NSMutableArray array];
    }
    return _attrArray;
}

-(NSMutableArray *)columnArray
{
    if (_columnArray == nil) {
        _columnArray = [NSMutableArray array];
    }
    return _columnArray;

}
-(instancetype)initWithSectionInsets:(UIEdgeInsets)insets itemSpacing:(CGFloat)itemSpacing lineSpacing:(CGFloat)lineSpacing
{
    if (self = [super init]) {
        _insets = insets;
        _itemSpacing = itemSpacing;
        _lineSpacing = lineSpacing;
    }
    return self;
}

-(void)prepareLayout
{
    [super prepareLayout];
    [self.attrArray removeAllObjects];
    [self.columnArray removeAllObjects];
    
    for (int i = 0; i < COLUMN; i++) {
        [self.columnArray addObject:[NSNumber numberWithFloat:_insets.top]];
    }
    
    NSInteger cellCnt = [self.collectionView numberOfItemsInSection:0];
    
    CGFloat width = (self.collectionView.bounds.size.width - _insets.left - _insets.right - _itemSpacing)/COLUMN;
    
    for (int i = 0; i < cellCnt; i ++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        CGFloat height = 0;
        if ([self.delegate respondsToSelector:@selector(heightAtindexPath:)])
        {
            height = [self.delegate heightAtindexPath:indexPath];
        }
        NSInteger lowestIndex = [self lowestColumnIndex];
        
        CGFloat X = _insets.left + (width + _itemSpacing) * lowestIndex;
        
        CGFloat Y = [_columnArray[lowestIndex] floatValue];
        CGRect frame = CGRectMake(X, Y, width, height);
        
        
        UICollectionViewLayoutAttributes * attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attr.frame = frame;
        [_attrArray addObject:attr];
        _columnArray[lowestIndex] = [NSNumber numberWithFloat:Y + height +_lineSpacing ];
    }
}

-(CGFloat)lowestColumnIndex
{
    NSInteger index = -1;
    CGFloat oldHeight = CGFLOAT_MAX;
    for (int i = 0; i < self.columnArray.count; i ++) {
        NSNumber * tmpHeight = self.columnArray[i];
        if (tmpHeight.floatValue < oldHeight) {
            index = i;
            oldHeight = tmpHeight.floatValue;
            
        }
    }
    return index;

}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrArray;
}

-(CGSize)collectionViewContentSize
{
    NSInteger high = [self highestColumnIndex];
    return CGSizeMake(self.collectionView.bounds.size.width, [self.columnArray[high] floatValue]);
}
-(CGFloat)highestColumnIndex
{
    NSInteger index = -1;
    CGFloat oldHeight = CGFLOAT_MIN;
    for (int i = 0; i < self.columnArray.count; i ++) {
        NSNumber * tmpHeight = self.columnArray[i];
        if (tmpHeight.floatValue > oldHeight) {
            index = i;
            oldHeight = tmpHeight.floatValue;
            
        }
    }
    return index;
    
}


@end
