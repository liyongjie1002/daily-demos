//
//  KooTfParaseTextViewController.m
//  SwiftDemo1
//
//  Created by xdf on 2024/8/1.
//

#import "KooTfParaseTextViewController.h"
#import "KooTfStemModel.h"
#import "UIColor+KooAdd.h"
#import <WebKit/WebKit.h>

@interface KooTfParaseTextViewController ()

@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet WKWebView *webView;

@end

@implementation KooTfParaseTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)webHTML:(id)sender {
    self.webView.hidden = NO;
    self.textView.hidden = YES;
    NSString *htmlString = @"<p>阅读</p><p>观点：斯巴达克斯是英雄人物。</p><p></p><p>理由1: 斯巴达克斯战斗的目的是回乡。</p><p>理由2: 斯巴达克斯有着卓越的军事才能。</p><p>理由3: 斯巴达克斯希望能解放罗马帝国的奴隶。</p><p></p><p>听力</p><p>观点：斯巴达克斯并不是英雄人物，很多依据也并不准确。</p><p></p><p>反驳1: 斯巴达克斯战斗也是为了复仇和掠夺。</p><p>反驳2: 斯巴达克斯能打胜仗是因为一开始罗马军队没有重视。</p><p>反驳3: 斯巴达克斯解放奴隶是文艺作品中虚构的情节。</p><p></p><p>写作</p><p>需要写明阅读要点及听力的要点和细节，并体现出听力对阅读的反驳。</p><ol><li>咖啡</li><li>茶</li><li>牛奶</li><li>纯水</li><li>果汁</li><li>啤酒</li></ol><p>需要写明阅读要点及听力的要点和细节，并体现出听力对阅读的反驳。</p><ul><li>列表项1</li><li>列表项2</li><li>列表项3</li></ul><p>结尾</p>";
//    // 将HTML字符串转换为富文本
//    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//    // 将富文本设置到label
//    self.textView.attributedText = attributedText;
    
    [self.webView loadHTMLString:htmlString baseURL:nil];

}
    
- (IBAction)paraseHTML:(id)sender {
    self.webView.hidden = YES;
    self.textView.hidden = NO;
    
    NSString *outline = @"<ul><li> 开头：我认两者都有必要支持。</li><li>论证</li><li> 结尾：我认为两者都有必要支持。</li></ul><p></p><p><strong>题目理解</strong></p><p>政府应该花更多的钱去普及互联网，而不是提高公共交通。你是否同意这个说法。</p><p>注意：这个题目存在互联网和公共交通的对比，如果觉得比较难想观点，无论支持互联网还是支持公共交通，都想不到两个以上的观点，可以认为两者都有必要支持。 </p><p></p><p><strong>文章框架</strong></p><ul><li> 开头：我认两者都有必要支持。</li><li> 论证段1：互联网的普及很重要，方便人们的生活，但是目前还没有完全普及。</li><li> 论证段2：支持公共交通很重要，好的交通让人们工作学习效率提高，但是目前交通状况很不好。</li><li> 结尾：我认为两者都有必要支持。</li></ul>";
//    NSString *outline = @"<h3>阅读--标题3</h3><p>观点：斯巴达克斯是|英雄人\\物。</p><p></p><ol><li>理由1: &quot;斯巴达克斯战斗的目的是回/乡&quot;。</li><li>理由2: &#x27;斯巴达克斯有着卓越的军事才@#$%^&amp;能&#x27;。</li><li>理由3: “斯巴达克斯希望能解放罗马帝国的奴隶”。</li><li>‘斯巴达克斯希望能解放罗马帝国的奴隶’</li><li>！！@#￥%……&amp;*（）——|」「POIUY“LL：？《》、。，、‘；【、】~！@&lt;&gt;&lt;&gt;?:&quot;:&quot;P{!@#$~%^&amp;&amp;*()_+=</li></ol><p></p><p><strong>听力--加粗</strong></p><p>观点：斯巴达克斯并不是英雄人物，很多依据也并不准确。</p><p></p><ul><li>反驳1: 斯巴达克斯战斗也是为了复仇和掠夺。</li><li>反驳2: 斯巴达克斯能打胜仗是因为一开始罗马军队没有重视。</li><li>反驳3: 斯巴达克斯解放奴隶是文艺作品中虚构的情节。</li></ul><p></p><p><strong>写作--加粗</strong></p><p>需要写明阅读要点及听力的要点和细节，并体现出听力对阅读的反驳。</p><p></p><p></p><p></p><p style=\"text-align:center;\">居中-需要写明阅读要点及听力的要点和细节，并体现出听力对阅读的反驳。</p><p></p><p style=\"text-align:right;\">居右-需要写明阅读要点及听力的要点和细节，并体现出听力对阅读的反驳。</p><p style=\"text-align:right;\">居右-需要写明阅读要点及听力的要点和细节，并体现出听力对阅读的反驳。</p><p style=\"text-align:right;\">居右-需要写明阅读要点及听力的要点和细节，并体现出听力对阅读的反驳。</p><p></p><p style=\"text-align:justify;\">两端对齐-斯巴达克斯解放奴隶是文艺作品中虚构的情节。斯巴达克斯解放奴隶是文艺作品中虚构的情节。斯巴达克斯解放奴隶是文艺作品中虚构的情节。斯巴达克斯解放奴隶是文艺作品中虚构的情节。斯巴达克斯解放奴隶是文艺作品中虚构的情节。斯巴达克斯解放奴隶是文艺作品中虚构的情节。斯巴达克斯解放奴隶是文艺作品中虚构的情节。斯巴达克斯解放奴隶是文艺作品中虚构的情节。斯巴达克斯解放奴隶是文艺作品中虚构的情节。斯巴达克斯解放奴隶是文艺作品中虚构的情节。</p>";
    KooTfStemModel *stem = [[KooTfStemModel alloc] initWithStringValue:outline fontSize:15];
    NSMutableAttributedString *attri = stem.attributedString.mutableCopy;
    
    UIColor *fontColor = [UIColor colorWithLightColor:[UIColor colorWithHexString:@"#20284F"] darkColor:[UIColor colorWithHexString:@"#F2F8FF"]];
    [attri addAttribute:NSForegroundColorAttributeName value:fontColor range:NSMakeRange(0, attri.length - 1)];
    self.textView.attributedText = attri;
}

@end
