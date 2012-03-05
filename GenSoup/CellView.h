//
//  CellView.h
//  GenSoup
//
//  Created by Borja Arias Drake on 26/06/2011.
//  Copyright 2011 Unboxed Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Matrix2DCoordenate.h"
#import <QuartzCore/QuartzCore.h>
#import "CellViewDelegateProtocol.h"


@interface CellView : UIView
{
    
}

@property (nonatomic, retain, readonly) Matrix2DCoordenate* coordinate;
@property (nonatomic, assign) id <CellViewDelegateProtocol> tapDelegate;

- (id)initWithFrame:(CGRect)frame andColor:(UIColor*)theColor andCoordinate:(Matrix2DCoordenate*)coord;
- (void) setColorForAge:(int)age;

@end
