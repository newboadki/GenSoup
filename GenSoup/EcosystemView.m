//
//  EcosystemView.m
//  GenSoup
//
//  Created by Borja Arias Drake on 26/06/2011.
//  Copyright 2011 Unboxed Consulting. All rights reserved.
//

#import "EcosystemView.h"

@interface EcosystemView()
@property int rows;
@property int columns;
@property float cellViewWidth;
@property float cellViewHeight;
@end

@implementation EcosystemView

@synthesize activeCellViews;
@synthesize tapDelegate;
@synthesize rows;
@synthesize columns;
@synthesize cellViewWidth;
@synthesize cellViewHeight;



#pragma mark - Initialisers

- (id) initWithCoder:(NSCoder *)aDecoder
{
    /***********************************************************************************************/
    /* init.                                                                                       */
	/***********************************************************************************************/
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
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
    
    for (int i=0; i<self.rows; i++)
    {
        for (int j=0; j<self.columns; j++)
        {            
            CellView* cv = (CellView*)[[self subviews] objectAtIndex:i*self.columns + j];
            [cv setTapDelegate:self.tapDelegate];
        }
    }    
}



#pragma mark - View Updaters

- (void) setUpCellViewsWith:(int)numberOfRows columns:(int)numberOfcols cellViewWidth:(float)width cellViewHeight:(float)height
{
    /***********************************************************************************************/
    /* Compose the view.                                                                           */
	/***********************************************************************************************/
    [self setRows:numberOfRows];
    [self setColumns:numberOfcols];
    [self setCellViewWidth:width];
    [self setCellViewHeight:height];
    
    for (int i=0; i<self.rows; i++)
    {
        for (int j=0; j<self.columns; j++)
        {       
            CGRect cellFrame = CGRectMake(j*self.cellViewWidth, i*self.cellViewHeight, self.cellViewWidth, self.cellViewHeight);
            Matrix2DCoordenate* cellCoordinate = [[Matrix2DCoordenate alloc] initWithRow:i andColumn:j];
            CellView* cv = [[CellView alloc] initWithFrame:cellFrame andColor:GRAY_COLOR andCoordinate:cellCoordinate];
            
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
        [cellView setBackgroundColor:GRAY_COLOR];
    }
    
    [activeCellViews removeAllObjects];
    
    for (Cell* cell in ecosystem.aliveCells)
    {
        Matrix2DCoordenate* coord = cell.coordinate;
        CellView* cv = [[self subviews] objectAtIndex:coord.row*self.columns + coord.column];
        [cv setColorForAge:cell.age];
        [activeCellViews addObject:cv];
    }
}


- (void) reset
{
    [activeCellViews removeAllObjects];
    
    for (CellView* cv in [self subviews])
    {
        [cv setBackgroundColor:GRAY_COLOR];
    }
}


- (void) changeColorOfCellViewAtCoordinate:(Matrix2DCoordenate*)coord color:(UIColor*)newColor
{    
    /***********************************************************************************************/
    /* changeColorOfCellViewAtCoordinate.                                                          */
	/***********************************************************************************************/
    CellView* cv = [[self subviews] objectAtIndex:coord.row*self.columns + coord.column];
    [cv setBackgroundColor:[UIColor yellowColor]];
}


- (UIImage*) captureView
{
    CGRect viewRect = [[UIScreen mainScreen] bounds];
    
    UIGraphicsBeginImageContext(self.frame.size);
    
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [[UIColor clearColor] set];
        CGContextFillRect(ctx, viewRect);    
        [self.layer renderInContext:ctx];    
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
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
