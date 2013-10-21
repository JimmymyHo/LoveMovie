//
//  LeftViewController.h
//  LoveMovie
//
//  Created by Ho Jimmy on 13/10/8.
//  Copyright (c) 2013年 Dmitry Kondratyev. All rights reserved.
//

#import <UIKit/UIKit.h>
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
