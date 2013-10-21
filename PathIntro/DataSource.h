//
//  DataSource.h
//  LoveMovie
//
//  Created by Ho Jimmy on 13/10/21.
//  Copyright (c) 2013年 Dmitry Kondratyev. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DataSource : NSObject {
    NSArray *movieList;
    NSMutableArray       *buckets;
    NSMutableArray       *objects;
}

+(DataSource*)shareDataSource;
-(UIImage*)getPoster:(int)page;

@end
