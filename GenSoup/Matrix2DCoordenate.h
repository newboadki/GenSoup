//
//  2DMatrixCoordenate.h
//  GenSoup
//
//  Created by Borja Arias Drake on 22/05/2011.
//  Copyright 2011 Unboxed Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Matrix2DCoordenate : NSObject <NSCopying>
{
    int row;
    int column;
}

@property (nonatomic, assign) int row;
@property (nonatomic, assign) int column;

- (id) initWithRow:(int)r andColumn:(int)c;

@end
