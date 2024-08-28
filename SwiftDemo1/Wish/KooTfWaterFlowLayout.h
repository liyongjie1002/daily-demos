//
//  KooTfWaterFlowLayout.h
//  collectionView
//
//  Created by liyaqin on 2023/12/5.

#import <UIKit/UIKit.h>


typedef enum {
    KooTfWaterFlowVerticalEqualWidth = 0, /** 竖向瀑布流 item等宽不等高 */
    KooTfWaterFlowHorizontalEqualHeight = 1, /** 水平瀑布流 item等高不等宽 不支持头脚视图*/
    KooTfWaterFlowVerticalEqualHeight = 2,  /** 竖向瀑布流 item等高不等宽 */
    KooTfWaterFlowHorizontalGrid = 3,  /** 特为国务院客户端原创栏目滑块样式定制-水平栅格布局  仅供学习交流*/
    KooTfLineWaterFlow = 4, /** 线性布局 待完成，敬请期待 */
    KooTfWaterFlowVerticalEqualWidthLeftFirst = 5 /** 最后一个如果是奇数放到左侧开始布局 */
} KooTfWaterFlowLayoutStyle; //样式

@class KooTfWaterFlowLayout;

@protocol KooTfWaterFlowLayoutDelegate <NSObject>

/**
 返回item的大小
 注意：根据当前的瀑布流样式需知的事项：
 当样式为KooTfWaterFlowVerticalEqualWidth 传入的size.width无效 ，所以可以是任意值，因为内部会根据样式自己计算布局
 KooTfWaterFlowHorizontalEqualHeight 传入的size.height无效 ，所以可以是任意值 ，因为内部会根据样式自己计算布局
 KooTfWaterFlowHorizontalGrid   传入的size宽高都有效， 此时返回列数、行数的代理方法无效，
 KooTfWaterFlowVerticalEqualHeight 传入的size宽高都有效， 此时返回列数、行数的代理方法无效
 */
- (CGSize)waterFlowLayout:(KooTfWaterFlowLayout *_Nonnull)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *_Nonnull)indexPath;

/** 头视图Size */
-(CGSize )waterFlowLayout:(KooTfWaterFlowLayout *_Nonnull)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section;
/** 脚视图Size */
-(CGSize )waterFlowLayout:(KooTfWaterFlowLayout *_Nonnull)waterFlowLayout sizeForFooterViewInSection:(NSInteger)section;

@optional //以下都有默认值
/** 列数*/
-(CGFloat)columnCountInWaterFlowLayout:(KooTfWaterFlowLayout *_Nonnull)waterFlowLayout;
/** 行数*/
-(CGFloat)rowCountInWaterFlowLayout:(KooTfWaterFlowLayout *_Nonnull)waterFlowLayout;

/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(KooTfWaterFlowLayout *_Nonnull)waterFlowLayout section:(NSInteger)section;

/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(KooTfWaterFlowLayout *_Nonnull)waterFlowLayout section:(NSInteger)section;

/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(KooTfWaterFlowLayout *_Nonnull)waterFlowLayout;


@end

@interface KooTfWaterFlowLayout : UICollectionViewLayout

/** delegate*/
@property (nonatomic, weak, nullable) id<KooTfWaterFlowLayoutDelegate> delegate;
/** 瀑布流样式*/
@property (nonatomic, assign) KooTfWaterFlowLayoutStyle  flowLayoutStyle;

/// 左侧优先排序
@property (nonatomic, assign) BOOL enableLeftFirst;

@end
