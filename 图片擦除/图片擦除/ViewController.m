//
//  ViewController.m
//  图片擦除
//
//  Created by 赵鹏 on 2019/1/2.
//  Copyright © 2019 赵鹏. All rights reserved.
//

/**
 在storyboard文件中，在视图控制器的View上添加上下两个UIImageView控件，下面的UIImageView控件存放完全擦除之后的图片，上面的UIImageView控件存放擦除之前的图片；
 当用户点击上面的UIImageView控件中的某个点的时候，以这个点为中心，往四周扩大，会形成一个矩形，然后整个矩形被擦除掉，最后这个矩形的部分就变为透明了，就能露出下面的UIImageView控件里面的图片了，从而达到了图片擦除的效果。
 */
#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *aboveImageView;  //上面的UIImageView控件

@end

@implementation ViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //添加拖拽手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    
    [self.view addGestureRecognizer:pan];
}

#pragma mark ————— 拖拽方法 —————
- (void)pan:(UIPanGestureRecognizer *)pan
{
    //获取当前触摸点的位置
    CGPoint currentPoint = [pan locationInView:self.view];
    
    //获取将要擦除的矩形的位置
    CGFloat wh = 100;  //矩形的宽和高
    CGFloat x = currentPoint.x - wh * 0.5;
    CGFloat y = currentPoint.y - wh * 0.5;
    
    CGRect rect = CGRectMake(x, y, wh, wh);
    
    /**
     1、创建一个与上面的UIImageView控件大小相同的基于位图(bitmap)的图形上下文：可以把图形上下文看成是一个画板，以后所绘制的内容都画在这个画板上。
     size参数：图形上下文的尺寸；
     opaque参数：不透明度（YES：不透明；NO：透明）；
     scale参数：缩放比例。
     */
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0);
    
    /**
     2、获取图形上下文：
     */
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    /**
     3、把上面的UIImageView控件的图层渲染到图形上下文中：
     图层(layer)只能渲染，不能绘制。
     */
    [self.aboveImageView.layer renderInContext:ctx];
    
    /**
     4、擦除图片中相应位置上的图片：
     擦除掉的部分就会变为透明，就能露出下面的UIImageView控件里面的图片了，从而达到了图片擦除的效果。
     */
    CGContextClearRect(ctx, rect);
    
    /**
     5、从图形上下文中取出擦除好的图片：
     */
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    /**
     6、把擦除好的图片显示在UIImageView控件上：
     */
    self.aboveImageView.image = image;
    
    /**
     7、关闭图形上下文：
     */
    UIGraphicsEndImageContext();
}

@end
