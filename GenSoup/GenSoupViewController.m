//
//  GenSoupViewController.m
//  GenSoup
//
//  Created by Borja Arias Drake on 22/05/2011.
//  Copyright 2011 Unboxed Consulting. All rights reserved.
//

#import "GenSoupViewController.h"

#define NUMBER_OF_ROWS   48
#define NUMBER_OF_COLUMS 32

@interface GenSoupViewController()
- (void) produceNextGeneration;
- (void) startLife;
- (void) configureScrollView;
@end


@implementation GenSoupViewController

@synthesize ecosystem;
@synthesize ecosystemView;
@synthesize initialPopulation;



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    /***********************************************************************************************/
    /* Implement viewDidLoad to do additional setup after loading the view, typically from a nib.  */
	/***********************************************************************************************/   
    [super viewDidLoad];
    
    // Configure this controller's view layout
    [self configureScrollView];
    
    // Compose the view. This method needs to be called before anything else on the ecosystemView. As many methods relay on that view having subviews
    [ecosystemView setUpCellViewsWith:NUMBER_OF_ROWS columns:NUMBER_OF_COLUMS cellViewWidth:10.0 cellViewHeight:10.0];
    
    // Set the tap delegate for this controller's view
    [ecosystemView setTapDelegate:self];        
    
    // Set initial population to empty set
    NSMutableSet* set = [[NSMutableSet alloc] init];
    [self setInitialPopulation:set];
    [set release];    
}


- (void)viewDidUnload
{
    /***********************************************************************************************/
    /* Release any retained subviews of the main view. e.g. self.myOutlet = nil;                   */
	/***********************************************************************************************/   
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    /***********************************************************************************************/
    /* Return YES for supported orientations                                                       */
	/***********************************************************************************************/   
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - Model & View Interaction

- (void) startLife
{
    /***********************************************************************************************/
    /* Configure an NSTimer that will create a new generation each 0.3 seconds.                    */
	/***********************************************************************************************/   
    Ecosystem* eco = [[Ecosystem alloc] initWithRows:NUMBER_OF_ROWS andColumns:NUMBER_OF_COLUMS andInitialPopulation:initialPopulation];        
    [self setEcosystem:eco];
    [eco release];
    
    [self.ecosystem setDelegate:self];
    [self.ecosystem produceNextGeneration];
    //[self produceNextGeneration];
    //[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(produceNextGeneration) userInfo:nil repeats:YES];
}


- (void) produceNextGeneration
{
    /***********************************************************************************************/
    /* Update the model and the view, concordantly.                                                */
	/***********************************************************************************************/
    //[NSThread detachNewThreadSelector:@selector(produceNextGeneration) toTarget:self.ecosystem withObject:nil];
}


- (void) handleNewGeneration
{
    [self.ecosystemView refreshView:self.ecosystem];    
    [self.ecosystem produceNextGeneration];
}



#pragma mark - UIScrollViewDelegate Protocol Methods 

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    /***********************************************************************************************/
    /* Returns the view to be zoomed in and out.                                                   */
	/***********************************************************************************************/   
    return self.ecosystemView;
}


#pragma mark - CellViewDelegateProtocol

- (void) didSelectCellViewAtCoordinate:(Matrix2DCoordenate*)coordinate
{
    /***********************************************************************************************/
    /* Update the model and view. We basically toogle the state of that cell.                      */
	/***********************************************************************************************/
    Matrix2DCoordenate* coordinateCopy = [coordinate copy];
    Cell* cell = [[Cell alloc] initWithCoordinate:coordinateCopy andOrganismID:-1];    
    [coordinateCopy release];
    
    if ([initialPopulation member:cell])
    {
        [initialPopulation removeObject:cell];
    }
    else
    {
        [initialPopulation addObject:cell];
    }
    
    [cell release];
}



#pragma mark - Helper Methods

- (void) configureScrollView
{
    /***********************************************************************************************/
    /* Set layout of this controllers view.                                                        */
    /* Configure Long press gesture for the scroll view, and it's zooming variables.               */
	/***********************************************************************************************/   
    // Layout the view
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self setWantsFullScreenLayout:YES];
    
    // Add gesture recogniser
    UIScrollView* scrollView = (UIScrollView*)self.view;
    UILongPressGestureRecognizer* gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(startLife)];
    [gr setMinimumPressDuration:2];
    [scrollView addGestureRecognizer:gr];
    [gr release];
    
    // Configure Zoom
    [scrollView setMinimumZoomScale:1.0];
    [scrollView setMaximumZoomScale:4.0];
    [scrollView setZoomScale:1.0];
}



#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    /***********************************************************************************************/
    /* Releases the view if it doesn't have a superview. Release any cached data, images, etc      */
    /* that aren't in use.                                                                         */
	/***********************************************************************************************/
    [super didReceiveMemoryWarning];
}


- (void)dealloc
{
    /***********************************************************************************************/
    /* Tidy-up.                                                                                    */
	/***********************************************************************************************/
    [self setEcosystem:nil];
    self.ecosystemView.tapDelegate = nil;
    [self setEcosystemView:nil];
    [self setInitialPopulation:nil];
    
    
    [super dealloc];
}

@end