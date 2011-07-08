//
//  MethodSwizzleHelper.h
//  GenSoup
//
//  Created by Borja Arias Drake on 07/07/2011.
//  Copyright 2011 Unboxed Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MethodSwizzleHelper : NSObject
{
    
}

void Swizzle(Class originalClass, SEL originalSelector, Class newClass, SEL newSelector);

@end
