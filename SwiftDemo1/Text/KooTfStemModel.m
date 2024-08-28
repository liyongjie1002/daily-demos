//
//  KooTfStemModel.m
//  AFNetworking
//
//  Created by renwanpeng on 2020/6/3.
//

#import "KooTfStemModel.h"

#import "UIColor+KooAdd.h"
#import "UIFont+KooTfExercise.h"
#import "UIFont+KooTfPad.h"


@implementation KooTfStemModel
-(instancetype)initWithStringValue:(NSString *)stringValue{
    return [self initWithStringValue:stringValue fontSize:16];
}

- (instancetype)initWithStringValue:(NSString *)stringValue fontSize:(CGFloat)fontSize{
    self = [super init];
    // 423新增，替换<p></p>（空标签会在下方多带一个换行\n，替换为&423wrap，自定义换行的高度）
    stringValue = [stringValue stringByReplacingOccurrencesOfString:@"\n" withString:@"<p></p>"];
    stringValue = [stringValue stringByReplacingOccurrencesOfString:@"<p></p>" withString:@"&423wrap"];
    // 特殊字符表，替换成相应字符
    stringValue = [stringValue stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    stringValue = [stringValue stringByReplacingOccurrencesOfString:@"&#x27;" withString:@"'"];
    stringValue = [stringValue stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    stringValue = [stringValue stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    stringValue = [stringValue stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    
    if (self) {
        fontSize = [UIFont ipadExerciseFontSize:fontSize];
        NSInteger index = 0;
        NSMutableArray *pArray = [NSMutableArray array];
        while (true) {
            NSRange range = [[stringValue substringWithRange:NSMakeRange(index, stringValue.length-index)] rangeOfString:@"<p.*?>.*?</p>" options:NSRegularExpressionSearch];
            if (range.location == NSNotFound) {
                [pArray addObject:[stringValue substringWithRange:NSMakeRange(index, stringValue.length-index)]];
                break;
            }
            [pArray addObject:[stringValue substringWithRange:NSMakeRange(index, range.location)]];
            range = NSMakeRange(range.location+index, range.length);
            [pArray addObject:[stringValue substringWithRange:range]];
            index = range.length + range.location;
            if (stringValue.length == index) {
                break;
            }
        }
        NSMutableString *ms = [NSMutableString string];
        for (NSInteger i=0; i<pArray.count; i++) {
            NSString *str = pArray[i];
            if ([str stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
                continue;
            }
            [ms appendString:pArray[i]];
            if (i != pArray.count-1) {
                [ms appendString:@"<br>"];
            }
        }
        _stringValue = ms.copy;
        
        _stringValue = [NSString stringWithFormat:@"<p>%@</p>", [_stringValue stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "]];
        _stringValue = [_stringValue stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        _stringValue = [_stringValue stringByReplacingOccurrencesOfString:@"</br>" withString:@"\n"];
        _stringValue = [_stringValue stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
        _stringValue = [_stringValue stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        
        // 423新增，替换标签ol和ul内的列表内容
        [self replaceRegex:@"ol"];
        [self replaceRegex:@"ul"];
        
         [self reFormatWithInsertsReplaceString:@"■" insertString:@"" insertTag:nil highlight:@"[#highlight0]" fontSize:fontSize];
    }
    return self;
}

- (void)reFormatWithInsertsReplaceString:(NSString *)insertsReplaceString
                            insertString:(NSString *)insertString
                               insertTag:(NSString *)insertTag
                               highlight:(NSString *)highlight
                                fontSize:(CGFloat)fontSize{
    
    NSString *html = self.stringValue;
    
    NSMutableArray *paragraghs = [NSMutableArray array];
    NSMutableArray *stackTag = [NSMutableArray array];
    NSMutableArray *stackIndex = [NSMutableArray array];
    NSMutableArray *richs = [NSMutableArray array];
    NSMutableArray *highlightsLocation = [NSMutableArray array];
    NSMutableArray *insertsLocation = [NSMutableArray array];
    NSMutableString *ms = [NSMutableString string];
    
    while(true) {
        NSRange range = [self rangeWithNextTag:html];

        if (range.location != NSNotFound) {

            NSString *tag = [html substringWithRange:range];
            
            NSInteger location = ms.length + range.location;
            
            [ms appendString:[html substringWithRange:NSMakeRange(0, range.location)]];
            
            html = [html substringWithRange:NSMakeRange(range.location+range.length, html.length-(range.location+range.length))];
            
            if ([tag containsString:@"paragraph"]) {
                [paragraghs addObject:tag];
                continue;
            }
            
            if ([tag containsString:@"br"]) {
                continue;
            }
            
            if ([tag containsString:@"highlight"]) {
                [highlightsLocation addObject:@{@"tag":tag, @"location":@(location)}];
                continue;
            }
            
            if ([tag containsString:@"insert"]) {
                if (!insertTag) {
                    [insertsLocation addObject:@{@"tag":tag, @"location":@(location+insertsReplaceString.length)}];
                    [ms appendString:insertsReplaceString];
                } else {
                    if ([insertTag isEqualToString:tag]) {
                        [insertsLocation addObject:@{@"tag":tag, @"location":@(location+insertString.length)}];
                        [ms appendString:insertString];
                        [richs addObject:@{@"tag":@"green", @"range":[NSValue valueWithRange:NSMakeRange(location, insertString.length)]}];
                    } else {
                        [insertsLocation addObject:@{@"tag":tag, @"location":@(location+insertsReplaceString.length)}];
                        [ms appendString:insertsReplaceString];
                    }
                }
                continue;
            }
            
            if ([self isPairWithTag1:stackTag.lastObject tag2:tag]) {
                NSInteger location2 = [stackIndex.lastObject integerValue];
                NSInteger len = location - location2;
                
                if (len > 0) {
                    [richs addObject:@{@"tag":stackTag.lastObject, @"range":[NSValue valueWithRange:NSMakeRange(location2, len)]}];
                }
                
                [stackTag removeLastObject];
                [stackIndex removeLastObject];
            } else {
                [stackTag addObject:tag];
                [stackIndex addObject:@(location)];
            }

        } else {
            [ms appendString:html];
            break;
        }
    }
    
    _string = ms.copy;
    
    NSMutableArray *inserts = [NSMutableArray array];
    for (NSInteger index=0; index<insertsLocation.count; index++) {
        
        NSDictionary *dic = insertsLocation[index];
        NSString *tag = dic[@"tag"];
        [inserts addObject:tag];
    }
    
    NSMutableArray *highlights = [NSMutableArray array];
    NSMutableArray *usehighlightsTag = [NSMutableArray array];
    
    for (NSDictionary *dic in highlightsLocation) {
        if ([usehighlightsTag containsObject:dic]) {
            continue;
        }
        
        [usehighlightsTag addObject:dic];
        
        NSString *tag = dic[@"tag"];
        NSInteger location = [dic[@"location"] integerValue];
        if ([tag containsString:@"/"]) {
            tag = [tag stringByReplacingOccurrencesOfString:@"/" withString:@"#"];
            [highlights addObject:tag];
            [richs addObject:@{@"tag":tag, @"range":[NSValue valueWithRange:NSMakeRange(0, location)]}];
        }
        
        BOOL success = NO;
        for (NSDictionary *dic2 in highlightsLocation) {
            if ([usehighlightsTag containsObject:dic2]) {
                continue;
            }
            NSString *tag2 = dic2[@"tag"];
            if ([tag2 containsString:@"/"]) {
                tag2 = [tag2 stringByReplacingOccurrencesOfString:@"/" withString:@"#"];
                if ([tag isEqualToString:tag2]) {
                    [usehighlightsTag addObject:dic2];
                    NSInteger location2 = [dic2[@"location"] integerValue];
                    [highlights addObject:tag];
                    [richs addObject:@{@"tag":tag, @"range":[NSValue valueWithRange:NSMakeRange(location, location2-location)]}];
                    success = YES;
                    break;
                }
            }
        }
        
        if (!success) {
            [highlights addObject:tag];
            [richs addObject:@{@"tag":tag, @"range":[NSValue valueWithRange:NSMakeRange(location, self.string.length-location)]}];
        }
    }
    
    UIColor *fontColor = [UIColor colorWithLightColor:[UIColor colorWithHexString:@"#20284F"] darkColor:[UIColor colorWithHexString:@"#F2F8FF"]];
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_string];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                 value:paragraphStyle
                 range:NSMakeRange(0, _string.length)];
    
    for (NSDictionary *dic in richs) {
        NSRange range = [dic[@"range"] rangeValue];
        NSString *tag = dic[@"tag"];

        if (highlight) {
            if ([tag isEqualToString:highlight]) {
                [attributedString addAttribute:NSBackgroundColorAttributeName
                             value:[UIColor colorWithLightColor:[UIColor colorWithRed:229/255.0 green:236/255.0 blue:249/255.0 alpha:1.0] darkColor:[UIColor colorWithHexString:@"#374060"]]
                             range:range];
            }
        }
        
        if ([tag containsString:@"span"]) {
            [attributedString addAttribute:NSFontAttributeName
                         value:font
                         range:range];
        }
        
        if ([tag containsString:@"p"]) {
            [attributedString addAttribute:NSFontAttributeName
                         value:[UIFont systemFontOfSize:fontSize]
                         range:range];
            
            [attributedString addAttribute:NSForegroundColorAttributeName
                         value:fontColor
                         range:range];
        }
    }
    
    for (NSDictionary *dic in richs) {
        NSRange range = [dic[@"range"] rangeValue];
        NSString *tag = dic[@"tag"];
        
        if ([tag containsString:@"em"] || [tag containsString:@"<i>"] || [tag containsString:@"</i>"]) {
            CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(10 * (CGFloat)M_PI / 180), 1, 0, 0);
            UIFontDescriptor *desc = [UIFontDescriptor fontDescriptorWithName:[UIFont systemFontOfSize:fontSize].fontName matrix:matrix];
            [attributedString addAttribute:NSFontAttributeName
                         value:[UIFont fontWithDescriptor:desc size:fontSize]
                         range:range];
        }
        
        if ([tag containsString:@"strong"] || [tag containsString:@"b"]) {
            [attributedString addAttribute:NSFontAttributeName
                         value:[UIFont boldSystemFontOfSize:fontSize]
                         range:range];
        }
        
        if ([tag containsString:@"<u"]) { // 下划线<u>
            [attributedString addAttribute:NSUnderlineStyleAttributeName
                                     value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                                     range:range];
        }
        
        if ([tag containsString:@"green"]) {
            [attributedString addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithRed:95/255.0 green:192/255.0 blue:184/255.0 alpha:1.0]
                         range:range];

            [attributedString addAttribute:NSFontAttributeName
                                     value:[UIFont boldSystemFontOfSize:fontSize]
                                     range:range];
        }
        
        if ([tag containsString:@"font"]) {
            UIColor *color = [self getColorWithFontTag:tag];
            if (color) {
                [attributedString addAttribute:NSForegroundColorAttributeName
                                         value:color
                                         range:range];
            }
        }
        
        if ([tag containsString:@"<h"]) {
            [attributedString addAttribute:NSFontAttributeName
                                     value:[UIFont boldSystemFontOfSize:fontSize]
                                     range:range];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setAlignment:NSTextAlignmentLeft];
            [paragraphStyle setLineSpacing:8];
            [attributedString addAttribute:NSParagraphStyleAttributeName
                                     value:paragraphStyle
                                     range:range];
        }
    }
    
    // 423新增，替换为&423wrap，自定义换行的高度
    while (true) {
        NSRange range = [attributedString.string rangeOfString:@"&423wrap" options:NSRegularExpressionSearch];
        if (range.location == NSNotFound) {
            break;
        }
        CGFloat fontSize = 7;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.minimumLineHeight = fontSize; // 设置最小行高
        paragraphStyle.maximumLineHeight = fontSize; // 设置最大行高
        paragraphStyle.lineHeightMultiple = 1.0; // 设置行间距的倍数
        NSAttributedString *tmpAttr = [[NSAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName: paragraphStyle}];
        [attributedString replaceCharactersInRange:range withAttributedString:tmpAttr];
    }
    
    _attributedString = attributedString.copy;
}

- (UIColor *)getColorWithFontTag:(NSString *)fontTag {
    
    NSRange range = [fontTag rangeOfString:@"\"\\#.*?\"" options:NSRegularExpressionSearch];;
    if (range.location != NSNotFound && range.length > 2) {
        NSString *color = [fontTag substringWithRange:NSMakeRange(range.location+1, range.length-2)];
        return [UIColor colorWithHexString:color];
    }
    
    return nil;
}

- (NSRange)rangeWithNextTag:(NSString *)html {
    
    NSMutableArray *regexs = [NSMutableArray array];
    [regexs addObject:@"<p.*?>"];
    [regexs addObject:@"<br>"];
    [regexs addObject:@"</p>"];
    [regexs addObject:@"<em.*?>"];
    [regexs addObject:@"</em>"];
    [regexs addObject:@"<font.*?>"];
    [regexs addObject:@"</font>"];
    [regexs addObject:@"<h[0-9]+.*?>"];
    [regexs addObject:@"</h[0-9]+>"];
    [regexs addObject:@"<i.*?>"];
    [regexs addObject:@"</i>"];
    [regexs addObject:@"<u.*?>"];
    [regexs addObject:@"</u>"];
    [regexs addObject:@"<strong.*?>"];
    [regexs addObject:@"</strong>"];
    [regexs addObject:@"<span.*?>"];
    [regexs addObject:@"</span>"];
    [regexs addObject:@"\\[#highlight[0-9]+\\]"];
    [regexs addObject:@"\\[/highlight[0-9]+\\]"];
    [regexs addObject:@"<b.*?>"];
    [regexs addObject:@"</b>"];
    [regexs addObject:@"\\[#paragraph[0-9]+\\]"];
    [regexs addObject:@"\\[#insert[0-9]+\\]"];
    
    NSMutableString *regex = [NSMutableString string];
    for (NSInteger i=0; i<regexs.count; i++) {
        if (i == 0) {
            [regex appendString:regexs[i]];
        } else {
            [regex appendString:@"|"];
            [regex appendString:regexs[i]];
        }
    }
    
    NSRange range = [html rangeOfString:regex options:NSRegularExpressionSearch];
    return range;
}

- (BOOL)isPairWithTag1:(NSString *)tag1 tag2:(NSString *)tag2 {
    if (![tag2 containsString:@"/"]) {
        return NO;
    }
    
    NSString *tag11 = [self tagWithTag:tag1];
    NSString *tag22 = [self tagWithTag:tag2];
    
    return [tag11 isEqualToString:tag22];
}

- (NSString *)tagWithTag:(NSString *)tag {
    if ([tag containsString:@"strong"]) {
        return @"strong";
    }
    if ([tag containsString:@"em"]) {
        return @"em";
    }
    if ([tag containsString:@"highlight"]) {
        return @"highlight";
    }
    if ([tag containsString:@"span"]) {
        return @"span";
    }
    if ([tag containsString:@"p"]) {
        return @"p";
    }
    if ([tag containsString:@"u"]) {
        return @"u";
    }
    if ([tag containsString:@"<h"] || [tag containsString:@"</h"]) {
        return @"h";
    }
    return @"";
}

// 423新增，替换标签ol和ul内的列表内容
- (void)replaceRegex:(NSString *)regex {
    // while循环查找ol、ul内的内容
    NSInteger index = 0;
    while (true) {
        NSString *pattern = [NSString stringWithFormat:@"<%@>(.*?)</%@>", regex, regex];
        NSRange range = [[_stringValue substringWithRange:NSMakeRange(index, _stringValue.length-index)] rangeOfString:pattern options:NSRegularExpressionSearch];
        if (range.location == NSNotFound) {
            break;
        }
        range = NSMakeRange(range.location+index, range.length);
        // 指定ul/ol范围的content
        NSString *oldContent = [_stringValue substringWithRange:range];
        NSError *error = nil;
        // 使用正则表达式提取 <li> 标签中的内容
        NSRegularExpression *liRegex = [NSRegularExpression regularExpressionWithPattern:@"<li>(.*?)</li>" options:0 error:&error];
        NSArray *liMatches = [liRegex matchesInString:oldContent options:0 range:NSMakeRange(0, [oldContent length])];
        // 为每个 <li> 标签内容添加序号/无序
        NSMutableString *resultString = [NSMutableString string];
        for (NSInteger i = 0; i < liMatches.count; i++) {
            NSTextCheckingResult *liMatch = liMatches[i];
            NSRange liRange = [liMatch rangeAtIndex:1];
            NSString *liContent = [oldContent substringWithRange:liRange];
            if ([regex isEqualToString:@"ol"]) {
                if (i == 0) {  // 第一行
                    NSInteger tmpIndex = range.location - 8;
                    if (tmpIndex >= 0) {
                        NSRange tmpRange = NSMakeRange(tmpIndex, 8); // 看看ol前面有没有自定义换行符&423wrap
                        NSString *tmpString = [_stringValue substringWithRange:tmpRange];
                        if ([tmpString containsString:@"&423wrap"]) {
                            [resultString appendFormat:@"\n%ld. %@\n", i + 1, liContent];
                        } else {
                            [resultString appendFormat:@"%ld. %@\n", i + 1, liContent];
                        }
                    } else {
                        [resultString appendFormat:@"%ld. %@\n", i + 1, liContent];
                    }
                } else if (i == liMatches.count - 1) { // 最后一行
                    NSInteger tmpIndex = range.location + range.length;
                    if (tmpIndex < _stringValue.length - 8) {
                        NSRange tmpRange = NSMakeRange(tmpIndex, 8); // 看看ol后边有没有自定义换行符&423wrap
                        NSString *tmpString = [_stringValue substringWithRange:tmpRange];
                        if ([tmpString containsString:@"&423wrap"]) {
                            [resultString appendFormat:@"%ld. %@\n", i + 1, liContent];
                        } else {
                            [resultString appendFormat:@"%ld. %@", i + 1, liContent];
                        }
                    } else {
                        [resultString appendFormat:@"%ld. %@\n", i + 1, liContent];
                    }
                } else { // 中间行
                    [resultString appendFormat:@"%ld. %@\n", i + 1, liContent];
                }
            } else if ([regex isEqualToString:@"ul"]) {
                if (i == 0) {  // 第一行
                    NSInteger tmpIndex = range.location - 8;
                    if (tmpIndex >= 0) {
                        NSRange tmpRange = NSMakeRange(tmpIndex, 8); // 看看ol前面有没有自定义换行符&423wrap
                        NSString *tmpString = [_stringValue substringWithRange:tmpRange];
                        if ([tmpString containsString:@"&423wrap"]) {
                            [resultString appendFormat:@"\n• %@\n", liContent];
                        } else {
                            [resultString appendFormat:@"• %@\n", liContent];
                        }
                    } else {
                        [resultString appendFormat:@"• %@\n", liContent];
                    }
                } else if (i == liMatches.count - 1) { // 最后一行
                    NSInteger tmpIndex = range.location + range.length;
                    if (tmpIndex < _stringValue.length - 8) {
                        NSRange tmpRange = NSMakeRange(tmpIndex, 8); // 看看ol后边有没有自定义换行符&423wrap
                        NSString *tmpString = [_stringValue substringWithRange:tmpRange];
                        if ([tmpString containsString:@"&423wrap"]) {
                            [resultString appendFormat:@"• %@\n", liContent];
                        } else {
                            [resultString appendFormat:@"• %@", liContent];
                        }
                    } else {
                        [resultString appendFormat:@"• %@\n", liContent];
                    }
                } else { // 中间行
                    [resultString appendFormat:@"• %@\n", liContent];
                }
            }
        }
        // 将结果字符串插入到原始字符串的相应位置
        NSString *targetString = [NSString stringWithFormat:@"%@", oldContent];
        NSString *finalString = [_stringValue stringByReplacingOccurrencesOfString:targetString withString:resultString];
        _stringValue = [[NSMutableString alloc] initWithString:finalString];
        // 继续走
        index = range.length + range.location;
        if (index >= _stringValue.length) {
            break;
        }
    }
}

@end
