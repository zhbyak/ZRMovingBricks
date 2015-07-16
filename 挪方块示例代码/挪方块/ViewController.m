//
//  ViewController.m
//  挪方块
//
//  Created by 张 锐 on 15/7/1.
//  Copyright (c) 2015年 张 锐. All rights reserved.
//
#define kCOL_NUM 4
#import "ViewController.h"
#import "ZRView.h"
#import "UIView+EasyFrame.h"


@interface ViewController ()

@property(strong, nonatomic) NSArray *itemArray;

@property(strong, nonatomic) NSMutableArray *viewArray;

@property(strong, nonatomic) UIView *selectedView1;

@property(strong, nonatomic) UIView *selectedView2;

//记录当前的点
@property(nonatomic, assign) CGPoint currentPoint;

@property(nonatomic, assign) NSInteger tempTag;

@end

@implementation ViewController

/**
 *  懒加载button的名字.
 */
- (NSArray *)itemArray {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _itemArray = @[
      @"经济",
      @"体育",
      @"足球",
      @"篮球",
      @"股票",
      @"新闻",
      @"腾讯",
      @"网易",
      @"搜狐",
      @"百度",
      @"阿里",
      @"糗百",
      @"知乎",
      @"淘宝",
      @"京东",
      @"经济",
      @"体育",
      @"足球",
      @"篮球",
      @"股票",
      @"新闻",
      @"腾讯",
      @"网易",
      @"搜狐",
      @"百度",
      @"阿里",
      @"糗百",
      @"知乎",
      @"淘宝",
      @"京东"
    ];
  });
  return _itemArray;
}


//-(NSInteger)tempTag{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _tempTag = -1;
//    });
//    return _tempTag;
//}
/**
 *  懒加载数组
 */
- (NSMutableArray *)viewArray {
  if (_viewArray == nil) {
    _viewArray = [NSMutableArray array];
  }
  return _viewArray;
}

- (void)viewDidLoad {
  [super viewDidLoad];
    UIImage *backImage = [UIImage imageNamed:@"background2"];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:backImage];
  [self loadMySon];

  [self addObserver:self
         forKeyPath:@"selectedView2"
            options:NSKeyValueObservingOptionOld
            context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  NSLog(@"有用吗?");

  //这里拿到了两个选中的button.
  //传入两个button的tag 进行动画.
    UIView *oldView = [change valueForKeyPath:@"old"];
    NSLog(@"%@",oldView);
    if (oldView != self.selectedView2) {
        [self animatingViewByFirst:self.selectedView1 andView2:self.selectedView2];
    }
    
  
}

/**
 *  开场加载所有的view
 */
- (void)loadMySon {

  for (int i = 0; i < self.itemArray.count; i++) {

    ZRView *view = [[ZRView alloc] initWithName:self.itemArray[i]];
    [self.view addSubview:view];
    view.tag = i;

    view.frame = [self loactionWithTag:view.tag];

    [self.viewArray addObject:view];
  }
}

///**
// *  返回按钮响应(几乎没用)
// */
//- (IBAction)还原:(id)sender {
//
//  [self goback];
//}

///**
// *  屏幕上的返回方法(几乎没用)
// */
//- (void)goback {
//  [UIView animateWithDuration:0.5
//                   animations:^{
//                     for (UIView *view in self.viewArray) {
//                       view.frame = [self loactionWithTag:view.tag];
//                     }
//                   }];
//
//  self.selectedView1 = nil;
//  self.selectedView2 = nil;
//
//  for (UIView *view in self.view.subviews) {
//    self.viewArray[view.tag] = view;
//  }
//}

/**
 *  触摸开始 ,找到第一个view 并且让第一个view跟着自己的鼠标移动
 *
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
   
    
  UITouch *touch = touches.anyObject;

  self.currentPoint = [touch locationInView:self.view];

  for (UIView *view in self.viewArray) {
    BOOL inArea = [self pontIn:self.currentPoint view:view];
    //        BOOL inArea = [view pointInside:point withEvent:event];
    //        NSLog(@"%d",inArea);
    if (inArea) {
      self.selectedView1 = view;
      NSLog(@"第一次选中了第%@个button", @(view.tag));
    }
  }
}

/**
 *  触摸中,找到第二个view
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  if (self.selectedView1 == nil) {
    return;
  }

  UITouch *touch = touches.anyObject;
  CGPoint movedPoint =
      CGPointMake([touch locationInView:self.view].x - self.currentPoint.x,
                  [touch locationInView:self.view].y - self.currentPoint.y);

  self.currentPoint = [touch locationInView:self.view];

  self.selectedView1.transform = CGAffineTransformTranslate(
      self.selectedView1.transform, movedPoint.x, movedPoint.y);

  //找到第二个button
  for (UIView *view in self.viewArray) {
    BOOL inArea = [self pontIn:self.currentPoint view:view];
    if (inArea) {
      if (view != self.selectedView1) {
        self.selectedView2 = view;
      }
    }
  }
}

/**
 *  触摸结束
 *
 *  让第一个view归位
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  if (self.selectedView1 == nil) {
    return;
  }

  NSLog(@"ended");
  [UIView animateWithDuration:0.5
                   animations:^{
                     //给第一个view赋tag
                       
                           self.selectedView1.frame =
                           [self loactionWithTag:self.selectedView1.tag];
                       
                     
                   }];
  //归零
  self.selectedView1 = nil;
  self.selectedView2 = nil;

  //根据tag重新装填数组的元素.(重新装填view在数组中的位置)
  for (UIView *view in self.view.subviews) {
    self.viewArray[view.tag] = view;
  }
}

/**
 *  给定两个view 将两个view之间的所有view动画改变位置
 *
 */
- (void)animatingViewByFirst:(UIView *)view1 andView2:(UIView *)view2 {

  if (view1.tag == view2.tag || view2 == nil) {
    return;
  }
    //定义一个公共的数组用来存放两个view中间的view的tag
    NSMutableArray *indexes = [NSMutableArray array];
    
    if(view1.tag < view2.tag){
        NSLog(@"<<");
        //因为第二个tag后面的tag是不变位置的,所以用他的tag作为基准.
//        self.tempTag = [self.viewArray[view2.tag + 1] tag] - 1;
        self.tempTag = view2.tag;
        
        //给indexes赋值
        for (int i = (int)(view1.tag + 1); i <= (int)(view2.tag); i++) {
            [indexes addObject:@(i)];
        }
            //给view1改变tag
            view1.tag = self.tempTag;
           
            //更改各种tag,给中间的view们动画改变位置.
            for (NSNumber *num in indexes) {
                UIView *view = self.viewArray[[num intValue]];
                CGFloat oldTag = view.tag;
                CGFloat newTag = oldTag - 1;
                view.tag = newTag;
                
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     
                                     view.frame = [self loactionWithTag:view.tag];
                                     
                                 }];
            }
            
    
  
        //if语句结束

  } else if (view1.tag > view2.tag) {
      NSLog(@">>");
      
      //用第二个tag的前面一个view的tag减去1作为tempTag,因为这个view没参与变动
      self.tempTag = view2.tag;
      
      //给indexes赋值
      for (int i = (int)(view2.tag); i <= (int)(view1.tag - 1); i ++) {
          [indexes addObject:@(i)];
      }
      NSLog(@"%@",indexes);
      //给View1改变tag(最新的tag)
      view1.tag = self.tempTag;
      
      //更改各种tag,给中间的view门动画改变位置
      for (NSNumber *num in indexes) {
          UIView *view = self.viewArray[[num intValue]];
          
          CGFloat oldTag = view.tag;
          CGFloat newTag = oldTag + 1;
          view.tag = newTag;
          
          [UIView animateWithDuration:0.5 animations:^{
              view.frame = [self loactionWithTag:view.tag];
          }];
          
      }
      
  }

  return;
}

- (CGRect)loactionWithTag:(NSInteger)tag {
  CGFloat topMargin = 50;
  CGFloat space;

  CGFloat viewW = 80;
  CGFloat viewH = 40;

  CGFloat screenW = [UIScreen mainScreen].bounds.size.width;

  space = (screenW - kCOL_NUM * viewW) / (kCOL_NUM + 1);

  CGRect location;

  CGFloat row = (tag) / kCOL_NUM;
  CGFloat col = (tag) % kCOL_NUM;

  CGFloat viewX = space + col * (space + viewW);
  CGFloat viewY = topMargin + row * (space + viewH);

  location = CGRectMake(viewX, viewY, viewW, viewH);

  return location;
}

//贱人 我自己写个方法
- (BOOL)pontIn:(CGPoint)point view:(UIView *)view {
  if (((point.x >= view.x) && (point.x <= (view.x + view.width))) &&
      ((point.y >= view.y) && (point.y <= (view.y + view.height)))) {
    return YES;
  }
  return NO;
}

@end
