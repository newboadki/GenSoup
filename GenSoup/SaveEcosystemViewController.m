//
//  SaveEcosystemViewController.m
//  GenSoup
//
//  Created by Borja Arias on 25/02/2012.
//  Copyright (c) 2012 Unboxed Consulting. All rights reserved.
//

#import "SaveEcosystemViewController.h"

@implementation SaveEcosystemViewController

@synthesize tableView, cellFromNib, delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [tableView release];
    tableView = nil;
    [cellFromNib release];
    cellFromNib = nil;
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - Actions

- (IBAction) cancelButtonPressed:(id)sender
{
    [delegate saveControllerWasCancel];
}


- (IBAction) saveButtonPressed:(id)sender
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITextField* textField = (UITextField*)[cell viewWithTag:TEXT_FIELD_TAG];
    NSString* text = [textField text];
    
    if ([text length] > 0)
    {
        [delegate saveControllerreadyForDismissalWithName:text];
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                            message:@"Please enter a name for the ecosystem." 
                                                           delegate:nil 
                                                  cancelButtonTitle:@"Ok" 
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{    
	return 1;	
}


- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        self.cellFromNib = [[[NSBundle mainBundle] loadNibNamed:@"EditableRowCell" owner:self options:nil] objectAtIndex:0];
        cell = cellFromNib;
        self.cellFromNib = nil;    
    }
    
    return cell;
}


- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}



#pragma mark - Memory management

- (void) dealloc
{
    [tableView release];
    [cellFromNib release];
    [super dealloc];
}

@end
