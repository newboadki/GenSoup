//
//  EcosystemView.m
//  GenSoup
//
//  Created by Borja Arias Drake on 26/06/2011.
//  Copyright 2011 Unboxed Consulting. All rights reserved.
//

#import "EcosystemView.h"

@interface EcosystemView()
- (void) setUpCellViews;
@end

@implementation EcosystemView

@synthesize activeCellViews;
@synthesize tapDelegate;



#pragma mark - Initialisers

- (id) initWithCoder:(NSCoder *)aDecoder
{
    /***********************************************************************************************/
    /* init.                                                                                       */
	/***********************************************************************************************/
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        // Set up the cell views to build the view.
        [self setUpCellViews];
        
        // Set an empty set as the current active cells
        NSMutableSet* set = [[NSMutableSet alloc] init];
        [self setActiveCellViews:set];
        [set release];
    }
    
    return self;
}



#pragma mark - Initialisers

- (void) setTapDelegate:(id <CellViewDelegateProtocol>) del
{
    /***********************************************************************************************/
    /* Because we are using a Nib file to create this view, the initialiser that gets called is    */
    /* initWithCoder, which doesn't take any extra parameters for a delegate for example.          */
	/***********************************************************************************************/
    self->tapDelegate = del;
    
    for (int i=0; i<48; i++)
    {
        for (int j=0; j<32; j++)
        {            
            CellView* cv = (CellView*)[[self subviews] objectAtIndex:i*32 + j];
            [cv setTapDelegate:self.tapDelegate];
        }
    }    
}



#pragma mark - View Updaters

- (void) setUpCellViews
{
    /***********************************************************************************************/
    /* Compose the view.                                                                           */
	/***********************************************************************************************/
    for (int i=0; i<48; i++)
    {
        for (int j=0; j<32; j++)
        {            
            CGRect cellFrame = CGRectMake(j*10, i*10, 10, 10);
            Matrix2DCoordenate* cellCoordinate = [[Matrix2DCoordenate alloc] initWithRow:i andColumn:j];
            CellView* cv = [[CellView alloc] initWithFrame:cellFrame andColor:[UIColor grayColor] andCoordinate:cellCoordinate];
            
            [self addSubview:cv];
            
            [cv release];
            [cellCoordinate release];
        }
    }
}


- (void) refreshView:(Ecosystem*)ecosystem
{
    /***********************************************************************************************/
    /* Given an ecosystem, we'll use its alive cells to draw the colored views. And we'll gray out */
    /* the ones that are no longer active (currently we gray out all the ones that were active.)   */
    /* TODO: Gray out only if it's not in ecosystem.activeCells                                    */
	/***********************************************************************************************/
    for (CellView* cellView in self.activeCellViews)
    {
        [cellView setBackgroundColor:[UIColor grayColor]];
    }
    
    [activeCellViews removeAllObjects];
    
    for (Cell* cell in ecosystem.aliveCells)
    {
        Matrix2DCoordenate* coord = cell.coordinate;
        CellView* cv = [[self subviews] objectAtIndex:coord.row*32 + coord.column];
        [cv setBackgroundColor:[UIColor yellowColor]];
        [activeCellViews addObject:cv];
    }
}


- (void) changeColorOfCellViewAtCoordinate:(Matrix2DCoordenate*)coord color:(UIColor*)newColor
{    
    /***********************************************************************************************/
    /* changeColorOfCellViewAtCoordinate.                                                          */
	/***********************************************************************************************/
    CellView* cv = [[self subviews] objectAtIndex:coord.row*32 + coord.column];
    [cv setBackgroundColor:[UIColor yellowColor]];
}



#pragma mark - Memory Management

- (void)dealloc
{
    /***********************************************************************************************/
    /* Tidy-up.                                                                                    */
	/***********************************************************************************************/
    [self setActiveCellViews:nil];
    
    [super dealloc];
}

@end
