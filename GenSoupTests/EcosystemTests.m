//
//  EcosystemTests.m
//  GenSoup
//
//  Created by Borja Arias Drake on 11/06/2011.
//  Copyright 2011 Unboxed Consulting. All rights reserved.
//

#import "EcosystemTests.h"


@implementation EcosystemTests

- (void) setUp 
{
}

- (void) tearDown
{
}

- (void) testInitWithRowsColumnsAndInitialPopulation
{
    NSMutableSet* set = [[NSMutableSet alloc] init];
    Ecosystem* eco = [[Ecosystem alloc] initWithRows:50 andColumns:50 andInitialPopulation:set];
    
    NSMutableSet* initialPopulation = [eco valueForKey:@"initialPopulation"];
    NSMutableSet* aliveCells = [eco valueForKey:@"aliveCells"];
    NSMutableSet* emptyWith3Alive = [eco valueForKey:@"emptyWith3Alive"];
    NSMutableSet* nextGenAliveCells = [eco valueForKey:@"nextGenAliveCells"];
    NSMutableSet* nextGenEmptyWith3Alive = [eco valueForKey:@"nextGenEmptyWith3Alive"];
    NSNumber*     rows = [eco valueForKey:@"rows"];
    NSNumber*     columns = [eco valueForKey:@"columns"];
    
    STAssertNotNil(initialPopulation, @"the init method should set the initialPopulation");
    STAssertNotNil(aliveCells, @"the init method should set the aliveCells");
    STAssertNotNil(emptyWith3Alive, @"the init method should set the emptyWith3Alive");
    STAssertNotNil(nextGenAliveCells, @"the init method should set the nextGenAliveCells");
    STAssertNotNil(nextGenEmptyWith3Alive, @"the init method should set the nextGenEmptyWith3Alive");
    STAssertNotNil(rows, @"the init method should set the rows");
    STAssertNotNil(columns, @"the init method should set the columns");
    
    [eco release];
    [set release];
}

- (void) testRowValid
{
    Ecosystem* eco = [[Ecosystem alloc] initWithRows:50 andColumns:50 andInitialPopulation:nil];
    
    STAssertFalse([eco rowValid:-1], @"Rows should be possitive");
    STAssertFalse([eco rowValid:50], @"Rows should be <= numberOfRows");
    STAssertTrue([eco rowValid:0],  @"Rows with index 0 should be valid");
    STAssertTrue([eco rowValid:49], @"Rows with index <= numberOfRows should be valid");
    
    [eco release];
}


- (void) testColumnValid
{
    Ecosystem* eco = [[Ecosystem alloc] initWithRows:50 andColumns:50 andInitialPopulation:nil];
    
    STAssertFalse([eco colValid:-1], @"Rows should be possitive");
    STAssertFalse([eco colValid:50], @"Rows should be <= numberOfRows");
    STAssertTrue([eco colValid:0],  @"Rows with index 0 should be valid");
    STAssertTrue([eco colValid:49], @"Rows with index <= numberOfRows should be valid");
    
    [eco release];
}


- (void) testNumberOfNeighboursThrowsException
{
    Matrix2DCoordenate* coor0 = [[Matrix2DCoordenate alloc] initWithRow:20 andColumn:4];
    Cell* cell0 = [[Cell alloc] initWithCoordinate:coor0 andOrganismID:-1];
    
    NSMutableSet* population = [[NSMutableSet alloc] init];
    
    Ecosystem* eco = [[Ecosystem alloc] initWithRows:5 andColumns:5 andInitialPopulation:population];
    
    STAssertThrows([eco numberOfNeighbours:cell0.coordinate inSet:population], @"Should throw exception if cell does not exist");
    
    [eco release];
}


- (void) testNumberOfNeighbours
{
    
    /*
     
     - - - - +
     - - + - -
     - + - + -
     - - - + +
     - - - + +        
     
     */

    Matrix2DCoordenate* coor0 = [[Matrix2DCoordenate alloc] initWithRow:0 andColumn:4];
    Cell* cell0 = [[Cell alloc] initWithCoordinate:coor0 andOrganismID:-1];
    Matrix2DCoordenate* coor1 = [[Matrix2DCoordenate alloc] initWithRow:1 andColumn:2];
    Cell* cell1 = [[Cell alloc] initWithCoordinate:coor1 andOrganismID:-1];
    Matrix2DCoordenate* coor2 = [[Matrix2DCoordenate alloc] initWithRow:2 andColumn:1];
    Cell* cell2 = [[Cell alloc] initWithCoordinate:coor2 andOrganismID:-1];   
    Matrix2DCoordenate* coor3 = [[Matrix2DCoordenate alloc] initWithRow:2 andColumn:3];
    Cell* cell3 = [[Cell alloc] initWithCoordinate:coor3 andOrganismID:-1];
    Matrix2DCoordenate* coor4 = [[Matrix2DCoordenate alloc] initWithRow:3 andColumn:3];
    Cell* cell4 = [[Cell alloc] initWithCoordinate:coor4 andOrganismID:-1];
    Matrix2DCoordenate* coor5 = [[Matrix2DCoordenate alloc] initWithRow:3 andColumn:4];
    Cell* cell5 = [[Cell alloc] initWithCoordinate:coor5 andOrganismID:-1];
    Matrix2DCoordenate* coor6 = [[Matrix2DCoordenate alloc] initWithRow:4 andColumn:3];
    Cell* cell6 = [[Cell alloc] initWithCoordinate:coor6 andOrganismID:-1];
    Matrix2DCoordenate* coor7 = [[Matrix2DCoordenate alloc] initWithRow:4 andColumn:4];
    Cell* cell7 = [[Cell alloc] initWithCoordinate:coor7 andOrganismID:-1];

    NSMutableSet* population = [[NSMutableSet alloc] init];
    [population addObject:cell0];
    [population addObject:cell1];
    [population addObject:cell2];
    [population addObject:cell3];
    [population addObject:cell4];
    [population addObject:cell5];
    [population addObject:cell6];
    [population addObject:cell7];
    
    Ecosystem* eco = [[Ecosystem alloc] initWithRows:5 andColumns:5 andInitialPopulation:population];

    STAssertTrue([eco numberOfNeighbours:cell0.coordinate inSet:population] == 0, @"Cell1 should have 0 neighbourgh. %i", [eco numberOfNeighbours:cell0 inSet:population]);
    STAssertTrue([eco numberOfNeighbours:cell1.coordinate inSet:population] == 2, @"Cell1 should have 1 neighbourgh. %i", [eco numberOfNeighbours:cell1 inSet:population]);
    STAssertTrue([eco numberOfNeighbours:cell2.coordinate inSet:population] == 1, @"Cell1 should have 1 neighbourgh. %i", [eco numberOfNeighbours:cell2 inSet:population]);
    STAssertTrue([eco numberOfNeighbours:cell3.coordinate inSet:population] == 3, @"Cell1 should have 3 neighbourgh. %i", [eco numberOfNeighbours:cell3 inSet:population]);
    STAssertTrue([eco numberOfNeighbours:cell4.coordinate inSet:population] == 4, @"Cell1 should have 4 neighbourgh. %i", [eco numberOfNeighbours:cell4 inSet:population]);
    STAssertTrue([eco numberOfNeighbours:cell5.coordinate inSet:population] == 4, @"Cell1 should have 4 neighbourgh. %i", [eco numberOfNeighbours:cell5 inSet:population]);
    STAssertTrue([eco numberOfNeighbours:cell6.coordinate inSet:population] == 3, @"Cell1 should have 3 neighbourgh. %i", [eco numberOfNeighbours:cell6 inSet:population]);
    STAssertTrue([eco numberOfNeighbours:cell7.coordinate inSet:population] == 3, @"Cell1 should have 3 neighbourgh. %i", [eco numberOfNeighbours:cell7 inSet:population]);
    
    [eco release];
    [population release];
}


- (void) testAreNeighboursCell
{
    /*
     
     - - - - +
     - - + - -
     - + - + -
     - - - + +
     - - - + +        
     
     */
    
    Matrix2DCoordenate* coor0 = [[Matrix2DCoordenate alloc] initWithRow:0 andColumn:4];
    Cell* cell0 = [[Cell alloc] initWithCoordinate:coor0 andOrganismID:-1];
    Matrix2DCoordenate* coor1 = [[Matrix2DCoordenate alloc] initWithRow:1 andColumn:2];
    Cell* cell1 = [[Cell alloc] initWithCoordinate:coor1 andOrganismID:-1];
    Matrix2DCoordenate* coor2 = [[Matrix2DCoordenate alloc] initWithRow:2 andColumn:1];
    Cell* cell2 = [[Cell alloc] initWithCoordinate:coor2 andOrganismID:-1];   
    Matrix2DCoordenate* coor3 = [[Matrix2DCoordenate alloc] initWithRow:2 andColumn:3];
    Cell* cell3 = [[Cell alloc] initWithCoordinate:coor3 andOrganismID:-1];
    Matrix2DCoordenate* coor4 = [[Matrix2DCoordenate alloc] initWithRow:3 andColumn:3];
    Cell* cell4 = [[Cell alloc] initWithCoordinate:coor4 andOrganismID:-1];
    Matrix2DCoordenate* coor5 = [[Matrix2DCoordenate alloc] initWithRow:3 andColumn:4];
    Cell* cell5 = [[Cell alloc] initWithCoordinate:coor5 andOrganismID:-1];
    Matrix2DCoordenate* coor6 = [[Matrix2DCoordenate alloc] initWithRow:4 andColumn:3];
    Cell* cell6 = [[Cell alloc] initWithCoordinate:coor6 andOrganismID:-1];
    Matrix2DCoordenate* coor7 = [[Matrix2DCoordenate alloc] initWithRow:4 andColumn:4];
    Cell* cell7 = [[Cell alloc] initWithCoordinate:coor7 andOrganismID:-1];
    
    NSMutableSet* population = [[NSMutableSet alloc] init];
    [population addObject:cell0];
    [population addObject:cell1];
    [population addObject:cell2];
    [population addObject:cell3];
    [population addObject:cell4];
    [population addObject:cell5];
    [population addObject:cell6];
    [population addObject:cell7];
    
    
    Ecosystem* eco = [[Ecosystem alloc] initWithRows:5 andColumns:5 andInitialPopulation:population];

    STAssertTrue([eco areNeighboursCoordinate:cell1.coordinate withCoordinate:cell2.coordinate], @"Cell1 and cell2 should be neighbours");
    STAssertTrue([eco areNeighboursCoordinate:cell4.coordinate withCoordinate:cell7.coordinate], @"Cell4 and cell7 should be neighbours");
    STAssertFalse([eco areNeighboursCoordinate:cell3.coordinate withCoordinate:cell7.coordinate], @"Cell3 and cell7 should notbe neighbours");
    
    [eco release];
    [population release];
    [coor0 release];
    [coor1 release];
    [coor2 release];
    [coor3 release];
    [coor4 release];
    [coor5 release];
    [coor6 release];
    [coor7 release];
    [cell0 release];
    [cell1 release];
    [cell2 release];
    [cell3 release];
    [cell4 release];
    [cell5 release];
    [cell6 release];
    [cell7 release];

}


- (void) testNewAliveForNextGeneration
{    
    /*
     
     - - - - +
     - - + - -
     - + - + -
     - - - + +
     - - - + +        
     
     */
    
    // Create aliveCells set
    Matrix2DCoordenate* coor0 = [[Matrix2DCoordenate alloc] initWithRow:0 andColumn:4];
    Cell* cell0 = [[Cell alloc] initWithCoordinate:coor0 andOrganismID:-1];
    Matrix2DCoordenate* coor1 = [[Matrix2DCoordenate alloc] initWithRow:1 andColumn:2];
    Cell* cell1 = [[Cell alloc] initWithCoordinate:coor1 andOrganismID:-1];
    Matrix2DCoordenate* coor2 = [[Matrix2DCoordenate alloc] initWithRow:2 andColumn:1];
    Cell* cell2 = [[Cell alloc] initWithCoordinate:coor2 andOrganismID:-1];   
    Matrix2DCoordenate* coor3 = [[Matrix2DCoordenate alloc] initWithRow:2 andColumn:3];
    Cell* cell3 = [[Cell alloc] initWithCoordinate:coor3 andOrganismID:-1];
    Matrix2DCoordenate* coor4 = [[Matrix2DCoordenate alloc] initWithRow:3 andColumn:3];
    Cell* cell4 = [[Cell alloc] initWithCoordinate:coor4 andOrganismID:-1];
    Matrix2DCoordenate* coor5 = [[Matrix2DCoordenate alloc] initWithRow:3 andColumn:4];
    Cell* cell5 = [[Cell alloc] initWithCoordinate:coor5 andOrganismID:-1];
    Matrix2DCoordenate* coor6 = [[Matrix2DCoordenate alloc] initWithRow:4 andColumn:3];
    Cell* cell6 = [[Cell alloc] initWithCoordinate:coor6 andOrganismID:-1];
    Matrix2DCoordenate* coor7 = [[Matrix2DCoordenate alloc] initWithRow:4 andColumn:4];
    Cell* cell7 = [[Cell alloc] initWithCoordinate:coor7 andOrganismID:-1];
    
    NSMutableSet* aliveCells = [[NSMutableSet alloc] init];
    [aliveCells addObject:cell0];
    [aliveCells addObject:cell1];
    [aliveCells addObject:cell2];
    [aliveCells addObject:cell3];
    [aliveCells addObject:cell4];
    [aliveCells addObject:cell5];
    [aliveCells addObject:cell6];
    [aliveCells addObject:cell7];
    
    [coor0 release];[cell0 release];
    [coor1 release];[cell1 release];
    [coor2 release];[cell2 release];
    [coor3 release];[cell3 release];
    [coor4 release];[cell4 release];
    [coor5 release];[cell5 release];
    [coor6 release];[cell6 release];
    [coor7 release];[cell7 release];
    

    
    // Create emptyWith3Alive set
    NSMutableSet* emptyWith3Alive = [[NSMutableSet alloc] init];
    Matrix2DCoordenate* empty1 = [[Matrix2DCoordenate alloc] initWithRow:1 andColumn:3];
    Matrix2DCoordenate* empty2 = [[Matrix2DCoordenate alloc] initWithRow:2 andColumn:4];
    [emptyWith3Alive addObject:empty1];
    [emptyWith3Alive addObject:empty2];
    
    [empty1 release];
    [empty2 release];
    
    
    // Create next generation sets
    NSMutableSet* nextGenAliveCells = [[NSMutableSet alloc] init];
    NSMutableSet* nextGenEmptyWith3Alive = [[NSMutableSet alloc] init];


    // Create the ecosystem and set the structures
    Ecosystem* eco = [[Ecosystem alloc] initWithRows:5 andColumns:5 andInitialPopulation:aliveCells];    
    [eco setValue:emptyWith3Alive forKey:@"emptyWith3Alive"];
    [eco setValue:nextGenAliveCells forKey:@"nextGenAliveCells"];
    [eco setValue:nextGenEmptyWith3Alive forKey:@"nextGenEmptyWith3Alive"];
    
    
    [eco createNewAliveForNextGeneration];
    
    Cell* cellForEmpty1 = [[Cell alloc] initWithCoordinate:empty1 andOrganismID:-1];
    Cell* cellForEmpty2 = [[Cell alloc] initWithCoordinate:empty2 andOrganismID:-1];
        
    STAssertTrue([nextGenAliveCells count]==2, @"newAliveForNextGeneration didn't create cells for next generation from emptyWith3Alive");
    STAssertNotNil([nextGenAliveCells member:cellForEmpty1], @"after newAliveForNextGeneration, nextGenEmptyWith3Alive doesn't contain empty1");
    STAssertNotNil([nextGenAliveCells member:cellForEmpty2], @"after newAliveForNextGeneration, nextGenEmptyWith3Alive doesn't contain empty2");

    [cellForEmpty1 release];
    [cellForEmpty2 release];    
    [eco release];
    [aliveCells release];
    [emptyWith3Alive release];
    [nextGenAliveCells release];
    [nextGenEmptyWith3Alive release];
}


- (void) testUpdateCurrentCellStateForNextGeneration
{
    /*
     
     - - - - +
     - - + - -
     - + - + -
     - - - + +
     - - - + +        
     
     */
    
    // Create aliveCells set
    Matrix2DCoordenate* coor0 = [[Matrix2DCoordenate alloc] initWithRow:0 andColumn:4];
    Cell* cell0 = [[Cell alloc] initWithCoordinate:coor0 andOrganismID:-1];
    Matrix2DCoordenate* coor1 = [[Matrix2DCoordenate alloc] initWithRow:1 andColumn:2];
    Cell* cell1 = [[Cell alloc] initWithCoordinate:coor1 andOrganismID:-1];
    Matrix2DCoordenate* coor2 = [[Matrix2DCoordenate alloc] initWithRow:2 andColumn:1];
    Cell* cell2 = [[Cell alloc] initWithCoordinate:coor2 andOrganismID:-1];   
    Matrix2DCoordenate* coor3 = [[Matrix2DCoordenate alloc] initWithRow:2 andColumn:3];
    Cell* cell3 = [[Cell alloc] initWithCoordinate:coor3 andOrganismID:-1];
    Matrix2DCoordenate* coor4 = [[Matrix2DCoordenate alloc] initWithRow:3 andColumn:3];
    Cell* cell4 = [[Cell alloc] initWithCoordinate:coor4 andOrganismID:-1];
    Matrix2DCoordenate* coor5 = [[Matrix2DCoordenate alloc] initWithRow:3 andColumn:4];
    Cell* cell5 = [[Cell alloc] initWithCoordinate:coor5 andOrganismID:-1];
    Matrix2DCoordenate* coor6 = [[Matrix2DCoordenate alloc] initWithRow:4 andColumn:3];
    Cell* cell6 = [[Cell alloc] initWithCoordinate:coor6 andOrganismID:-1];
    Matrix2DCoordenate* coor7 = [[Matrix2DCoordenate alloc] initWithRow:4 andColumn:4];
    Cell* cell7 = [[Cell alloc] initWithCoordinate:coor7 andOrganismID:-1];
    
    NSMutableSet* aliveCells = [[NSMutableSet alloc] init];
    [aliveCells addObject:cell0];
    [aliveCells addObject:cell1];
    [aliveCells addObject:cell2];
    [aliveCells addObject:cell3];
    [aliveCells addObject:cell4];
    [aliveCells addObject:cell5];
    [aliveCells addObject:cell6];
    [aliveCells addObject:cell7];
    
    [coor0 release];[cell0 release];
    [coor1 release];[cell1 release];
    [coor2 release];[cell2 release];
    [coor3 release];[cell3 release];
    [coor4 release];[cell4 release];
    [coor5 release];[cell5 release];
    [coor6 release];[cell6 release];
    [coor7 release];[cell7 release];
    
    
    
    // Create emptyWith3Alive set
    NSMutableSet* emptyWith3Alive = [[NSMutableSet alloc] init];
    Matrix2DCoordenate* empty1 = [[Matrix2DCoordenate alloc] initWithRow:1 andColumn:3];
    Matrix2DCoordenate* empty2 = [[Matrix2DCoordenate alloc] initWithRow:2 andColumn:4];
    [emptyWith3Alive addObject:empty1];
    [emptyWith3Alive addObject:empty2];
    
    [empty1 release];
    [empty2 release];
    
    
    // Create next generation sets
    NSMutableSet* nextGenAliveCells = [[NSMutableSet alloc] init];
    NSMutableSet* nextGenEmptyWith3Alive = [[NSMutableSet alloc] init];
    
    
    // Create the ecosystem and set the structures
    Ecosystem* eco = [[Ecosystem alloc] initWithRows:5 andColumns:5 andInitialPopulation:aliveCells];    
    [eco setValue:emptyWith3Alive forKey:@"emptyWith3Alive"];
    [eco setValue:nextGenAliveCells forKey:@"nextGenAliveCells"];
    [eco setValue:nextGenEmptyWith3Alive forKey:@"nextGenEmptyWith3Alive"];
    
    
    [eco updateCurrentCellStateForNextGeneration];
        
    STAssertTrue([nextGenAliveCells count]==4, @"newAliveForNextGeneration didn't create cells for next generation from emptyWith3Alive %i", [nextGenAliveCells count]);
    STAssertNil([nextGenAliveCells member:cell0], @"cell0 should not exist in the nextGenAlive");
    STAssertNotNil([nextGenAliveCells member:cell1], @"cell1 should exist in the nextGenAlive");
    STAssertNil([nextGenAliveCells member:cell2], @"cell2 should not exist in the nextGenAlive");
    STAssertNotNil([nextGenAliveCells member:cell3], @"cell3 should exist in the nextGenAlive");
    STAssertNil([nextGenAliveCells member:cell4], @"cell2 should not exist in the nextGenAlive");
    STAssertNil([nextGenAliveCells member:cell5], @"cell5 should not exist in the nextGenAlive");
    STAssertNotNil([nextGenAliveCells member:cell6], @"cell6 should exist in the nextGenAlive");
    STAssertNotNil([nextGenAliveCells member:cell7], @"cell7 should exist in the nextGenAlive");

    STAssertTrue([nextGenEmptyWith3Alive count]==4, @"newAliveForNextGeneration didn't create coords for next generation from nextGenEmptyWith3Alive %i", [nextGenEmptyWith3Alive count]);
    STAssertNotNil([nextGenEmptyWith3Alive member:coor0], @"cell0 should not exist in the nextGenEmptyWith3Alive");
    STAssertNotNil([nextGenEmptyWith3Alive member:coor2], @"cell2 should not exist in the nextGenEmptyWith3Alive");
    STAssertNotNil([nextGenEmptyWith3Alive member:coor4], @"cell2 should not exist in the nextGenEmptyWith3Alive");
    STAssertNotNil([nextGenEmptyWith3Alive member:coor5], @"cell5 should not exist in the nextGenEmptyWith3Alive");

    
    [eco release];
    [aliveCells release];
    [emptyWith3Alive release];
    [nextGenAliveCells release];
    [nextGenEmptyWith3Alive release];
}


- (void) testEliminateEmptyCoordinatesForNextGeneration
{
    /*
     
     - - - - x
     - - + - -
     - x - + -
     - - - x x
     - - - + +        
     
     */
    
    NSMutableSet* nextGenAliveCells = [[NSMutableSet alloc] init];
    
    // Create empty positions with 3 alive (x)
    Matrix2DCoordenate* coor0 = [[Matrix2DCoordenate alloc] initWithRow:0 andColumn:4];
    Cell* cell0 = [[Cell alloc] initWithCoordinate:coor0 andOrganismID:-1];
    Matrix2DCoordenate* coor2 = [[Matrix2DCoordenate alloc] initWithRow:2 andColumn:1];
    Cell* cell2 = [[Cell alloc] initWithCoordinate:coor2 andOrganismID:-1];   
    Matrix2DCoordenate* coor4 = [[Matrix2DCoordenate alloc] initWithRow:3 andColumn:3];
    Cell* cell4 = [[Cell alloc] initWithCoordinate:coor4 andOrganismID:-1];
    Matrix2DCoordenate* coor5 = [[Matrix2DCoordenate alloc] initWithRow:3 andColumn:4];
    Cell* cell5 = [[Cell alloc] initWithCoordinate:coor5 andOrganismID:-1];

    // create alive (+)
    Matrix2DCoordenate* coor1 = [[Matrix2DCoordenate alloc] initWithRow:1 andColumn:2];
    Cell* cell1 = [[Cell alloc] initWithCoordinate:coor1 andOrganismID:-1];
    Matrix2DCoordenate* coor3 = [[Matrix2DCoordenate alloc] initWithRow:2 andColumn:3];
    Cell* cell3 = [[Cell alloc] initWithCoordinate:coor3 andOrganismID:-1];
    Matrix2DCoordenate* coor6 = [[Matrix2DCoordenate alloc] initWithRow:4 andColumn:3];
    Cell* cell6 = [[Cell alloc] initWithCoordinate:coor6 andOrganismID:-1];
    Matrix2DCoordenate* coor7 = [[Matrix2DCoordenate alloc] initWithRow:4 andColumn:4];
    Cell* cell7 = [[Cell alloc] initWithCoordinate:coor7 andOrganismID:-1];
    
    [nextGenAliveCells addObject:cell1];
    [nextGenAliveCells addObject:cell3];
    [nextGenAliveCells addObject:cell6];
    [nextGenAliveCells addObject:cell7];
    
    [coor1 release];[cell1 release];
    [coor3 release];[cell3 release];
    [coor6 release];[cell6 release];
    [coor7 release];[cell7 release];
    
        
    // Create next generation sets
    NSMutableSet* aliveCells = [[NSMutableSet alloc] init];
    NSMutableSet* emptyWith3Alive = [[NSMutableSet alloc] init];    
    NSMutableSet* nextGenEmptyWith3Alive = [[NSMutableSet alloc] init];
    [nextGenEmptyWith3Alive addObject:coor0];
    [nextGenEmptyWith3Alive addObject:coor2];
    [nextGenEmptyWith3Alive addObject:coor5];
    [nextGenEmptyWith3Alive addObject:coor4];
    
    [coor0 release];
    [coor2 release];
    [coor5 release];
    [coor4 release];

    
    
    // Create the ecosystem and set the structures
    Ecosystem* eco = [[Ecosystem alloc] initWithRows:5 andColumns:5 andInitialPopulation:aliveCells];
    [eco setValue:emptyWith3Alive forKey:@"emptyWith3Alive"];
    [eco setValue:nextGenAliveCells forKey:@"nextGenAliveCells"];
    [eco setValue:nextGenEmptyWith3Alive forKey:@"nextGenEmptyWith3Alive"];
    
    
    [eco eliminateEmptyCoordinatesForNextGeneration];
    
    for(Matrix2DCoordenate* c in nextGenEmptyWith3Alive)
    {
        NSLog(@"coor row:%i, col:%i", c.row, c.column);
    }
    
    STAssertTrue([nextGenEmptyWith3Alive count]==2, @"eliminateEmptyCoordinatesForNextGeneration should have 2 elements %i", [nextGenEmptyWith3Alive count]);
    STAssertNotNil([nextGenEmptyWith3Alive member:cell4.coordinate], @"cell4 should exist in the nextGenAlive");
    STAssertNotNil([nextGenEmptyWith3Alive member:cell5.coordinate], @"cell5 should exist in the nextGenAlive");
    
    
    [eco release];
    [aliveCells release];
    [emptyWith3Alive release];
    [nextGenAliveCells release];
    [nextGenEmptyWith3Alive release];
}

- (void) testFindEmptyPostionsWithThreeAliveForNextGeneration
{
    /*
     
     - - - - x
     - - x o -
     - x - x o
     - - - x x
     - - - x o        
     
     */
    
    Matrix2DCoordenate* newCoor1 = [[Matrix2DCoordenate alloc] initWithRow:1 andColumn:3];
    Matrix2DCoordenate* newCoor2 = [[Matrix2DCoordenate alloc] initWithRow:2 andColumn:4];
    Matrix2DCoordenate* newCoor3 = [[Matrix2DCoordenate alloc] initWithRow:4 andColumn:4];
    
    Matrix2DCoordenate* coor0 = [[Matrix2DCoordenate alloc] initWithRow:0 andColumn:4];
    Cell* cell0 = [[Cell alloc] initWithCoordinate:coor0 andOrganismID:-1];
    Matrix2DCoordenate* coor1 = [[Matrix2DCoordenate alloc] initWithRow:1 andColumn:2];
    Cell* cell1 = [[Cell alloc] initWithCoordinate:coor1 andOrganismID:-1];
    Matrix2DCoordenate* coor2 = [[Matrix2DCoordenate alloc] initWithRow:2 andColumn:1];
    Cell* cell2 = [[Cell alloc] initWithCoordinate:coor2 andOrganismID:-1];   
    Matrix2DCoordenate* coor3 = [[Matrix2DCoordenate alloc] initWithRow:2 andColumn:3];
    Cell* cell3 = [[Cell alloc] initWithCoordinate:coor3 andOrganismID:-1];
    Matrix2DCoordenate* coor4 = [[Matrix2DCoordenate alloc] initWithRow:3 andColumn:3];
    Cell* cell4 = [[Cell alloc] initWithCoordinate:coor4 andOrganismID:-1];
    Matrix2DCoordenate* coor5 = [[Matrix2DCoordenate alloc] initWithRow:3 andColumn:4];
    Cell* cell5 = [[Cell alloc] initWithCoordinate:coor5 andOrganismID:-1];
    Matrix2DCoordenate* coor6 = [[Matrix2DCoordenate alloc] initWithRow:4 andColumn:3];
    Cell* cell6 = [[Cell alloc] initWithCoordinate:coor6 andOrganismID:-1];
    
    NSMutableSet* nextGenAliveCells = [[NSMutableSet alloc] init];
    NSMutableSet* aliveCells = [[NSMutableSet alloc] init];
    NSMutableSet* emptyWith3Alive = [[NSMutableSet alloc] init];    
    NSMutableSet* nextGenEmptyWith3Alive = [[NSMutableSet alloc] init];    
    
    [nextGenAliveCells addObject:cell0];
    [nextGenAliveCells addObject:cell1];
    [nextGenAliveCells addObject:cell2];
    [nextGenAliveCells addObject:cell3];
    [nextGenAliveCells addObject:cell4];
    [nextGenAliveCells addObject:cell5];
    [nextGenAliveCells addObject:cell6];

    
    // Create the ecosystem and set the structures
    Ecosystem* eco = [[Ecosystem alloc] initWithRows:5 andColumns:5 andInitialPopulation:aliveCells];
    [eco setValue:emptyWith3Alive forKey:@"emptyWith3Alive"];
    [eco setValue:nextGenAliveCells forKey:@"nextGenAliveCells"];
    [eco setValue:nextGenEmptyWith3Alive forKey:@"nextGenEmptyWith3Alive"];
    
    
    [eco findEmptyPostionsWith3AliveForSet:nextGenAliveCells andEmptyWith3Set:nextGenEmptyWith3Alive];
    
    for(Matrix2DCoordenate* c in nextGenEmptyWith3Alive)
    {
        NSLog(@"coor row:%i, col:%i", c.row, c.column);
    }
    
    
    STAssertTrue([nextGenEmptyWith3Alive count]==3, @"eliminateEmptyCoordinatesForNextGeneration should have 3 elements %i", [nextGenEmptyWith3Alive count]);
    STAssertNotNil([nextGenEmptyWith3Alive member:newCoor1], @"newCoor1 should exist in the nextGenEmptyWith3Alive");
    STAssertNotNil([nextGenEmptyWith3Alive member:newCoor2], @"newCoor2 should exist in the nextGenEmptyWith3Alive");
    STAssertNotNil([nextGenEmptyWith3Alive member:newCoor3], @"newCoor3 should exist in the nextGenEmptyWith3Alive");
    
        
    [coor0 release];[cell0 release];
    [coor1 release];[cell1 release];
    [coor2 release];[cell2 release];
    [coor3 release];[cell3 release];
    [coor4 release];[cell4 release];
    [coor5 release];[cell5 release];
    [coor6 release];[cell6 release];
        
    [newCoor1 release];
    [newCoor2 release];
    [newCoor3 release];
    
    [eco release];
    [aliveCells release];
    [emptyWith3Alive release];
    [nextGenAliveCells release];
    [nextGenEmptyWith3Alive release];

}

@end
