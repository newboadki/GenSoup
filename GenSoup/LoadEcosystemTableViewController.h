//
//  LoadEcosystemTableViewController.h
//  GenSoup
//
//  Created by Borja Arias on 27/02/2012.
//  Copyright (c) 2012 Unboxed Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoadEcosystemViewControllerDelegateProtocol <NSObject>
- (void) loadControllerReadyForDismissalWithName:(NSString*)ecosystemName;
- (void) loadControllerWasCancel;
@end


@interface LoadEcosystemTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSArray* savedEcosystems;
    IBOutlet UITableView* tableView;
    id <LoadEcosystemViewControllerDelegateProtocol> delegate;
}

@property (retain, nonatomic) NSArray* savedEcosystems;
@property (retain, nonatomic) UITableView* tableView;
@property (nonatomic, assign) id <LoadEcosystemViewControllerDelegateProtocol> delegate;


- (IBAction) cancelButtonPressed:(id)sender;

@end
