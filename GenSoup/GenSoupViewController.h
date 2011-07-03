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


@interface GenSoupViewController : UIViewController <UIScrollViewDelegate, CellViewDelegateProtocol>
{        
}

@property (retain, nonatomic) Ecosystem* ecosystem;
@property (retain, nonatomic) IBOutlet EcosystemView* ecosystemView;
@property (retain, nonatomic) NSMutableSet* initialPopulation;

@end
