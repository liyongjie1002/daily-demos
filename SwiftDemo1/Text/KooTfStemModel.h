//
//  KooTfStemModel.h
//  AFNetworking
//
//  Created by renwanpeng on 2020/6/3.
//

#import <Foundation/Foundation.h>

/// 题干带上了html，转为attributestring
@interface KooTfStemModel : NSObject

- (instancetype)initWithStringValue:(NSString *)stringValue;

- (instancetype)initWithStringValue:(NSString *)stringValue fontSize:(CGFloat)fontSize;

/// 包含html的字符串
@property (copy, nonatomic, readonly) NSString *stringValue;

/// 不包含html的字符串
@property (copy, nonatomic, readonly) NSString *string;

/// 转换后的
@property (strong, nonatomic, readonly) NSAttributedString *attributedString;

@end

