//
//  EditViewController.h
//  TODO List
//
//  Created by ahmedpro on 3/25/20.
//  Copyright © 2020 ahmedpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "Todo.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditViewController : UIViewController

@property Todo *todo;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTV;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priorityPicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)save:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
