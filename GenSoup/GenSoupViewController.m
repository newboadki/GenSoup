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
- (void) startLife;
- (void) configureScrollView;
- (void) setUpToolBarItems;
- (BOOL) archiveEcosystemWithName:(NSString*)name;
- (id) unarchiveEcosystemWithName:(NSString*)name;
- (NSArray*) savedEcosystemsArray;
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

    // Tool bar
    [self setUpToolBarItems];  

    // Set initial population to empty set
    NSMutableSet* set = [[NSMutableSet alloc] init];
    [self setInitialPopulation:set];
    [set release];    

    // Ecosystem
    Ecosystem* eco = [[Ecosystem alloc] initWithRows:NUMBER_OF_ROWS andColumns:NUMBER_OF_COLUMS andInitialPopulation:initialPopulation];        
    [self setEcosystem:eco];
    [eco release];    
    [self.ecosystem setDelegate:self];
    
    // Flag for weather the calculation of new generations is working or not.
    working = NO;
    resetScheduled = NO;
    firstTimeViewWillAppear = YES;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (firstTimeViewWillAppear) 
    {                    
        firstTimeViewWillAppear = NO;
        
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
        [self.ecosystem setUp];
        [self.ecosystem produceNextGeneration];
    }
}


- (void) pauseLife
{
    working = NO;
}


- (void) resumeLife
{
    if (!working && ([ecosystem.aliveCells count] > 0))
    {               
        working = YES;
        [self handleNewGeneration];
    }
}


- (void) handleNewGeneration
{
    [self.ecosystemView refreshView:self.ecosystem];
    
    if (working)
    {
        if (resetScheduled)
        {
            resetScheduled = NO;        // Controller's state
            working = NO;
            [self resetEcosystem];      // Model            
        }
        else
        {
            [self.ecosystem produceNextGeneration];
        }
    }
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
    
    if ([ecosystem.initialPopulation member:cell])
    {
        [ecosystem.initialPopulation removeObject:cell];
    }
    else
    {
        [ecosystem.initialPopulation addObject:cell];
    }
    
    [cell release];
}



#pragma mark - Actions for buttons

- (IBAction) loadButtonPressed:(id)sender
{
    [self pauseLife];
    
    NSArray* savedEcosystemsPaths = [self savedEcosystemsArray];
    LoadEcosystemTableViewController* loadController = [[LoadEcosystemTableViewController alloc] init];
    loadController.savedEcosystems = savedEcosystemsPaths;
    loadController.delegate = self;
    [self presentModalViewController:loadController animated:YES];
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


- (void) scheduleReset
{
    /***********************************************************************************************/
    /* Empty all the data structures, clean the view up.                                           */
	/***********************************************************************************************/
    if (working)
    {
        resetScheduled = YES;
    }
    else
    {
        [self resetEcosystem];
    }
}


- (void) resetEcosystem
{
    [initialPopulation removeAllObjects];
    [ecosystem reset];          //model
    [self.ecosystemView reset]; // View
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
    UIBarButtonItem* resetButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(scheduleReset)];
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



#pragma mark - LoadEcosystemViewControllerDelegateProtocol

- (void) loadControllerReadyForDismissalWithName:(NSString*)ecosystemName
{
    Ecosystem* eco = (Ecosystem*)[self unarchiveEcosystemWithName:ecosystemName];
    [eco setDelegate:self];
    
    [self setEcosystem:eco];                            // Set the model
    [self.ecosystem setUp];                             // Prepare the model for execution
    [self.ecosystemView reset];                         // Prepare the view
    [self.ecosystemView refreshView:self.ecosystem];
    
    //NSLog(@"- ecosystem loaded: %d, %d, %d, %d", [[ecosystem valueForKey:@"rows"] intValue], [[ecosystem valueForKey:@"columns"] intValue], [ecosystem.initialPopulation count], [ecosystem.aliveCells count]);
    [self dismissModalViewControllerAnimated:YES];
}


- (void) loadControllerWasCancel
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self resumeLife];
    }];
}



#pragma mark - Saving the ecosystem to disk

- (BOOL) archiveEcosystemWithName:(NSString*)name
{
    //NSLog(@"- ecosystem saved: %d, %d, %d, %d", [[ecosystem valueForKey:@"rows"] intValue], [[ecosystem valueForKey:@"columns"] intValue], [ecosystem.initialPopulation count], [ecosystem.aliveCells count]);
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



- (id) unarchiveEcosystemWithName:(NSString*)name
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:name];
}


- (NSArray*) savedEcosystemsArray
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectoryPath = nil;
    NSMutableArray* results = [NSMutableArray array];
    
    if ([paths count] > 0)
    {        
        documentsDirectoryPath = [paths objectAtIndex:0];
        NSString* savedEcosystemsPath =  [documentsDirectoryPath stringByAppendingFormat:@"/%@", @"savedEcosystems"];
        NSArray* contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:savedEcosystemsPath error:nil];
        for (NSString* fileName in contents)
        {
            [results addObject:[savedEcosystemsPath stringByAppendingFormat:@"/%@", fileName]];
        }
    }
    
    return results;
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