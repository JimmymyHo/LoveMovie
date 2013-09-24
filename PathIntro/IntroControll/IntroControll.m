#import "IntroControll.h"

@implementation IntroControll


- (id)initWithFrame:(CGRect)frame pages:(NSArray*)pagesArray
{
    self = [super initWithFrame:frame];
    if(self != nil) {
        
        //Initial Background images
        
        self.backgroundColor = [UIColor blackColor];
        
        backgroundImage1 = [[UIImageView alloc] initWithFrame:frame];
        [backgroundImage1 setContentMode:UIViewContentModeScaleAspectFill];
        [backgroundImage1 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        [self addSubview:backgroundImage1];

        backgroundImage2 = [[UIImageView alloc] initWithFrame:frame];
        [backgroundImage2 setContentMode:UIViewContentModeScaleAspectFill];
        [backgroundImage2 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        [self addSubview:backgroundImage2];
        
//        //Initial shadow
//        UIImageView *shadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow.png"]];
//        shadowImageView.contentMode = UIViewContentModeScaleToFill;
//        shadowImageView.frame = CGRectMake(0, frame.size.height-300, frame.size.width, 300);
//        [self addSubview:shadowImageView];
        
        //Create pages
        pages = pagesArray;
        
        //Initial parent ScrollView
        parentScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        parentScrollView.backgroundColor = [UIColor clearColor];
        parentScrollView.pagingEnabled = YES;
        parentScrollView.showsHorizontalScrollIndicator = NO;
        parentScrollView.showsVerticalScrollIndicator = NO;
        parentScrollView.delegate = self;
        [parentScrollView setDirectionalLockEnabled:YES];
        [self addSubview:parentScrollView];
        
        parentScrollView.contentSize = CGSizeMake(pages.count * frame.size.width, 720);
        
        //Initial ScrollView
        scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.pagingEnabled = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        [scrollView setDirectionalLockEnabled:YES];
        [parentScrollView addSubview:scrollView];
        
        //Initial PageView
        pageControl = [[UIPageControl alloc] init];
        pageControl.numberOfPages = pagesArray.count;
        [pageControl sizeToFit];
        [pageControl setCenter:CGPointMake(frame.size.width/2.0, frame.size.height-50)];
        [self addSubview:pageControl];
        
        scrollView.contentSize = CGSizeMake(self.frame.size.width, 720);
        
        currentPhotoNum = -1;
        
        //insert TextViews into ScrollView
        for(int i = 0; i <  pages.count; i++) {
            IntroView *view = [[IntroView alloc] initWithFrame:frame model:[pages objectAtIndex:i]];
            view.frame = CGRectOffset(view.frame, i*frame.size.width, 0);
            [parentScrollView addSubview:view];
        }
            
        //start timer
        timer =  [NSTimer scheduledTimerWithTimeInterval:3.0
                        target:self
                        selector:@selector(tick)
                        userInfo:nil
                        repeats:YES];
        
        [self initShow];
    }
    
    return self;
}

- (void) tick {
    //[scrollView setContentOffset:CGPointMake((currentPhotoNum+1 == pages.count ? 0 : currentPhotoNum+1)*self.frame.size.width, 0) animated:YES];
}

- (void) initShow {
    int scrollPhotoNumber = MAX(0, MIN(pages.count-1, (int)(scrollView.contentOffset.x / self.frame.size.width)));
    
    if(scrollPhotoNumber != currentPhotoNum) {
        currentPhotoNum = scrollPhotoNumber;
        
        //backgroundImage1.image = currentPhotoNum != 0 ? [(IntroModel*)[pages objectAtIndex:currentPhotoNum-1] image] : nil;
        backgroundImage1.image = [(IntroModel*)[pages objectAtIndex:currentPhotoNum] image];
        backgroundImage2.image = currentPhotoNum+1 != [pages count] ? [(IntroModel*)[pages objectAtIndex:currentPhotoNum+1] image] : nil;
    }
    
    float offset =  scrollView.contentOffset.x - (currentPhotoNum * self.frame.size.width);
    
    
    //left
    if(offset < 0) {
        pageControl.currentPage = 0;
        
        offset = self.frame.size.width - MIN(-offset, self.frame.size.width);
        backgroundImage2.alpha = 0;
        backgroundImage1.alpha = (offset / self.frame.size.width);
    
    //other
    } else if(offset != 0) {
        //last
        if(scrollPhotoNumber == pages.count-1) {
            pageControl.currentPage = pages.count-1;
            
            backgroundImage1.alpha = 1.0 - (offset / self.frame.size.width);
        } else {
            
            pageControl.currentPage = (offset > self.frame.size.width/2) ? currentPhotoNum+1 : currentPhotoNum;
            
            backgroundImage2.alpha = offset / self.frame.size.width;
            backgroundImage1.alpha = 1.0 - backgroundImage2.alpha;
        }
    //stable
    } else {
        pageControl.currentPage = currentPhotoNum;
        backgroundImage1.alpha = 1;
        backgroundImage2.alpha = 0;
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    startPos = scrollView.contentOffset;
    NSLog(@"startPoint=%f,%f",startPos.x,startPos.y);
    scrollDirection=0;
    NSLog(@"drag scrollview num=%i",scrollView.pagingEnabled);
}

- (void)scrollViewDidScroll:(UIScrollView *)scroll {
    [self initShow];
    endPos = scroll.contentOffset;
//    if (scrollDirection==0){//we need to determine direction
//        //use the difference between positions to determine the direction.
//        if (abs(startPos.x-scrollView.contentOffset.x)<abs(startPos.y-scrollView.contentOffset.y)){
//            NSLog(@"Vertical Scrolling");
//            scrollDirection=1;
//            
//        } else {
//            NSLog(@"Horitonzal Scrolling");
//            scrollDirection=2;
//            
//        }
//    }
//    //Update scroll position of the scrollview according to detected direction.
//    if (scrollDirection==1) {
//        [scrollView setContentOffset:CGPointMake(startPos.x,scrollView.contentOffset.y) animated:NO];
//        scrollView.pagingEnabled = NO;
//    } else if (scrollDirection==2){
//        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x,startPos.y) animated:NO];
//        scrollView.pagingEnabled = YES;
//    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    //not called when pageEnable=YES (?
//    NSLog(@"enter WillEndDragging");
//    NSLog(@"targetOffset:x=%f,y=%f",targetContentOffset->x,targetContentOffset->y);
//    targetContentOffset->x = pageControl.currentPage * 320;
//    //targetContentOffset->y = startPos.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    if (decelerate) {
//        scrollDirection=3;
//    }
//    NSLog(@"EndDragOffset:x=%f,y=%f,decelerate=%i",scrollView.contentOffset.x,scrollView.contentOffset.y,decelerate);
//    //if (!decelerate) { scrollDirection=0; }
    
    //scroll not enough
//    NSLog(@"%f",endPos.x - 320 * pageControl.currentPage);
//    if (endPos.x - 320 * pageControl.currentPage < 160) {
//        [parentScrollView setContentOffset:CGPointMake(320 * pageControl.currentPage, 0) animated:YES];
//    }else {
//        pageControl.currentPage = pageControl.currentPage+1;
//        [parentScrollView setContentOffset:CGPointMake(320 * pageControl.currentPage, 0) animated:YES];
//    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scroll {
    NSLog(@"enter EndDecelerateing");
    //scrollDirection=0;
    //[scrollView setPagingEnabled:YES];
    if(timer != nil) {
        [timer invalidate];
        timer = nil;
    }
    [self initShow];
    NSLog(@"EndDecelOffset:x=%f,y=%f",scrollView.contentOffset.x,scrollView.contentOffset.y);
//    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x,startPos.y)
//                        animated:YES];
}

@end
