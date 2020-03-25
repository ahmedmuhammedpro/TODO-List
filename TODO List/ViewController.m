#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *s = [defaults objectForKey: @"firstTime"];
    if (s == nil) {
        NSMutableArray *todos = [[NSMutableArray alloc] initWithCapacity: 25];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject: todos];
        [defaults setObject: data forKey: @"todos"];
        [defaults setObject: @"firstTime" forKey: @"firstTime"];
        [defaults setBool: NO forKey: @"changed"];
    }
    
    NSData *data = [defaults objectForKey: @"todos"];
    
    _todos = [NSKeyedUnarchiver unarchiveObjectWithData: data];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_todos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier: @"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"cell"];
    }
    
    UIView *cellStatus = [cell viewWithTag: 1];
    UILabel *cellName = [cell viewWithTag: 2];
    UILabel *cellDate = [cell viewWithTag: 3];
    UILabel *cellDescription = [cell viewWithTag: 4];
    UIView *cellPriority = [cell viewWithTag: 5];
    
    Todo *todo = [_todos objectAtIndex: indexPath.row];
    
    if ([todo.status isEqualToString: @"upcoming"])
        cellStatus.backgroundColor = UIColor.orangeColor;
    else if ([todo.status isEqualToString: @"done"])
        cellStatus.backgroundColor = UIColor.greenColor;
    else
        printf("error with status");
    
    if (todo.priority == 0)
        cellPriority.backgroundColor = UIColor.greenColor;
    else if (todo.priority == 1)
        cellPriority.backgroundColor = UIColor.blueColor;
    else
        cellPriority.backgroundColor = UIColor.redColor;
    
    cellName.text = todo.name;
    cellDescription.text = todo.todoDescription;
    cellDate.text = [todo.date description];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EditViewController *editView = [self.storyboard instantiateViewControllerWithIdentifier: @"edit"];
    editView.todo = [_todos objectAtIndex: indexPath.row];
    [self.navigationController pushViewController: editView animated: YES];
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Todo *t = [_todos objectAtIndex: indexPath.row];
    [_todos removeObjectAtIndex: indexPath.row];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject: _todos];
    [defaults setObject: data forKey: @"todos"];
    
    if ([t.status isEqualToString: @"upcoming"]) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center removePendingNotificationRequestsWithIdentifiers: @[t.name]];
    }
    
    [self.myTableView deleteRowsAtIndexPaths: @[indexPath] withRowAnimation: YES];
}

- (void) viewDidAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL changed = [defaults boolForKey: @"changed"];
    if (changed) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [defaults objectForKey: @"todos"];
        _todos = [NSKeyedUnarchiver unarchiveObjectWithData: data];
        [_myTableView reloadData];
        
        [defaults setBool: false forKey: @"changed"];
    }
    
}

@end
