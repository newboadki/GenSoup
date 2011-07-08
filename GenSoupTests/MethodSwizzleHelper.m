//
//  MethodSwizzleHelper.m
//  GenSoup
//
//  Created by Borja Arias Drake on 07/07/2011.
//  Copyright 2011 Unboxed Consulting. All rights reserved.
//

#import "MethodSwizzleHelper.h"
#import <objc/runtime.h>

@implementation MethodSwizzleHelper


void Swizzle(Class originalClass, SEL originalSelector, Class newClass, SEL newSelector)
{
    Method origMethod = class_getClassMethod(originalClass, originalSelector);
    Method newMethod = class_getInstanceMethod(newClass, newSelector);
    
    IMP fakeImplementation = method_getImplementation(newMethod);
    method_setImplementation(origMethod, fakeImplementation);
}

@end
