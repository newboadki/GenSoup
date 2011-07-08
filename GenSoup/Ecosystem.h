//
//  Ecosystem.h
//  GenSoup
//
//  Created by Borja Arias Drake on 22/05/2011.
//  Copyright 2011 Unboxed Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cell.h"

@class GenSoupViewController;

@interface Ecosystem : NSObject
{
    NSMutableSet* initialPopulation;
    NSMutableSet* aliveCells;
    NSMutableSet* emptyWith3Alive;
    NSMutableSet* nextGenAliveCells;
    NSMutableSet* nextGenEmptyWith3Alive;
    int rows;
    int columns;
    NSOperationQueue* operationQueue;
}

@property (retain, nonatomic, readonly) NSMutableSet* aliveCells;
@property (assign, nonatomic) GenSoupViewController* delegate;


- (id) initWithRows:(int)theRows andColumns:(int)theColumns andInitialPopulation:(NSSet*)population;
- (void) printToConsole;
- (void) produceNextGeneration;

@end
