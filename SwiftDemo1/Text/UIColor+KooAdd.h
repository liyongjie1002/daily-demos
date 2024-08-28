//
//  UIColor+KooAdd.h
//
//  Created by cuibaoyin on 2018/4/10.
//  Copyright © 2018年 koolearn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (KooAdd)

+ (UIColor *)colorWithHexString:(NSString *)color;

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;


/**
 *  @brief  渐变颜色
 *  @param fromColor  开始颜色
 *  @param toColor    结束颜色
 *  @param height     渐变高度
 *  从左到右渐变 如果需要从上到下 宽高反着传值即可
 *  @return 渐变颜色
 */
+ (UIColor*)koo_gradientFromColor:(UIColor*)fromColor toColor:(UIColor*)toColor withHeight:(CGFloat)height withWidth:(CGFloat)width;

/// 设置设色模式颜色
/// @param lightColor 浅色模式色值
/// @param darkColor 深色模式色值
+ (UIColor *)colorWithLightHexString:(NSString *)lightColor darkHexString:(NSString *)darkColor;

/// 设置设色模式颜色
/// @param lightColor 浅色模式色值
/// @param darkColor 深色模式色值
+ (UIColor *)colorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor;

@end
