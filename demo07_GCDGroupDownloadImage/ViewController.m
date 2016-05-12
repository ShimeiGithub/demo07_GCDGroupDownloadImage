//
//  ViewController.m
//  demo07_GCDGroupDownloadImage
//
//  Created by LuoShimei on 16/5/12.
//  Copyright © 2016年 罗仕镁. All rights reserved.
//
/**
 将多个下载的任务放入到队列组中进行下载
 */

#import "ViewController.h"

@interface ViewController ()
/** 显示图片的控件 */
@property(nonatomic,strong) UIImageView *imageVeiw_0;
@property(nonatomic,strong) UIImageView *imageVeiw_1;
@property(nonatomic,strong) UIImageView *imageVeiw_2;
/** 显示点击下载图片的按钮 */
@property(nonatomic,strong) UIButton *downloadButton;
@end

@implementation ViewController
/** 懒加载 */
- (UIImageView *)imageVeiw_0{
    if (_imageVeiw_0 == nil) {
        _imageVeiw_0 = [[UIImageView alloc] init];
        _imageVeiw_0.frame = CGRectMake(0, 20, self.view.bounds.size.width, 150);
        _imageVeiw_0.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        _imageVeiw_0.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageVeiw_0;
}

- (UIImageView *)imageVeiw_1{
    if (_imageVeiw_1 == nil) {
        _imageVeiw_1 = [[UIImageView alloc] init];
        _imageVeiw_1.frame = CGRectMake(0, 180, self.view.bounds.size.width, 150);
        _imageVeiw_1.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        _imageVeiw_1.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageVeiw_1;
}

- (UIImageView *)imageVeiw_2{
    if (_imageVeiw_2 == nil) {
        _imageVeiw_2 = [[UIImageView alloc] init];
        _imageVeiw_2.frame = CGRectMake(0, 340, self.view.bounds.size.width, 150);
        _imageVeiw_2.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        _imageVeiw_2.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageVeiw_2;
}

- (UIButton *)downloadButton{
    if (_downloadButton == nil) {
        _downloadButton = [[UIButton alloc] init];
        _downloadButton.frame = CGRectMake(10, 500, self.view.bounds.size.width - 20, 40);
        _downloadButton.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        [_downloadButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_downloadButton setTitle:@"下载图片" forState:UIControlStateNormal];
        
        [_downloadButton addTarget:self action:@selector(download) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadButton;
}

/** 下载操作 */
- (void)download{
    if (self.imageVeiw_0.image && self.imageVeiw_1.image && self.imageVeiw_2.image) {
        return ;
    }
    NSString *imagePath_0 = @"http://c.hiphotos.baidu.com/image/h%3D300/sign=b20b3bdf0bf3d7ca13f63976c21ebe3c/2fdda3cc7cd98d102bc070d0263fb80e7bec903e.jpg";
    NSString *imagePath_1 = @"http://h.hiphotos.baidu.com/image/h%3D300/sign=af8b2a3536adcbef1e3478069cae2e0e/cdbf6c81800a19d8c31797f434fa828ba61e462e.jpg";
    NSString *imagePath_2 = @"http://b.hiphotos.baidu.com/image/h%3D300/sign=cfc5c618082442a7b10efba5e142ad95/4d086e061d950a7b539cb25f0dd162d9f3d3c984.jpg";
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    __block UIImage *image_0 = nil;
    __block UIImage *image_1 = nil;
    __block UIImage *image_2 = nil;
    //下载图片
    dispatch_group_async(group, globalQueue, ^{
        image_0 = [self downloadImage:imagePath_0];
    });
    
    dispatch_group_async(group, globalQueue, ^{
        image_1 = [self downloadImage:imagePath_1];
    });
    
    dispatch_group_async(group, globalQueue, ^{
        image_2 = [self downloadImage:imagePath_2];
    });
    
    //刷新图片
    dispatch_group_notify(group, globalQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageVeiw_0.image = image_0;
            self.imageVeiw_1.image = image_1;
            self.imageVeiw_2.image = image_2;
        });
    });
}

/** 根据路径返回下载好的图片 */
- (UIImage *)downloadImage:(NSString *)imagePath{
    NSURL *url = [NSURL URLWithString:imagePath];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageVeiw_0];
    [self.view addSubview:self.imageVeiw_1];
    [self.view addSubview:self.imageVeiw_2];
    [self.view addSubview:self.downloadButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
