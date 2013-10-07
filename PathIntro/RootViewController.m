//
//  RootViewController.m
//  LoveMovie
//
//  Created by Ho Jimmy on 13/10/3.
//  Copyright (c) 2013年 Dmitry Kondratyev. All rights reserved.
//

#import "RootViewController.h"
#import "MovieViewController.h"
#import "UIImage+ImageEffects.h"

@interface RootViewController ()

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;


@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //20 temp null
    NSMutableArray *array =
        (NSMutableArray*)@[[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null]];

    self.movieList = array;
    NSUInteger numberPages = self.movieList.count;
    
    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < numberPages; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    
    
    
    
    // a page is the width of the scroll view
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize =
    CGSizeMake(CGRectGetWidth(self.scrollView.frame) * numberPages, CGRectGetHeight(self.scrollView.frame));
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    
//    self.pageControl.numberOfPages = numberPages;
//    self.pageControl.currentPage = 0;
    
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    //
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];

}

- (void)loadScrollViewWithPage:(NSUInteger)page
{
    UIStoryboard *storyboard;
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if (page >= self.movieList.count)
        return;
    
    
    // replace the placeholder if necessary
    MovieViewController *controller = [self.viewControllers objectAtIndex:page];
    
    if ((NSNull *)controller == [NSNull null])
    {
        //controller = [[MovieViewController alloc] initWithPageNumber:page];
        controller = [storyboard instantiateViewControllerWithIdentifier:@"Movie"];
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        
        [self addChildViewController:controller];
        [self.scrollView addSubview:controller.view];
        [controller didMoveToParentViewController:self];
        
        //NSDictionary *numberItem = [self.movieList objectAtIndex:page];
        controller.numberImage.image = [UIImage imageNamed:@"image1.jpg"];
        controller.numberImageWithBlur.image = [controller.numberImage.image applyLightEffect];
        controller.numberImageWithBlur.alpha = 0;
        controller.numberTitle.text = @"全家就是米家";
    }
    

}

// at the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // a possible optimization would be to unload the views+controllers which are no longer visible

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    NSLog(@"page=%i",page);
    
    MovieViewController *nowController = [self.viewControllers objectAtIndex:page];
    
    for (id temp in self.viewControllers) {
        if (temp != [NSNull null]) {
            MovieViewController *controller = temp;
            [controller.scrollView setContentOffset:CGPointMake(0, nowController.scrollView.contentOffset.y)];
        }
    }
}

- (void)gotoPage:(BOOL)animated
{
    NSInteger page = self.pageControl.currentPage;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect bounds = self.scrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = 0;
    [self.scrollView scrollRectToVisible:bounds animated:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
