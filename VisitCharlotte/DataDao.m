//
//  DataDao.m
//  VisitCharlotte
//
//  Created by Christine Talbot on 11/22/11.
//  Copyright 2011 UNCC. All rights reserved.
//

#import "DataDao.h"


@implementation DataDao

@synthesize dataPlist;
@synthesize dataContent;

-(id)initWithDataName:(NSString *) dataName {
    if ((self = [super init])) {
        maxFavs = 0;
        dataPlist = dataName;
        dataContent = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:dataPlist ofType:@"plist" inDirectory:nil]];
    }

    return self;
}

-(NSMutableDictionary *)dataItemAtIndex:(int)index {
    return (dataContent != nil && [dataContent count] > 0 && index < [dataContent count])?[dataContent objectAtIndex:index]:nil;
}

-(int)dataCount {

    return (dataContent != nil) ? [dataContent count] : 0;
}

-(void)dealloc{
    [dataPlist release];
    dataPlist = nil;
    [dataContent release];
    dataContent = nil;
    [super dealloc];
}


- (void)addToFavorites:(int)index atPosition:(int)position {

    [[dataContent objectAtIndex:index] setObject:(id) kCFBooleanTrue forKey:@"favorite"];
    
    [[dataContent objectAtIndex:index] setValue:[NSNumber numberWithInt:[[[dataContent objectAtIndex:0] objectForKey:@"maxFavs"] intValue]+1] forKey:@"sequence"];
       
    [[dataContent objectAtIndex:0] setValue:[NSNumber numberWithInt:[[[dataContent objectAtIndex:0] objectForKey:@"maxFavs"] intValue] + 1] forKey:@"maxFavs"];
    int correctpostn = (position >= [[[dataContent objectAtIndex:0] objectForKey:@"maxFavs"]intValue])?[[[dataContent objectAtIndex:0] objectForKey:@"maxFavs"]intValue]-1:position;
    [[[dataContent objectAtIndex:0] objectForKey:@"favlist"] insertObject:[NSNumber numberWithInt:index] atIndex:correctpostn];// forKey:@"recNum"];
     

    [dataContent writeToFile:[[NSBundle mainBundle] pathForResource:dataPlist ofType:@"plist" inDirectory:nil] atomically:YES];

}

- (void)removeFromFavorites:(int)index {

    [[dataContent objectAtIndex:index] setObject:(id) kCFBooleanFalse forKey:@"favorite"];
    [[dataContent objectAtIndex:index] setValue:[NSNumber numberWithInt:0] forKey:@"sequence"];
    int toDelete = [[[dataContent objectAtIndex:0] objectForKey:@"maxFavs"] intValue];
    [[dataContent objectAtIndex:0] setValue:[NSNumber numberWithInt:[[[dataContent objectAtIndex:0] objectForKey:@"maxFavs"] intValue] - 1] forKey:@"maxFavs"];
    int locToDelete = -1;
    for (int i=0; i < toDelete; i++) {
        if ([[[[dataContent objectAtIndex:0] objectForKey:@"favlist"] objectAtIndex:i] intValue] == index) {
            locToDelete = i;
        }
    }
    [[[dataContent objectAtIndex:0] objectForKey:@"favlist"] removeObjectAtIndex:locToDelete];

    [dataContent writeToFile:[[NSBundle mainBundle] pathForResource:dataPlist ofType:@"plist" inDirectory:nil] atomically:YES];

}

- (void)removeForReorderingFavorites:(int)index {

    int locToDelete = [[[[dataContent objectAtIndex:0] objectForKey:@"favlist"] objectAtIndex:index] intValue];
    [[dataContent objectAtIndex:locToDelete] setObject:(id) kCFBooleanFalse forKey:@"favorite"];
    [[dataContent objectAtIndex:locToDelete] setValue:[NSNumber numberWithInt:0] forKey:@"sequence"];

    [[dataContent objectAtIndex:0] setValue:[NSNumber numberWithInt:[[[dataContent objectAtIndex:0] objectForKey:@"maxFavs"] intValue] - 1] forKey:@"maxFavs"];

    [[[dataContent objectAtIndex:0] objectForKey:@"favlist"] removeObjectAtIndex:index];

    [dataContent writeToFile:[[NSBundle mainBundle] pathForResource:dataPlist ofType:@"plist" inDirectory:nil] atomically:YES];

}


@end
