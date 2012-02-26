//
//  SaveEcosystemViewController.h
//  GenSoup
//
//  Created by Borja Arias on 25/02/2012.
//  Copyright (c) 2012 Unboxed Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@protocol SaveEcosystemViewControllerDelegateProtocol <NSObject>
- (void) saveControllerreadyForDismissalWithName:(NSString*)ecosystemName;
- (void) saveControllerWasCancel;
@end

@interface SaveEcosystemViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView* tableView;
    UITableViewCell* cellFromNib;
    id <SaveEcosystemViewControllerDelegateProtocol> delegate;
}

@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic, retain) UITableViewCell* cellFromNib;
@property (nonatomic, assign) id <SaveEcosystemViewControllerDelegateProtocol> delegate;

- (IBAction) cancelButtonPressed:(id)sender;
- (IBAction) saveButtonPressed:(id)sender;
@end
