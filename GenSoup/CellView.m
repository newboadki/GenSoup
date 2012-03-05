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
        [self setOpaque:YES];
        [self.layer setBorderWidth:0.5];
        [self.layer setCornerRadius:3.0];
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



#pragma mark - Customization

- (void) setColorForAge:(int)age
{
    /***********************************************************************************************/
    /* TODO: provide a more gradual array of colors.                                               */
	/***********************************************************************************************/
    UIColor* color = nil;
    
    switch (age)
    {
        case 0:
            color = [UIColor yellowColor];
            break;
        case 1:
            color = [UIColor greenColor];
            break;
        case 2:
            color = [UIColor orangeColor];
            break;
        case 3:
            color = [UIColor redColor];
            break;
        case 4:
            color = [UIColor brownColor];
            break;
        case 5:
            color = [UIColor purpleColor];
            break;
            
        default:
            color = [UIColor blackColor];
            break;
    }
    
    [self setBackgroundColor:color];
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
