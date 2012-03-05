//
//  EcosystemView.h
//  GenSoup
//
//  Created by Borja Arias Drake on 26/06/2011.
//  Copyright 2011 Unboxed Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellView.h"
#import "Cell.h"
#import "Ecosystem.h"
#import "CellViewDelegateProtocol.h"

@interface EcosystemView : UIView
{
    
}

@property (nonatomic, retain) NSMutableSet* activeCellViews;
@property (nonatomic, assign) id <CellViewDelegateProtocol> tapDelegate;

- (void) changeColorOfCellViewAtCoordinate:(Matrix2DCoordenate*)coord color:(UIColor*)newColor;
- (void) refreshView:(Ecosystem*)ecosystem;
- (void) setUpCellViewsWith:(int)numberOfRows columns:(int)numberOfcols cellViewWidth:(float)width cellViewHeight:(float)height;
- (void) reset;
- (UIImage*) captureView;

@end
