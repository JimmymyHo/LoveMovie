//
//  DataSource.m
//  LoveMovie
//
//  Created by Ho Jimmy on 13/10/21.
//  Copyright (c) 2013年 Dmitry Kondratyev. All rights reserved.
//

#import "DataSource.h"
#import <AWSS3/AWSS3.h>
#import "AmazonClientManager.h"


@implementation DataSource

+(DataSource*)shareDataSource {
    static DataSource *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)init {
    if (self = [super init]) {
        //[self getBucketList];
    }
    return self;
}

-(void)getBucketList {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        });
        
        NSArray *bucketNames = [[AmazonClientManager s3] listBuckets];
        if (buckets == nil) {
            buckets = [[NSMutableArray alloc] initWithCapacity:[bucketNames count]];
        }
        else {
            [buckets removeAllObjects];
        }
        
        if (bucketNames != nil) {
            for (S3Bucket *bucket in bucketNames) {
                [buckets addObject:[bucket name]];
                NSLog(@"%@",[bucket name]);
            }
        }
        
        [buckets sortUsingSelector:@selector(compare:)];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [self getObjectList:[buckets objectAtIndex:0]];
        });
    });
    
    

}

-(void)getObjectList:(NSString*)bucket {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        });
        
        S3ListObjectsRequest  *listObjectRequest = [[[S3ListObjectsRequest alloc] initWithName:bucket] autorelease];
        S3ListObjectsResponse *listObjectResponse = [[AmazonClientManager s3] listObjects:listObjectRequest];
        if(listObjectResponse.error != nil)
        {
            NSLog(@"Error: %@", listObjectResponse.error);
            [objects addObject:@"Unable to load objects!"];
        }
        else
        {
            S3ListObjectsResult *listObjectsResults = listObjectResponse.listObjectsResult;
            
            if (objects == nil) {
                objects = [[NSMutableArray alloc] initWithCapacity:[listObjectsResults.objectSummaries count]];
            }
            else {
                [objects removeAllObjects];
            }
            
            // By defrault, listObjects will only return 1000 keys
            // This code will fetch all objects in bucket.
            // NOTE: This could cause the application to run out of memory
            NSString *lastKey = @"";
            for (S3ObjectSummary *objectSummary in listObjectsResults.objectSummaries) {
                [objects addObject:[objectSummary key]];
                lastKey = [objectSummary key];
            }
            
            while (listObjectsResults.isTruncated) {
                listObjectRequest = [[[S3ListObjectsRequest alloc] initWithName:bucket] autorelease];
                listObjectRequest.marker = lastKey;
                
                listObjectResponse = [[AmazonClientManager s3] listObjects:listObjectRequest];
                if(listObjectResponse.error != nil)
                {
                    NSLog(@"Error: %@", listObjectResponse.error);
                    [objects addObject:@"Unable to load objects!"];
                    
                    break;
                }
                
                listObjectsResults = listObjectResponse.listObjectsResult;
                
                for (S3ObjectSummary *objectSummary in listObjectsResults.objectSummaries) {
                    [objects addObject:[objectSummary key]];
                    lastKey = [objectSummary key];
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            //[self.tableView reloadData];

            objects = (NSMutableArray*)[objects sortedArrayUsingComparator:^NSComparisonResult(NSString *object1, NSString *object2) {
                return [object1 compare:object2];
            }];

//            for (int i=0; i<20; i++) {
//                NSLog(@"%@",[objects objectAtIndex:i]);
//            }
        });
    });

}

-(UIImage*)getPoster:(int)page {
    
    NSString *posterName = [NSString stringWithFormat:@"%d.png",page];
    __block UIImage *image;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        });
        
        S3GetObjectRequest  *getObjectRequest  = [[[S3GetObjectRequest alloc] initWithKey:posterName withBucket:@"movielist"] autorelease];
        S3GetObjectResponse *getObjectResponse = [[AmazonClientManager s3] getObject:getObjectRequest];
        if(getObjectResponse.error != nil)
        {
            NSLog(@"Error: %@", getObjectResponse.error);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            image = [[[UIImage alloc] initWithData:getObjectResponse.body] autorelease];
//            self.objectNameLabel.text = self.objectName;
//            self.objectDataLabel.text = [[[NSString alloc] initWithData:getObjectResponse.body encoding:NSUTF8StringEncoding] autorelease];
        });
    });
    return image;
}

@end
