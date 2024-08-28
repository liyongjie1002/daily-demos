//
//  OCViewController.m
//  SwiftDemo1
//
//  Created by xdf on 2024/7/29.
//

#import "OCViewController.h"
#import <mach/mach.h>

@interface OCViewController ()

// 在视图控制器的头文件中声明属性
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, strong) UIView *myView;
@property (nonatomic, assign) CGFloat lastY;

@end

@implementation OCViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *slideView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100, 100, 100, 50)];
    slideView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:slideView];
    
    // 初始化拖动手势识别器
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [slideView addGestureRecognizer:panGesture];
    
    _panGesture = panGesture; // 保留对手势识别器的引用，以便在需要时使用
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTap)];
    [slideView addGestureRecognizer:tap];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    UIView *slideView = (UIView *)recognizer.view;
    
    CGPoint translation = [recognizer translationInView:self.view];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: {
            CGFloat minY = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
            CGFloat maxY = self.view.frame.size.height - 100;
            CGFloat targetY = slideView.center.y + translation.y;
            if (targetY < minY) {
                targetY = minY;
            }
            if (targetY > maxY) {
                targetY = maxY;
            }
            slideView.center = CGPointMake(slideView.center.x, targetY);
            [recognizer setTranslation:CGPointZero inView:self.view];
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            // 可以添加动画或其他逻辑
            break;
            
        default:
            break;
    }
}

// MARK: - tap
- (void)didClickTap {
    
    [self cpuUsage];
    
    [self memoryUsage];
}

- (uint64_t)memoryUsage {
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t result = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if (result != KERN_SUCCESS)
        return 0;
    return vmInfo.phys_footprint;
}

- (integer_t)cpuUsage {
    thread_act_array_t threads; //int 组成的数组比如 thread[1] = 5635
    mach_msg_type_number_t threadCount = 0; //mach_msg_type_number_t 是 int 类型
    const task_t thisTask = mach_task_self();
    //根据当前 task 获取所有线程
    kern_return_t kr = task_threads(thisTask, &threads, &threadCount);
    
    if (kr != KERN_SUCCESS) {
        return 0;
    }
    
    integer_t cpuUsage = 0;
    // 遍历所有线程
    for (int i = 0; i < threadCount; i++) {
        
        thread_info_data_t threadInfo;
        thread_basic_info_t threadBaseInfo;
        mach_msg_type_number_t threadInfoCount = THREAD_INFO_MAX;
        
        if (thread_info((thread_act_t)threads[i], THREAD_BASIC_INFO, (thread_info_t)threadInfo, &threadInfoCount) == KERN_SUCCESS) {
            // 获取 CPU 使用率
            threadBaseInfo = (thread_basic_info_t)threadInfo;
            if (!(threadBaseInfo->flags & TH_FLAGS_IDLE)) {
                cpuUsage += threadBaseInfo->cpu_usage;
            }
        }
    }
    assert(vm_deallocate(mach_task_self(), (vm_address_t)threads, threadCount * sizeof(thread_t)) == KERN_SUCCESS);
    return cpuUsage;
}

@end
