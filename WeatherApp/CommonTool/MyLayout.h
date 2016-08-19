//

//

#import <UIKit/UIKit.h>

@protocol MyLayoutDelegate <NSObject>

-(CGFloat)heightAtindexPath:(NSIndexPath *)indexPath;

@end

@interface MyLayout : UICollectionViewLayout



-(instancetype)initWithSectionInsets:(UIEdgeInsets)insets itemSpacing:(CGFloat)itemSpacing lineSpacing:(CGFloat)lineSpacing;

@property(nonatomic,weak)id <MyLayoutDelegate> delegate;

@end
