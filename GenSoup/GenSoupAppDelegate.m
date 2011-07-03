//
//  GenSoupAppDelegate.m
//  GenSoup
//
//  Created by Borja Arias Drake on 22/05/2011.
//  Copyright 2011 Unboxed Consulting. All rights reserved.
//

#import "GenSoupAppDelegate.h"
#import "GenSoupViewController.h"
#import "Cell.h"
#import "Matrix2DCoordenate.h"
#import "Ecosystem.h"

@implementation GenSoupAppDelegate


@synthesize window=_window;

@synthesize viewController=_viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

    /*     
     - - + - -
     - - + + -
     - - - + +
     - - + + -
     - - + - -             
     */

    /*
    Matrix2DCoordenate* coor0 = [[Matrix2DCoordenate alloc] initWithRow:0 andColumn:2];
    Cell* cell0 = [[Cell alloc] initWithCoordinate:coor0 andOrganismID:-1];
    Matrix2DCoordenate* coor1 = [[Matrix2DCoordenate alloc] initWithRow:1 andColumn:2];
    Cell* cell1 = [[Cell alloc] initWithCoordinate:coor1 andOrganismID:-1];
    Matrix2DCoordenate* coor2 = [[Matrix2DCoordenate alloc] initWithRow:1 andColumn:3];
    Cell* cell2 = [[Cell alloc] initWithCoordinate:coor2 andOrganismID:-1];   
    Matrix2DCoordenate* coor3 = [[Matrix2DCoordenate alloc] initWithRow:2 andColumn:3];
    Cell* cell3 = [[Cell alloc] initWithCoordinate:coor3 andOrganismID:-1];
    Matrix2DCoordenate* coor4 = [[Matrix2DCoordenate alloc] initWithRow:2 andColumn:4];
    Cell* cell4 = [[Cell alloc] initWithCoordinate:coor4 andOrganismID:-1];
    Matrix2DCoordenate* coor5 = [[Matrix2DCoordenate alloc] initWithRow:3 andColumn:3];
    Cell* cell5 = [[Cell alloc] initWithCoordinate:coor5 andOrganismID:-1];
    Matrix2DCoordenate* coor6 = [[Matrix2DCoordenate alloc] initWithRow:3 andColumn:2];
    Cell* cell6 = [[Cell alloc] initWithCoordinate:coor6 andOrganismID:-1];
    Matrix2DCoordenate* coor7 = [[Matrix2DCoordenate alloc] initWithRow:4 andColumn:2];
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
    
    Ecosystem* ecosystem = [[Ecosystem alloc] initWithRows:50 andColumns:50 andInitialPopulation:aliveCells];
    
    for (int i=0; i<40; i++)
    {
        [ecosystem produceNextGeneration];
        [ecosystem printToConsole];
        NSLog(@"\n");
    }
    
    NSLog(@"\n");
    //[ecosystem printToConsole];    
    
    */
    
    

    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

@end
