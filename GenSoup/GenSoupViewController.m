//
//  GenSoupViewController.m
//  GenSoup
//
//  Created by Borja Arias Drake on 22/05/2011.
//  Copyright 2011 Unboxed Consulting. All rights reserved.
//

#import "GenSoupViewController.h"

#define NUMBER_OF_ROWS   41
#define NUMBER_OF_COLUMS 32

@interface GenSoupViewController()
- (void) produceNextGeneration;
- (void) startLife;
- (void) configureScrollView;
- (void) setUpToolBarItems;
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
        
    // Set initial population to empty set
    NSMutableSet* set = [[NSMutableSet alloc] init];
    [self setInitialPopulation:set];
    [set release];    
    
    [self setUpToolBarItems];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Configure this controller's view layout
    [self configureScrollView];
    
    // Compose the view. This method needs to be called before anything else on the ecosystemView. As many methods relay on that view having subviews
    [ecosystemView setUpCellViewsWith:NUMBER_OF_ROWS columns:NUMBER_OF_COLUMS cellViewWidth:10 cellViewHeight:10.15];
    
    // Set the tap delegate for this controller's view
    [self.ecosystemView setTapDelegate:self];  // TODO, this methods needs to be called after setUpCellViewWith:columns:cellViewWidth:cellViewHeight: Make these two methods one. and make setUpCellViewWith:columns:cellViewWidth:cellViewHeight receive a parameter for the delegate.
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
}


- (void) produceNextGeneration
{
    /***********************************************************************************************/
    /* Update the model and the view, concordantly.                                                */
	/***********************************************************************************************/

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



#pragma mark - Actions for buttons

- (IBAction) loadButtonPressed:(id)sender
{

}


- (IBAction) menuButtonPressed:(id)sender
{
    if([[self navigationController] isToolbarHidden])
    {
        [[[[self navigationController] navigationItem] rightBarButtonItem] setTitle:@"Hide"];
        [[self navigationController] setToolbarHidden:NO animated:NO];
    }
    else
    {
        [[[[self navigationController] navigationItem] rightBarButtonItem] setTitle:@"Menu"];
        [[self navigationController] setToolbarHidden:YES animated:NO];
    }
}



#pragma mark - Helper Methods

- (void) configureScrollView
{
    /***********************************************************************************************/
    /* Set layout of this controllers view.                                                        */
    /* Configure Long press gesture for the scroll view, and it's zooming variables.               */
	/***********************************************************************************************/       
    // Configure Zoom
    UIScrollView* scrollView = (UIScrollView*)self.view;
    [scrollView setMinimumZoomScale:1.0];
    [scrollView setMaximumZoomScale:4.0];
    [scrollView setZoomScale:1.0];
}


- (void) setUpToolBarItems
{
    UIBarButtonItem* playButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(startLife)];
    self.toolbarItems = [NSArray arrayWithObject:playButton];
    [playButton release];
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