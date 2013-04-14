//
//  DataDao.h
//  VisitCharlotte
//
//  Created by Christine Talbot on 11/22/11.
//  Copyright 2011 UNCC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DataDao : NSObject {
    NSString *dataPlist;
    NSMutableArray *dataContent;
    int maxFavs;
    
}

@property (nonatomic, readonly) NSString *dataPlist;
@property (nonatomic, readonly) NSArray *dataContent;

- (id)initWithDataName:(NSString *)dataName;
- (NSMutableDictionary *)dataItemAtIndex:(int)index;
- (int)dataCount;
- (void)addToFavorites:(int)index atPosition:(int)position;
- (void)removeFromFavorites:(int)index;
- (void)removeForReorderingFavorites:(int)index;

@end
