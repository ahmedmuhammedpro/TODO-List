#import "EditViewController.h"

@interface EditViewController ()

@end

@implementation EditViewController {
    BOOL isGrantedPermission;
    NSString *oldName;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.descriptionTV.layer.borderColor = UIColor.grayColor.CGColor;
    self.descriptionTV.layer.borderWidth = 2.0;
    oldName = _todo.name;
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions: options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        self->isGrantedPermission = granted;
    }];
    
    self.navigationItem.title = _todo.status;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle: @"mark as done" style: UIBarButtonItemStylePlain target: self action: @selector( markAsDone)];
    [self.navigationItem setRightBarButtonItem: doneButton];
    self.nameTF.text = [@"Name:" stringByAppendingFormat:@"%@", _todo.name];
    self.descriptionTV.text = [@"Description: " stringByAppendingFormat:@"%@",  _todo.todoDescription];
    
    switch (_todo.priority) {
        case 0:
            [self.priorityPicker setSelectedSegmentIndex: 0];
            break;
        case 1:
            [self.priorityPicker setSelectedSegmentIndex: 0];
            break;
        case 2:
            [self.priorityPicker setSelectedSegmentIndex: 0];
    }
    
    [self.datePicker setDate: _todo.date];
}

- (void) markAsDone {
    if ([_todo.status isEqualToString: @"upcoming"]) {
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center removePendingNotificationRequestsWithIdentifiers: @[oldName]];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [defaults objectForKey: @"todos"];
        NSMutableArray *todos = [NSKeyedUnarchiver unarchiveObjectWithData: data];
        
        for (int i = 0; i < [todos count]; i++) {
            Todo *t = [todos objectAtIndex: i];
            if ([t.name isEqualToString: _todo.name]) {
                printf("done\n");
                t.status = @"done";
            }
        }
        
        data = [NSKeyedArchiver archivedDataWithRootObject: todos];
        [defaults setObject: data forKey: @"todos"];
        [defaults setBool: true forKey: @"changed"];
        [self.navigationController popViewControllerAnimated: true];
        
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: _todo.name message: @"The todo is aleardy done" delegate: self cancelButtonTitle: nil otherButtonTitles: @"OK", nil];
        
        [alert show];
    }
}


- (IBAction)save:(UIButton *)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey: @"todos"];
    
    NSMutableArray *todos = [NSKeyedUnarchiver unarchiveObjectWithData: data];
    
    for (int i = 0; i < [todos count]; i++) {
        Todo *t = [todos objectAtIndex: i];
        if ([t.name isEqualToString: _todo.name]) {
            _todo = t;
            break;
        }
    }
    
    NSString *name = _nameTF.text;
    NSString *todoDescription = _descriptionTV.text;
    NSString *status = @"upcoming";
    NSDate *date = _datePicker.date;
    NSDate *dateOfCreation = [NSDate new];
    NSInteger priority = _priorityPicker.selectedSegmentIndex;
    
    if ([self checkForName: todos : name]) {
        
        if ([self checkForTime: date]) {
            
            _todo.name = name;
            _todo.todoDescription = todoDescription;
            _todo.status = status;
            _todo.date = date;
            _todo.dateOfCreation = dateOfCreation;
            _todo.priority = priority;
            
            data = [NSKeyedArchiver archivedDataWithRootObject: todos];
            [defaults setObject: data forKey: @"todos"];
            [self makeNotification: _todo];
            
            [defaults setBool: true forKey: @"changed"];
            [self.navigationController popViewControllerAnimated: true];
            
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
        [center removePendingNotificationRequestsWithIdentifiers: @[oldName]];
        
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
