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
- (BOOL) archiveEcosystemWithName:(NSString*)name;
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
    
    working = NO;
}


- (void)viewWillAppear:(BOOL)animated
{
    if ([initialPopulation count] == 0) 
    {
        [super viewWillAppear:animated];
        
        // Configure this controller's view layout
        [self configureScrollView];
        
        // Compose the view. This method needs to be called before anything else on the ecosystemView. As many methods relay on that view having subviews
        [ecosystemView setUpCellViewsWith:NUMBER_OF_ROWS columns:NUMBER_OF_COLUMS cellViewWidth:10 cellViewHeight:10.15];
        
        // Set the tap delegate for this controller's view
        [self.ecosystemView setTapDelegate:self];  // TODO, this methods needs to be called after setUpCellViewWith:columns:cellViewWidth:cellViewHeight: Make these two methods one. and make setUpCellViewWith:columns:cellViewWidth:cellViewHeight receive a parameter for the delegate.        
    }
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
    /* The process is synchronous between the controller and the model. They ping pong each other. */
    /* The controller starts with this method. The model calculates the next gen and lets the cont */
    /* know when its ready.                                                                        */
	/***********************************************************************************************/
    if (!working)
    {
        working = YES;
        
        Ecosystem* eco = [[Ecosystem alloc] initWithRows:NUMBER_OF_ROWS andColumns:NUMBER_OF_COLUMS andInitialPopulation:initialPopulation];        
        [self setEcosystem:eco];
        [eco release];
        
        [self.ecosystem setDelegate:self];
        [self.ecosystem produceNextGeneration];
    }
}


- (void) pauseLife
{
    working = NO;
}


- (void) resumeLife
{
    working = YES;
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
    if (working)
    {
        [self.ecosystemView refreshView:self.ecosystem];    
        [self.ecosystem produceNextGeneration];
    }
}


- (void) handleResetGeneration
{
    [self.ecosystemView reset];
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


- (void) saveButtonPressed
{
    [self pauseLife];
    
    SaveEcosystemViewController* saveController = [[SaveEcosystemViewController alloc] init];
    [saveController setDelegate:self];
    [self presentModalViewController:saveController animated:YES];
    [saveController release];
}


- (void) resetEcosystem
{
    /***********************************************************************************************/
    /* Empty all the data structures, clean the view up.                                           */
	/***********************************************************************************************/
    [initialPopulation removeAllObjects];
    [ecosystem scheduleReset];
    working = NO;
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
    UIBarButtonItem* resetButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(resetEcosystem)];
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(saveButtonPressed)];

    self.toolbarItems = [NSArray arrayWithObjects:playButton, resetButton, saveButton, nil];
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



#pragma mark - SaveEcosystemViewControllerDelegateProtocol

- (void) saveControllerreadyForDismissalWithName:(NSString*)ecosystemName
{
    [self archiveEcosystemWithName:ecosystemName];
    [self dismissViewControllerAnimated:YES completion:^{
        [self resumeLife];
    }];
}


- (void) saveControllerWasCancel
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self resumeLife];
    }];
}



#pragma mark - Saving the ecosystem to disk

- (BOOL) archiveEcosystemWithName:(NSString*)name
{
    BOOL success = NO;   
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectoryPath = nil;
    
    if ([paths count] > 0)
    {        
        documentsDirectoryPath = [paths objectAtIndex:0];
        NSString* savedEcosystemsDirectoryPath = [documentsDirectoryPath stringByAppendingFormat:@"/%@", @"savedEcosystems"];
        success = [[NSFileManager defaultManager] createDirectoryAtPath:savedEcosystemsDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSString* dictionaryFilePath =  [savedEcosystemsDirectoryPath stringByAppendingFormat:@"/%@", name];
        success = success && [NSKeyedArchiver archiveRootObject:self.ecosystem toFile:dictionaryFilePath];
    }
    
    return success;
}


/*+ (id) unarchiveDataModel
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectoryPath = nil;
    id record = nil;
    
    if ([paths count] > 0)
    {        
        documentsDirectoryPath = [paths objectAtIndex:0];
        NSString* dictionaryFilePath =  [documentsDirectoryPath stringByAppendingFormat:@"/%@", MODEL_DATA_FILE_NAME];
        record = [NSKeyedUnarchiver unarchiveObjectWithFile:dictionaryFilePath];
    }
    
    return record;
}*/


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