//
//  BBURLDetector.m
//  URLDetector
//
//  Created by wangsw on 10/24/13.
//  Copyright (c) 2013 beanandbean. All rights reserved.
//

#import "BBURLDetection.h"

#import "BBFullURLMatcher.h"

#import "BBURLMatch.h"

@interface BBURLDetection ()

@property (strong, nonatomic) NSString *string;

@property (strong, nonatomic) NSArray *matches;

@end

@implementation BBURLDetection

+ (NSComparisonResult)compare:(int)i and:(int)j {
    if (i < j) {
        return (NSComparisonResult)NSOrderedAscending;
    } else if (i > j) {
        return (NSComparisonResult)NSOrderedDescending;
    } else {
        return (NSComparisonResult)NSOrderedSame;
    }
}

- (id)initWithString:(NSString *)string {
    self = [super init];
    if (self) {
        self.string = string;
        
        NSMutableArray *matches = [[NSMutableArray alloc] init];
        
        BBFullURLMatcher *fullURLMatcher = [[BBFullURLMatcher alloc] init];
        [matches addObjectsFromArray:[fullURLMatcher match:string]];
        
        [matches sortUsingComparator:^ NSComparisonResult (id obj1, id obj2) {
            BBURLMatch *firstMatch = (BBURLMatch *)obj1;
            BBURLMatch *secondMatch = (BBURLMatch *)obj2;
            if (firstMatch.begin == secondMatch.begin) {
                return [BBURLDetection compare:secondMatch.end and:firstMatch.end];
            } else {
                return [BBURLDetection compare:firstMatch.begin and:secondMatch.begin];
            }
        }];
        
        BBURLMatch *previousMatch = [[BBURLMatch alloc] init];
        previousMatch.type = -1;
        previousMatch.begin = -1;
        previousMatch.end = -1;
        for (BBURLMatch *match in matches) {
            if (match.type == previousMatch.type && match.begin == previousMatch.begin && match.end == previousMatch.end) {
                [matches removeObject:match];
            } else {
                previousMatch = match;
            }
        }
        
        self.matches = matches;
    }
    return self;
}

@end
