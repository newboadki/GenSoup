//
//  LoadEcosystemTableViewController.m
//  GenSoup
//
//  Created by Borja Arias on 27/02/2012.
//  Copyright (c) 2012 Unboxed Consulting. All rights reserved.
//

#import "LoadEcosystemTableViewController.h"

@interface LoadEcosystemTableViewController(private)

@end

@implementation LoadEcosystemTableViewController


@synthesize savedEcosystems, builtInEcosystems;
@synthesize tableView;
@synthesize delegate;



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    builtInEcosystems = [[NSArray alloc] initWithObjects:[[NSBundle mainBundle] pathForResource:@"frog" ofType:nil], 
                                                         [[NSBundle mainBundle] pathForResource:@"glider" ofType:nil], 
                                                         [[NSBundle mainBundle] pathForResource:@"piramid" ofType:nil], 
                                                         [[NSBundle mainBundle] pathForResource:@"space_ship" ofType:nil], 
                                                         [[NSBundle mainBundle] pathForResource:@"sun_flower" ofType:nil], nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [tableView release];
    tableView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    switch (section)
    {
        case 0:
            rows = [builtInEcosystems count];
            break;
        case 1:
            rows = [savedEcosystems count];
            break;
    }
    
    return rows;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* title = nil;
    
    switch (section)
    {
        case 0:
            title = @"Examples";
            break;
        case 1:
            title = @"My own creatures";
            break;
    }
    
    return title;
}


- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSArray* dataArray = nil;
    switch ([indexPath section])
    {
        case 0:
            dataArray = builtInEcosystems;
            break;
        case 1:
            dataArray = savedEcosystems;
            break;
            
        default:
            break;
    }
    
    // Configure the cell...
    NSString* fullName = [dataArray objectAtIndex:[indexPath row]];
    NSArray* fullNameComponents = [fullName componentsSeparatedByString:@"/"];
    NSString* name = [fullNameComponents objectAtIndex:[fullNameComponents count] - 1];
    
    cell.textLabel.text = name;
    
    return cell;
}


- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* dataArray = nil;
    switch ([indexPath section])
    {
        case 0:
            dataArray = builtInEcosystems;
            break;
        case 1:
            dataArray = savedEcosystems;
            break;
            
        default:
            break;
    }

    [delegate loadControllerReadyForDismissalWithName:[dataArray objectAtIndex:indexPath.row]];
}



#pragma mark - Actions

- (IBAction) cancelButtonPressed:(id)sender
{
    [delegate loadControllerWasCancel];
}



#pragma mark - Memory Management

- (void) dealloc
{
    [savedEcosystems release];
    [builtInEcosystems release];
    [tableView dealloc];
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    // Release any cached data, images, etc that aren't in use.
    [super didReceiveMemoryWarning];        
}

@end
