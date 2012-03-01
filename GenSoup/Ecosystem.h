//
//  Ecosystem.h
//  GenSoup
//
//  Created by Borja Arias Drake on 22/05/2011.
//  Copyright 2011 Unboxed Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cell.h"

#define ROWS_ARCHIVE_KEY @"rowsArchiveKey"
#define COLUMNS_ARCHIVE_KEY @"columnsArchiveKey"
#define INITIAL_POPULATION_ARCHIVE_KEY @"initialPopulationArchiveKey"
#define ALIVE_CELLS_ARCHIVE_KEY @"aliveCellsArchiveKey"

@class GenSoupViewController;

@interface Ecosystem : NSObject <NSCoding>
{
    NSString* storageName; // it will be a lower case underscore separated string.
    NSMutableSet* initialPopulation;
    NSMutableSet* aliveCells;
    NSMutableSet* emptyWith3Alive;
    NSMutableSet* nextGenAliveCells;
    NSMutableSet* nextGenEmptyWith3Alive;
    int rows;
    int columns;
    NSOperationQueue* operationQueue;    
    BOOL isSetUp;
}

@property (retain, nonatomic, readonly) NSMutableSet* aliveCells;
@property (assign, nonatomic) GenSoupViewController* delegate;
@property (retain, nonatomic) NSMutableSet* initialPopulation;
@property (retain, nonatomic) NSString* storageName;

- (id) initWithRows:(int)theRows andColumns:(int)theColumns andInitialPopulation:(NSSet*)population;
- (void) printToConsole;
- (void) produceNextGeneration;
- (void) reset;
- (void) setUp;

@end
