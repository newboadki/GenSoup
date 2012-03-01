//
//  GenSoupViewController.h
//  GenSoup
//
//  Created by Borja Arias Drake on 22/05/2011.
//  Copyright 2011 Unboxed Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Matrix2DCoordenate.h"
#import "Cell.h"
#import "CellView.h"
#import "EcosystemView.h"
#import "Ecosystem.h"
#import "CellViewDelegateProtocol.h"
#import "SaveEcosystemViewController.h"
#import "LoadEcosystemTableViewController.h"

@interface GenSoupViewController : UIViewController <UIScrollViewDelegate, CellViewDelegateProtocol, SaveEcosystemViewControllerDelegateProtocol, LoadEcosystemViewControllerDelegateProtocol>
{
    BOOL working;
    BOOL resetScheduled;
}

@property (retain, nonatomic) Ecosystem* ecosystem;
@property (retain, nonatomic) IBOutlet EcosystemView* ecosystemView;
@property (retain, nonatomic) NSMutableSet* initialPopulation;

- (void) handleNewGeneration;
- (void) resetEcosystem;
- (void) saveButtonPressed;
- (void) pauseLife;
- (void) resumeLife;


- (IBAction) loadButtonPressed:(id)sender;
- (IBAction) menuButtonPressed:(id)sender;

@end
