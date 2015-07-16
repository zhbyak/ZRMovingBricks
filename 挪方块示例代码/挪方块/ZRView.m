//
//  ZRView.m
//  挪方块
//
//  Created by 张 锐 on 15/7/1.
//  Copyright (c) 2015年 张 锐. All rights reserved.
//

#import "ZRView.h"
#import "UIView+EasyFrame.h"


@interface ZRView ()

@property (weak, nonatomic) IBOutlet UILabel *nameLable;




@end

@implementation ZRView

-(instancetype)initWithName:(NSString *)name{
    ZRView *view = [[[NSBundle mainBundle] loadNibNamed:@"ZRView" owner:nil options:nil] lastObject];
    
    view.nameLable.text = name;
    
    //这句话太JB重要了,强制获得frame
    [view layoutIfNeeded];
    view.layer.cornerRadius = view.height * 0.5;
    view.layer.masksToBounds = YES;
//    view.backgroundColor = [UIColor redColor];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button1"]];
    
    
    
    
    
    
    return view;
}




@end
