#import "AddViewController.h"

@interface AddViewController ()

@end

@implementation AddViewController {
    BOOL isGrantedPermission;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.descriptionTV.layer.borderColor = UIColor.grayColor.CGColor;
    self.descriptionTV.layer.borderWidth = 2.0;
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions: options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        self->isGrantedPermission = granted;
    }];
}

- (IBAction)save:(UIButton *)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey: @"todos"];
    
    NSMutableArray *todos = [NSKeyedUnarchiver unarchiveObjectWithData: data];
    
    NSString *name = _nameTF.text;
    NSString *todoDescription = _descriptionTV.text;
    NSString *status = @"upcoming";
    NSDate *date = _datePicker.date;
    NSDate *dateOfCreation = [NSDate new];
    NSInteger priority = _priorityPicker.selectedSegmentIndex;
    
    if ([self checkForName: todos : name]) {
        
        if ([self checkForTime: date]) {
            
            Todo *todo = [[Todo alloc] initWithName: name andDescription: todoDescription andStatus: status andDate: date andDateOfCreation: dateOfCreation andPriority: priority];
            
            [todos addObject: todo];
            
            data = [NSKeyedArchiver archivedDataWithRootObject: todos];
            [defaults setObject: data forKey: @"todos"];
            [self makeNotification: todo];
            [self.todosObserver updateTodosAfterAdd: todos];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"ERROR" message: @"The time is over" delegate: self cancelButtonTitle: nil otherButtonTitles: @"OK", nil];
            [alert show];
        }
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"ERROR" message: @"The anmeis already exist" delegate: self cancelButtonTitle: nil otherButtonTitles: @"OK", nil];
        [alert show];
    }
}

- (BOOL) checkForName: (NSMutableArray*) todos: (NSString*) name {
    
    for (int i = 0; i < [todos count]; i++) {
        Todo *currentTodo = [todos objectAtIndex: i];
        if ([currentTodo.name isEqualToString: name]) {
            return false;
        }
    }
    
    return true;
}

- (BOOL) checkForTime: (NSDate*) date {
    
    float currentMillis = [[NSDate new] timeIntervalSince1970];
    if (date.timeIntervalSince1970 <= currentMillis)
        return false;
    
    return true;
}

- (void) makeNotification : (Todo*) todo {
    if (isGrantedPermission) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        
        UNMutableNotificationContent *content = [UNMutableNotificationContent new];
        [content setTitle: todo.name];
        [content setBody: todo.todoDescription];
        [content setSound: [UNNotificationSound defaultSound]];
        
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval: (todo.date.timeIntervalSince1970 - todo.dateOfCreation.timeIntervalSince1970) repeats: NO];
        
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier: todo.name content: content trigger: trigger];
        [center addNotificationRequest: request withCompletionHandler: nil];
    }
    
    
}

@end
