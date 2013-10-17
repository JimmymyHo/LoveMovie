//
//  LeftViewController.h
//  LoveMovie
//
//  Created by Ho Jimmy on 13/10/8.
//  Copyright (c) 2013年 Dmitry Kondratyev. All rights reserved.
//

#import <UIKit/UIKit.h>
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//@class Animal;

@protocol LeftPanelViewControllerDelegate <NSObject>

@optional
- (void)imageSelected:(UIImage *)image withTitle:(NSString *)imageTitle withCreator:(NSString *)imageCreator;
- (void)movePanelRight;
@required
//- (void)animalSelected:(Animal *)animal;

@end

@interface LeftViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) id<LeftPanelViewControllerDelegate> delegate;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
