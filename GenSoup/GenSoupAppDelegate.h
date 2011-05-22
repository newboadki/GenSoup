//
//  GenSoupAppDelegate.h
//  GenSoup
//
//  Created by Borja Arias Drake on 22/05/2011.
//  Copyright 2011 Unboxed Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GenSoupViewController;

@interface GenSoupAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet GenSoupViewController *viewController;

@end
