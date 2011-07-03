//
//  CellViewDelegateProtocol.h
//  GenSoup
//
//  Created by Borja Arias Drake on 29/06/2011.
//  Copyright 2011 Unboxed Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Matrix2DCoordenate.h"

@protocol CellViewDelegateProtocol
- (void) didSelectCellViewAtCoordinate:(Matrix2DCoordenate*)coordinate;
@end
