//
//  PageHandlerViewController.m
//  AVStoryBook
//
//  Created by Nicolas Guerrero on 9/22/17.
//  Copyright © 2017 Nicolas Guerrero. All rights reserved.
//

#import "PageHandlerViewController.h"
#import "PageData.h"

@interface PageHandlerViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (nonatomic, strong) NSArray *array;
@end

@implementation PageHandlerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    self.dataSource = self;
    
    self.array = @[[PageData new], [PageData new], [PageData new], [PageData new], [PageData new]];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
    {
        return nil;
    }

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
    {
        return nil;
    }
@end
