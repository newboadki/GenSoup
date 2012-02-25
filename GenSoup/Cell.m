//
//  Cell.m
//  GenSoup
//
//  Created by Borja Arias Drake on 22/05/2011.
//  Copyright 2011 Unboxed Consulting. All rights reserved.
//

#import "Cell.h"


@implementation Cell

@synthesize coordinate;
@synthesize organismID;


- (id) initWithCoordinate:(Matrix2DCoordenate*)position andOrganismID:(int)theOrganismID
{
    /***********************************************************************************************/
    /* Designated init method.                                                                     */
	/***********************************************************************************************/
    if((self = [super init]))
    {        
        [self setCoordinate:position];
        self->organismID = theOrganismID;
    }
    
    return self;
}


- (id) init
{
    /***********************************************************************************************/
    /* init method.                                                                                */
	/***********************************************************************************************/
    @throw @"use initWithCoordinate:AndOrganismID instead.";
}


- (id) copyWithZone:(NSZone *)zone
{
    /***********************************************************************************************/
    /* Returns a copy of this instance.                                                            */
	/***********************************************************************************************/
    Cell* cellCopy = [[self class] allocWithZone:zone];
    
    Matrix2DCoordenate* coordinateCopy = [[[self coordinate] copy] autorelease];
    [cellCopy setCoordinate:coordinateCopy];
    [cellCopy setOrganismID:self.organismID];
    
    return cellCopy;
}


- (BOOL) isEqual:(id)object
{
    /***********************************************************************************************/
    /* Two cells are equal if they share the same coordinate and organism ID                       */
	/***********************************************************************************************/
    Cell* c = (Cell*) object;
    
    return ([self->coordinate isEqual:c.coordinate]) && (self.organismID == c.organismID); 
}


- (NSUInteger) hash
{
    /***********************************************************************************************/
    /* If two objects are equal (as determined by the isEqual: method), they must have the same    */
    /* hash value.                                                                                 */
	/***********************************************************************************************/
    NSString* h = [NSString stringWithFormat:@"%d%d", self->organismID, [self->coordinate hash]];
    
    return [h intValue];
}



#pragma mark - NSCoding Protocol

- (id)initWithCoder:(NSCoder *)decoder
{
    if ([super init])
    {
        coordinate = [[decoder decodeObjectForKey:COORDINATE_ARCHIVE_KEY] retain];
        organismID = [decoder decodeIntForKey:ORGANISM_ID_ARCHIVE_KEY];
    }
    
    return self;
}


- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:coordinate forKey:COORDINATE_ARCHIVE_KEY];
    [encoder encodeInt:organismID forKey:ORGANISM_ID_ARCHIVE_KEY];
}



#pragma mark - Memory Management

- (void) dealloc
{
    /***********************************************************************************************/
    /* Tidy-up                                                                                     */
	/***********************************************************************************************/
    [self setCoordinate:nil];
    [super dealloc];    
}


@end
