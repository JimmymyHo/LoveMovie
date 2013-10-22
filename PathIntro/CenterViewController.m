//
//  CenterViewController.m
//  LoveMovie
//
//  Created by Ho Jimmy on 13/10/3.
//  Copyright (c) 2013年 Dmitry Kondratyev. All rights reserved.
//

#import "CenterViewController.h"
#import "MovieViewController.h"
#import "UIImage+ImageEffects.h"

@interface CenterViewController ()

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;


@end

@implementation CenterViewController

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
    
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
//    [self loadScrollViewWithPage:0];
//    [self loadScrollViewWithPage:1];
//    [self loadScrollViewWithPage:2];
    for (int i=0; i<20; i++) {
        [self loadScrollViewWithPage:i];
    }

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
        controller.page = page;
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
        controller.numberImage.image = [UIImage imageNamed:@"image2.jpg"];
        //controller.numberImageWithBlur.image = [controller.numberImage.image applyLightEffect];
        controller.numberImageWithBlur.alpha = 0;
        controller.numberTitle.text = @"全家就是米家";
    }
    NSLog(@"load one view success");

}

- (void)unloadScrollVieweWithPage:(NSInteger)page {
//    if (page < 0 || page >= self.movieList.count) {
//        // If it's outside the range of what we have to display, then do nothing
//        return;
//    }
//    
//    // Remove a page from the scroll view and reset the container array
//    MovieViewController *pageView = [self.viewControllers objectAtIndex:page];
//    if ((NSNull*)pageView != [NSNull null]) {
//        [pageView.view removeFromSuperview];
//        [pageView removeFromParentViewController];
//        [self.viewControllers replaceObjectAtIndex:page withObject:[NSNull null]];
//    }
}
int jimmy;
// at the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;

    // Work out which pages we want to load
    NSInteger firstPage = page - 3;
    NSInteger lastPage = page + 3;
    if (firstPage < 0) {
        firstPage = 0;
    }
    if (lastPage > 20) {
        lastPage = 20;
    }
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self unloadScrollVieweWithPage:i];
    }
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadScrollViewWithPage:i];
    }
    for (NSInteger i=lastPage+1; i<self.movieList.count; i++) {
        [self unloadScrollVieweWithPage:i];
    }
    // a possible optimization would be to unload the views+controllers which are no longer visible
    for (int i=0; i<20; i++) {
        if ([self.viewControllers objectAtIndex:i] != [NSNull null]) {
            jimmy++;

        }
    }
    NSLog(@"jimmy=%i",jimmy);
    jimmy = 0;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    NSLog(@"page=%i",page);
    
    MovieViewController *nowController = [self.viewControllers objectAtIndex:page];
    
    for (id temp in self.viewControllers) {
        if (temp != [NSNull null]) {
            MovieViewController *controller = temp;
            //bug
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

- (IBAction)btnMovePanelRight:(id)sender
{
    NSLog(@"press button");
    UIButton *button = sender;
    switch (button.tag) {
        case 0: {
            [_delegate movePanelToOriginalPosition];
            break;
        }
            
        case 1: {
            [_delegate movePanelRight];
            break;
        }
            
        default:
            break;
    }
}

- (IBAction)btnMovePanelLeft:(id)sender
{
    UIButton *button = sender;
    switch (button.tag) {
        case 0: {
            [_delegate movePanelToOriginalPosition];
            break;
        }
            
        case 1: {
            [_delegate movePanelLeft];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark Delagate Method for capturing selected image

/*
 note: typically, you wouldn't create "duplicate" delagate methods, but we went with simplicity.
 doing it this way allowed us to show how to use the #define statement and the switch statement.
 */

-(void)movePanelRight {
    [_delegate movePanelToOriginalPosition];
}

//- (void)imageSelected:(UIImage *)image withTitle:(NSString *)imageTitle withCreator:(NSString *)imageCreator
//{
//    // only change the main display if an animal/image was selected
//    if (image)
//    {
//        self.mainImageView.image = image;
//        self.imageTitle.text = [NSString stringWithFormat:@"%@", imageTitle];
//        self.imageCreator.text = [NSString stringWithFormat:@"%@", imageCreator];
//    }
//}

//- (void)animalSelected:(Animal *)animal
//{
//    // only change the main display if an animal/image was selected
//    if (animal)
//    {
//        [self showAnimalSelected:animal];
//    }
//}
//
//// setup the imageview with our selected animal
//- (void)showAnimalSelected:(Animal *)animalSelected
//{
//    self.mainImageView.image = animalSelected.image;
//    self.imageTitle.text = [NSString stringWithFormat:@"%@", animalSelected.title];
//    self.imageCreator.text = [NSString stringWithFormat:@"%@", animalSelected.creator];
//}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
