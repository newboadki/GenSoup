//
//  2DMatrixCoordenate.m
//  GenSoup
//
//  Created by Borja Arias Drake on 22/05/2011.
//  Copyright 2011 Unboxed Consulting. All rights reserved.
//

#import "Matrix2DCoordenate.h"


@implementation Matrix2DCoordenate

@synthesize row;
@synthesize column;


- (id) initWithRow:(int)r andColumn:(int)c
{
    /***********************************************************************************************/
    /* Designated init method.                                                                     */
	/***********************************************************************************************/
    if((self = [super init]))
    {
        self.row = r;
        self.column = c;
    }
    
    return self;
}


- (id) copyWithZone:(NSZone *)zone
{
    /***********************************************************************************************/
    /* Creates a copy of this instance                                                             */
	/***********************************************************************************************/
    Matrix2DCoordenate* coordinateCopy = [[self class] allocWithZone:zone];
    
    [coordinateCopy setRow:self.row];
    [coordinateCopy setColumn:self.column];
    
    return coordinateCopy;
}


- (BOOL) isEqual:(id)object
{
    /***********************************************************************************************/
    /* Two coordinates are equal if their rows and columns are equal.                              */
	/***********************************************************************************************/
    Matrix2DCoordenate* c = (Matrix2DCoordenate*) object;
    
    return (self.row == c.row) && (self.column == c.column); 
}


- (NSUInteger) hash
{
    /***********************************************************************************************/
    /* If two objects are equal (as determined by the isEqual: method), they must have the same    */
    /* hash value.                                                                                 */
	/***********************************************************************************************/
    NSString* h = [NSString stringWithFormat:@"%d%d", self->row, self->column];
    
    return [h intValue];
}



#pragma mark - NSCoding Protocol

- (id)initWithCoder:(NSCoder *)decoder
{
    if ([super init])
    {
        row = [decoder decodeIntForKey:ROW_ARCHIVE_KEY];
        column = [decoder decodeIntForKey:COLUMN_ARCHIVE_KEY];
    }
    
    return self;
}


- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInt:row forKey:ROW_ARCHIVE_KEY];
    [encoder encodeInt:column forKey:COLUMN_ARCHIVE_KEY];
}


@end
