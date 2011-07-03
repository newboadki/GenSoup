//
//  GenSoupViewController.m
//  GenSoup
//
//  Created by Borja Arias Drake on 22/05/2011.
//  Copyright 2011 Unboxed Consulting. All rights reserved.
//

#import "GenSoupViewController.h"

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
    
    // Set initial population to empty set
    NSMutableSet* set = [[NSMutableSet alloc] init];
    [self setInitialPopulation:set];
    [set release];
    
    // Set tap delegate for this controller's view
    [ecosystemView setTapDelegate:self];
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
    Ecosystem* eco = [[Ecosystem alloc] initWithRows:48 andColumns:32 andInitialPopulation:initialPopulation];    
    [self setEcosystem:eco];
    [eco release];
    
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(produceNextGeneration) userInfo:nil repeats:YES];
}


- (void) produceNextGeneration
{
    /***********************************************************************************************/
    /* Update the model and the view, concordantly.                                                */
	/***********************************************************************************************/   
    [self.ecosystem produceNextGeneration];
    [self.ecosystemView refreshView:self.ecosystem];
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



//-------------
/*     
 - - + - -
 - - + + -
 - - - + +
 - - + + -
 - - + - -             
 */

/*Matrix2DCoordenate* coor0 = [[Matrix2DCoordenate alloc] initWithRow:1 andColumn:3];
 Cell* cell0 = [[Cell alloc] initWithCoordinate:coor0 andOrganismID:-1];
 Matrix2DCoordenate* coor1 = [[Matrix2DCoordenate alloc] initWithRow:2 andColumn:3];
 Cell* cell1 = [[Cell alloc] initWithCoordinate:coor1 andOrganismID:-1];
 Matrix2DCoordenate* coor2 = [[Matrix2DCoordenate alloc] initWithRow:2 andColumn:4];
 Cell* cell2 = [[Cell alloc] initWithCoordinate:coor2 andOrganismID:-1];   
 Matrix2DCoordenate* coor3 = [[Matrix2DCoordenate alloc] initWithRow:3 andColumn:3];
 Cell* cell3 = [[Cell alloc] initWithCoordinate:coor3 andOrganismID:-1];
 Matrix2DCoordenate* coor4 = [[Matrix2DCoordenate alloc] initWithRow:3 andColumn:5];
 Cell* cell4 = [[Cell alloc] initWithCoordinate:coor4 andOrganismID:-1];
 Matrix2DCoordenate* coor5 = [[Matrix2DCoordenate alloc] initWithRow:4 andColumn:4];
 Cell* cell5 = [[Cell alloc] initWithCoordinate:coor5 andOrganismID:-1];
 Matrix2DCoordenate* coor6 = [[Matrix2DCoordenate alloc] initWithRow:4 andColumn:3];
 Cell* cell6 = [[Cell alloc] initWithCoordinate:coor6 andOrganismID:-1];
 Matrix2DCoordenate* coor7 = [[Matrix2DCoordenate alloc] initWithRow:5 andColumn:3];
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
 
 [cell0 release];[coor0 release];
 [cell1 release];[coor1 release];
 [cell2 release];[coor2 release];
 [cell3 release];[coor3 release];
 [cell4 release];[coor4 release];
 [cell5 release];[coor5 release];
 [cell6 release];[coor6 release];
 [cell7 release];[coor7 release];
 
 Ecosystem* eco = [[Ecosystem alloc] initWithRows:48 andColumns:32 andInitialPopulation:aliveCells];    
 [self setEcosystem:eco];
 [eco release];
 
 [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(produceNextGeneration) userInfo:nil repeats:YES];
 */
