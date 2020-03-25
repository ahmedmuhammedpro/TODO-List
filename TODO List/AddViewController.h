#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "Todo.h"
#import "TodosObserverProt.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTV;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priorityPicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property id<TodosObserverProt> todosObserver;

- (IBAction)save:(UIButton *)sender;


@end

NS_ASSUME_NONNULL_END
