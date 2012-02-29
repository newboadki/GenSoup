//
//  EcosystemViewTests.m
//  GenSoup
//
//  Created by Borja Arias Drake on 02/07/2011.
//  Copyright 2011 Unboxed Consulting. All rights reserved.
//

#import "EcosystemViewTests.h"


@implementation EcosystemViewTests


- (void) setUp
{
    view = [[EcosystemView alloc] init];
}


- (void) tearDown
{
    [view release];
}


- (void) testSetUpCellViews
{
    [view setUpCellViewsWith:48 columns:32 cellViewWidth:10.0 cellViewHeight:10.0];
    STAssertTrue([[view subviews] count] == 48*32, @"setUpcEllViews should create the cellsViews %i", [[view subviews] count]);
    
    CellView* cv = (CellView*)[[view subviews] objectAtIndex:0];
    STAssertTrue(cv.coordinate.row==0, @"setUpCellViews doesn't assign well the coordinates");
    STAssertTrue(cv.coordinate.column==0, @"setUpCellViews doesn't assign well the coordinates");
    STAssertTrue([[cv backgroundColor] isEqual:[UIColor grayColor]], @"setUpCellViews doesn't assign a gray color");
}

- (void) testRefreshView
{
    Matrix2DCoordenate* coord0 = [[Matrix2DCoordenate alloc] initWithRow:0 andColumn:0];
    Cell* cell0 = [[Cell alloc] initWithCoordinate:coord0 andOrganismID:-1];
    Matrix2DCoordenate* coord1 = [[Matrix2DCoordenate alloc] initWithRow:2 andColumn:0];
    CellView* cellView1 = [[CellView alloc] initWithFrame:CGRectZero andColor:[UIColor yellowColor] andCoordinate:coord1];
    
    NSMutableSet* initialPopulation = [[NSMutableSet alloc] init];
    NSMutableSet* activeCells = [[NSMutableSet alloc] init];
    [initialPopulation addObject:cell0];
    [activeCells addObject:cellView1];
    
    [view setActiveCellViews:activeCells];
    Ecosystem* ecosystem = [[Ecosystem alloc] initWithRows:48 andColumns:32 andInitialPopulation:initialPopulation];

    [view setUpCellViewsWith:48 columns:32 cellViewWidth:10.0 cellViewHeight:10.0];
    [ecosystem setValue:initialPopulation forKey:@"aliveCells"]; // this used to be set in the init method. After changes that does not happen
    [view refreshView:ecosystem];
    
    STAssertTrue([activeCells count]==1, @"active cells shouls have count of 1, found %i", [activeCells count]==1);
    STAssertTrue([[cellView1 backgroundColor] isEqual:[UIColor grayColor]],@"the cell that stopped being active should have gray color");
    CellView* cv = (CellView*)[[view subviews] objectAtIndex:0];
    STAssertTrue(cv.coordinate.row==0, @"the new active cell should have row 0");
    STAssertTrue(cv.coordinate.column==0, @"the new active cell should have col 0");
    STAssertTrue([[cv backgroundColor] isEqual:[UIColor yellowColor]],@"the cell that becomes  active should have yellow color");
    
    [coord0 release];
    [coord1 release];
    [cell0 release];
    [ecosystem release];
    [cellView1 release];
    [initialPopulation release];

}
/*
 - (void) reset
 {
 [activeCellViews removeAllObjects];
 
 for (CellView* cv in [self subviews])
 {
 [cv setBackgroundColor:[UIColor grayColor]];
 }
 }

  */
- (void) testReset
{
    Matrix2DCoordenate* coord0 = [[Matrix2DCoordenate alloc] initWithRow:0 andColumn:0];
    Cell* cell0 = [[Cell alloc] initWithCoordinate:coord0 andOrganismID:-1];
    Matrix2DCoordenate* coord1 = [[Matrix2DCoordenate alloc] initWithRow:2 andColumn:0];
    CellView* cellView0 = [[CellView alloc] initWithFrame:CGRectZero andColor:[UIColor yellowColor] andCoordinate:coord0];
    CellView* cellView1 = [[CellView alloc] initWithFrame:CGRectZero andColor:[UIColor yellowColor] andCoordinate:coord1];

    
    NSMutableSet* activeCells = [[NSMutableSet alloc] init];
    [activeCells addObject:cell0];
    [activeCells addObject:cellView1];
    
    [view setActiveCellViews:activeCells];
    [view addSubview:cellView0];
    [view addSubview:cellView1];

    
    [view reset];
    
    STAssertTrue([activeCells count]==0, @"active cells shouls have count of 0, found %i", [activeCells count]);
    STAssertTrue([[cellView1 backgroundColor] isEqual:[UIColor grayColor]],@"the cell that stopped being active should have gray color");
    STAssertTrue([[cellView0 backgroundColor] isEqual:[UIColor grayColor]],@"the cell that stopped being active should have gray color");
    
    [coord0 release];
    [coord1 release];
    [cell0 release];
    [cellView0 release];
    [cellView1 release];
    
}

- (void) testSetTapDelegate
{
    GenSoupViewController* controller = [[GenSoupViewController alloc] init];

    [view setUpCellViewsWith:48 columns:32 cellViewWidth:10.0 cellViewHeight:10.0];
    [view setTapDelegate:controller];
    id delegate = [view valueForKey:@"tapDelegate"];
    CellView* cellView1 = [[view subviews] objectAtIndex:4];
    CellView* cellView2 = [[view subviews] objectAtIndex:56];
    STAssertTrue([delegate isEqual:controller], @"setTapDelegate does not set the private poperty");
    STAssertTrue([[cellView1 tapDelegate] isEqual:controller], @"setTapDelegate does not set the delegate poperty for the cellviews");
    STAssertTrue([[cellView2 tapDelegate] isEqual:controller], @"setTapDelegate does not set the delegate poperty for the cellviews");
    
    [controller release];
}

- (void) testInitWithCoder
{
    id mock = [OCMockObject niceMockForClass:[NSCoder class]];
    EcosystemView* ev = [[EcosystemView alloc] initWithCoder:mock];
    STAssertNotNil(ev.activeCellViews, @"ActiveCellViews should not be nil after initialisation");

    [self testSetUpCellViews];
}


@end
