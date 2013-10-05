//
//  MovieViewController.h
//  LoveMovie
//
//  Created by Ho Jimmy on 13/10/3.
//  Copyright (c) 2013年 Dmitry Kondratyev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UILabel *pageNumberLabel;

@property (nonatomic, strong) IBOutlet UILabel *numberTitle;
@property (nonatomic, strong) IBOutlet UIImageView *numberImage;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

- (id)initWithPageNumber:(NSUInteger)page;


@end
