//
//  UIFont+KooTfExercise.m
//  KooTfCommonView
//
//  Created by koolearn_ws on 2021/11/22.
//

#import "UIFont+KooTfExercise.h"


@implementation UIFont (KooTfExercise)

+ (NSInteger)KooTfExerciseReadFontSize:(NSInteger)size
{
    NSArray *fontAddSizeArray = @[@"0", @"3", @"5"];
    NSInteger fontSizeIndex = [[[NSUserDefaults standardUserDefaults] valueForKey:@"KooTfExercise_read_font"] integerValue];
    
    if (fontSizeIndex >= fontAddSizeArray.count) {
        fontSizeIndex = 0;
    }
    
    NSInteger addSize = [fontAddSizeArray[fontSizeIndex] integerValue];
    size =  size + addSize;

    return size;
}

+ (NSInteger)kooTfExerciseFontSize:(NSInteger)fontSize {
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
