//
//  CellViewTests.m
//  GenSoup
//
//  Created by Borja Arias Drake on 02/07/2011.
//  Copyright 2011 Unboxed Consulting. All rights reserved.
//

#import "CellViewTests.h"
#import "Constants.h"

@implementation CellViewTests

- (void) setUp
{

}

- (void) tearDown
{

}

- (void) testHandleSingleTapOnInactiveCell
{
    Matrix2DCoordenate* coordinate = [[Matrix2DCoordenate alloc] initWithRow:3 andColumn:5];
    CellView* cellView = [[CellView alloc] initWithFrame:CGRectZero andColor:GRAY_COLOR andCoordinate:coordinate];
    id delegateMock = [OCMockObject mockForClass:[GenSoupViewController class]];
    [[delegateMock expect] didSelectCellViewAtCoordinate:coordinate];
    
    [cellView setTapDelegate:delegateMock];
    [cellView handleSingleTap];

    STAssertTrue([[cellView backgroundColor] isEqual:[UIColor yellowColor]], @"An inactive cell should turn active when tapped.");
    
    [coordinate release];
    [cellView release];
}

- (void) testHandleSingleTapOnActiveCell
{
    Matrix2DCoordenate* coordinate = [[Matrix2DCoordenate alloc] initWithRow:3 andColumn:5];
    CellView* cellView = [[CellView alloc] initWithFrame:CGRectZero andColor:[UIColor yellowColor] andCoordinate:coordinate];
    id delegateMock = [OCMockObject mockForClass:[GenSoupViewController class]];
    [[delegateMock expect] didSelectCellViewAtCoordinate:coordinate];
    
    [cellView setTapDelegate:delegateMock];
    [cellView handleSingleTap];
    
    STAssertTrue([[cellView backgroundColor] isEqual:GRAY_COLOR], @"An inactive cell should turn active when tapped.");
    
    [coordinate release];
    [cellView release];
    
    [delegateMock verify];
}

- (void) testInitWithFrameAndColorAndCoordinate
{
    Matrix2DCoordenate* coordinate = [[Matrix2DCoordenate alloc] initWithRow:3 andColumn:5];
    CellView* cellView = [[CellView alloc] initWithFrame:CGRectZero andColor:[UIColor yellowColor] andCoordinate:coordinate];
    
    
    int grCount = [[cellView gestureRecognizers] count];
    STAssertTrue([[cellView backgroundColor] isEqual:[UIColor yellowColor]], @"Init should set the bg color.");
    STAssertTrue([[cellView coordinate] isEqual:coordinate], @"Init should set the coordinate.");
    STAssertTrue([[cellView gestureRecognizers] count]==1, @"Init should add a gesture recognizer.");
    
    [coordinate release];
    [cellView release];
    


}


@end
