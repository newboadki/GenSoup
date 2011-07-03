//
//  EcosystemViewTests.h
//  GenSoup
//
//  Created by Borja Arias Drake on 02/07/2011.
//  Copyright 2011 Unboxed Consulting. All rights reserved.
//
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

//  Application unit tests contain unit test code that must be injected into an application to run correctly.
//  Define USE_APPLICATION_UNIT_TEST to 0 if the unit test code is designed to be linked into an independent test executable.

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "EcosystemView.h"
#import "OCMock.h"
#import "CellView.h"
#import "Ecosystem.h"
#import "Matrix2DCoordenate.h"
#import "Cell.h"
#import "CellView.h"
#import "GenSoupViewController.h"

@interface EcosystemViewTests : SenTestCase
{
    EcosystemView* view;
}

@end
