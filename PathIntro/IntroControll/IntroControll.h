#import <UIKit/UIKit.h>
#import "IntroView.h"

@interface IntroControll : UIView<UIScrollViewDelegate> {
    UIImageView *backgroundImage1;
    UIImageView *backgroundImage2;
    
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    NSArray *pages;
    
    NSTimer *timer;
    UIView *test;
    int currentPhotoNum;
    
    CGPoint startPos;
    CGPoint endPos;
    int     scrollDirection;
}

- (id)initWithFrame:(CGRect)frame pages:(NSArray*)pages;


@end
