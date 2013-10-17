//
//  MovieViewController.h
//  LoveMovie
//
//  Created by Ho Jimmy on 13/10/3.
//  Copyright (c) 2013年 Dmitry Kondratyev. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface MovieViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UILabel *pageNumberLabel;

@property (nonatomic, strong) IBOutlet UILabel *numberTitle;
@property (nonatomic, strong) IBOutlet UIImageView *numberImage;
@property (nonatomic, strong) IBOutlet UIImageView *numberImageWithBlur;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

- (id)initWithPageNumber:(NSUInteger)page;


@end
