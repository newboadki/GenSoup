//
//  CellView.m
//  GenSoup
//
//  Created by Borja Arias Drake on 26/06/2011.
//  Copyright 2011 Unboxed Consulting. All rights reserved.
//

#import "CellView.h"

@interface CellView()
  @property  (nonatomic, retain, readwrite) Matrix2DCoordenate* coordinate;
- (void) handleSingleTap;
@end

@implementation CellView

@synthesize coordinate;
@synthesize tapDelegate;



#pragma mark - Initialisers

- (id)initWithFrame:(CGRect)frame andColor:(UIColor*)theColor andCoordinate:(Matrix2DCoordenate*)coord
{
    /***********************************************************************************************/
    /* init.                                                                                       */
	/***********************************************************************************************/
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setCoordinate:coord];
        [self.layer setBorderWidth:0.5];
        [self.layer setBorderColor:[[UIColor blackColor] CGColor]];        
        [self setBackgroundColor:theColor];
        
        UITapGestureRecognizer* gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
        [gr setNumberOfTapsRequired:1];
        [self addGestureRecognizer:gr];
        [gr release];
    }
    
    return self;
}



#pragma mark - Event Handlers

- (void) handleSingleTap
{
    /***********************************************************************************************/
    /* Toggles the cell's color and lets the delegate know.                                        */
	/***********************************************************************************************/
    if ([self.backgroundColor isEqual:[UIColor yellowColor]])
    {
        [self setBackgroundColor:[UIColor grayColor]];
    }
    else
    {
        [self setBackgroundColor:[UIColor yellowColor]];    
    }
    
    [tapDelegate didSelectCellViewAtCoordinate:self.coordinate];
}



#pragma mark - Memory Management

- (void)dealloc
{
    /***********************************************************************************************/
    /* tidy up.                                                                                    */
	/***********************************************************************************************/
    [self setCoordinate:nil];
    
    [super dealloc];
}

@end
