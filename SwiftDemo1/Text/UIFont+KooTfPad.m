//
//  UIFont+KooTfIpad.m
//  AFNetworking
//
//  Created by renwanpeng on 2020/8/28.
//

#import "UIFont+KooTfPad.h"

@implementation UIFont (KooTfPad)

+ (NSInteger)ipadFontSize:(NSInteger)size {
    NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType isEqualToString:@"iPad"]) {
        return size+4;
    }
    return size;
}
+ (NSInteger)ipadFontSize2:(NSInteger)size {
    NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType isEqualToString:@"iPad"]) {
        return size+2;
    }
    return size;
    
}

//设置字体练习随着变化
+ (NSInteger)ipadExerciseFontSize:(NSInteger)fontSize {
    NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType isEqualToString:@"iPad"]) {
        fontSize = fontSize + 4;
    }
    NSString * fontStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"KooTfFontSize"];
    if ([fontStr isEqualToString:@"fontSize_normal"]) {
        fontSize = fontSize;
    }else if ([fontStr isEqualToString:@"fontSize_middle"]){
        fontSize = fontSize+3;
    }else if ([fontStr isEqualToString:@"fontSize_big"]){
        fontSize = fontSize+5;
    }
    return fontSize;
}

@end
