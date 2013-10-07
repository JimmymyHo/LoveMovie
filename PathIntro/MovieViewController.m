//
//  MovieViewController.m
//  LoveMovie
//
//  Created by Ho Jimmy on 13/10/3.
//  Copyright (c) 2013年 Dmitry Kondratyev. All rights reserved.
//

#import "MovieViewController.h"


@interface MovieViewController () {
    int pageNumber;
}

@end

@implementation MovieViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// load the view nib and initialize the pageNumber ivar
- (id)initWithPageNumber:(NSUInteger)page
{
    if (self = [super initWithNibName:@"MovieView" bundle:nil])
    {
        pageNumber = page;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.pageNumberLabel.text = [NSString stringWithFormat:@"Page %d", pageNumber + 1];
    
    self.scrollView.contentSize = CGSizeMake(320, 1000);
    self.scrollView.pagingEnabled = NO;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor clearColor];
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"scroll offset:%f",scrollView.contentOffset.y);
    
    if(scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y <= 250.0) {
        float percent = (scrollView.contentOffset.y / 250.0);
        
        self.numberImageWithBlur.alpha = percent;
        
    } else if (scrollView.contentOffset.y > 250.0){
        self.numberImageWithBlur.alpha = 1;
    } else if (scrollView.contentOffset.y < 0) {
        self.numberImageWithBlur.alpha = 0;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
