//
//  PageHandlerViewController.m
//  AVStoryBook
//
//  Created by Nicolas Guerrero on 9/22/17.
//  Copyright © 2017 Nicolas Guerrero. All rights reserved.
//

#import "PageHandlerViewController.h"
#import "StoryPartViewController.h"

@interface PageHandlerViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (nonatomic, strong) NSMutableArray *pages;
@property (assign, nonatomic) NSUInteger pagesDeleted;
@property (assign, nonatomic) NSUInteger currentPage;
@end

@implementation PageHandlerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
    
    self.currentPage = 0;
    self.pagesDeleted = 0;
    self.pages = [@[] mutableCopy];
    
    StoryPartViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"StoryPartVC"];
    view.pageIndex = self.pages.count;
    
    [self.pages addObject:view];
    
    self.navigationItem.title = [NSString stringWithFormat:@"Page 1"];
    [self setViewControllers:@[view] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
    {
        NSInteger currentIndex = [self.pages indexOfObject:viewController];
        
        if (currentIndex + 1 >= self.pages.count)
        {
            StoryPartViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"StoryPartVC"];
            view.pageIndex = self.pages.count + self.pagesDeleted;
            [self.pages addObject:view];
        }
        
        NSInteger nextIndex = currentIndex + 1;
        self.navigationItem.title = [NSString stringWithFormat:@"Page %lu", nextIndex + 1];
        self.currentPage = nextIndex;
        return self.pages[nextIndex];
    }

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
    {
        NSInteger currentIndex = [self.pages indexOfObject:viewController];
        NSInteger prevIndex = (currentIndex - 1) % self.pages.count;
        
        self.navigationItem.title = [NSString stringWithFormat:@"Page %lu", prevIndex + 1];
        self.currentPage = prevIndex;
        return self.pages[prevIndex];
    }

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.pages.count;
}

@end
