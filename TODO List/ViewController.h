#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "Todo.h"
#import "TodosObserverProt.h"
#import "AddViewController.h"
#import "EditViewController.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property NSMutableArray *todos;

@end

