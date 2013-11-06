//
//  MovieViewController.m
//  LoveMovie
//
//  Created by Ho Jimmy on 13/10/3.
//  Copyright (c) 2013年 Dmitry Kondratyev. All rights reserved.
//

#import "MovieViewController.h"
#import "Constants.h"
#import "DataSource.h"
#import "AmazonClientManager.h"
#import "UIImage+ImageEffects.h"
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

-(void)getPoster:(int)page {
    
    NSString *posterName = [NSString stringWithFormat:@"%d.png",page];
    NSLog(@"%@",posterName);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        });
        
        S3GetObjectRequest  *getObjectRequest  = [[S3GetObjectRequest alloc] initWithKey:posterName withBucket:@"movielist"];
        S3GetObjectResponse *getObjectResponse = [[AmazonClientManager s3] getObject:getObjectRequest];
        if(getObjectResponse.error != nil)
        {
            NSLog(@"Error: %@", getObjectResponse.error);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            self.numberImage.image = [[UIImage alloc] initWithData:getObjectResponse.body];
            self.numberImageWithBlur.image = [self.numberImage.image applyLightEffect];
        });
    });
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.numberImage.image = [[DataSource shareDataSource] getPoster:self.page];
    [self getPoster:self.page];
    self.pageNumberLabel.text = [NSString stringWithFormat:@"Page %d", pageNumber + 1];
    
    self.scrollView.contentSize = CGSizeMake(320, 1000);
    self.scrollView.pagingEnabled = NO;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor clearColor];
    
    self.view.backgroundColor = UIColorFromRGB(navColor);
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(navColor)];
    
//    NSShadow *shadow = [[NSShadow alloc] init];
//    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
//    shadow.shadowOffset = CGSizeMake(0, 1);
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
            UIColorFromRGB(navTextColor), NSForegroundColorAttributeName,nil]];
    
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
