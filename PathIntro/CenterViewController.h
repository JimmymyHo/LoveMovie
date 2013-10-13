//
//  RootViewController.h
//  LoveMovie
//
//  Created by Ho Jimmy on 13/10/3.
//  Copyright (c) 2013年 Dmitry Kondratyev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CenterViewControllerDelegate <NSObject>

@optional
- (void)movePanelLeft;
- (void)movePanelRight;

@required
- (void)movePanelToOriginalPosition;

@end

@interface CenterViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *movieList;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, assign) id<CenterViewControllerDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIButton *leftButton;


@end
