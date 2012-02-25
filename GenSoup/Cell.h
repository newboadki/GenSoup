//
//  Cell.h
//  GenSoup
//
//  Created by Borja Arias Drake on 22/05/2011.
//  Copyright 2011 Unboxed Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Matrix2DCoordenate.h"

#define COORDINATE_ARCHIVE_KEY @"coodinateArchiveKey"
#define ORGANISM_ID_ARCHIVE_KEY @"organismIdArchiveKey"

@interface Cell : NSObject <NSCopying, NSCoding>
{
    Matrix2DCoordenate* coordinate;
    int organismID;
}

@property (retain, nonatomic) Matrix2DCoordenate* coordinate;
@property (assign, nonatomic) int organismID;

- (id) initWithCoordinate:(Matrix2DCoordenate*)position andOrganismID:(int)theOrganismID;

@end
