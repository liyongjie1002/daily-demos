//
//  UIColor+KooAdd.m
//
//  Created by cuibaoyin on 2018/4/10.
//  Copyright © 2018年 koolearn. All rights reserved.
//

#import "UIColor+KooAdd.h"

@implementation UIColor (KooAdd)

+ (UIColor *)colorWithHexString:(NSString *)color
{
    return [self colorWithHexString:color alpha:1];
}

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}

+ (UIColor*)koo_gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(CGFloat)height withWidth:(CGFloat)width
{
//    CGSize size = CGSizeMake(width, height);
//    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
//    
//    NSArray* colors = [NSArray arrayWithObjects:(id)c1.CGColor, (id)c2.CGColor, nil];
//    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (__bridge CFArrayRef)colors, NULL);
//    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(width, height), 0);
//    
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    
//    CGGradientRelease(gradient);
//    CGColorSpaceRelease(colorspace);
//    UIGraphicsEndImageContext();
//    
//    return [UIColor colorWithPatternImage:image];
    CGSize size = CGSizeMake(width, height);
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:size];
    UIImage *image = [renderer imageWithActions:^(UIGraphicsImageRendererContext *context) {
        CGContextRef context1 = context.CGContext;
        CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
        NSArray* colors = [NSArray arrayWithObjects:(id)c1.CGColor, (id)c2.CGColor, nil];
        CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (__bridge CFArrayRef)colors, NULL);
        CGContextDrawLinearGradient(context1, gradient, CGPointMake(0, 0), CGPointMake(width, height), 0);
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorspace);
        UIGraphicsEndImageContext();
    }];
    return [UIColor colorWithPatternImage:image];
}

+ (UIColor *)colorWithLightHexString:(NSString *)lightColor darkHexString:(NSString *)darkColor {
    if (@available(iOS 13.0, *)) {
        UIColor *color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
            if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                return [self colorWithHexString:lightColor];
            }else{
                return [self colorWithHexString:darkColor];
            }
        }];
        return color;
    } else {
        return [self colorWithHexString:lightColor];
    }
}

/// 设置设色模式颜色
/// @param lightColor 浅色模式色值
/// @param darkColor 深色模式色值
+ (UIColor *)colorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor {
    if (@available(iOS 13.0, *)) {
        UIColor *color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
            if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                return lightColor;
            }else{
                return darkColor;
            }
        }];
        return color;
    } else {
        return lightColor;
    }
}

@end
