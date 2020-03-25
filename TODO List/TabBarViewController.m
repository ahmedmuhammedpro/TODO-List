#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController {
    ViewController *mainViewController;
    AddViewController *addViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDelegate: self];
    [self tabBarController: self didSelectViewController: [self.viewControllers objectAtIndex: 0]];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    if (mainViewController == nil && [viewController isKindOfClass: [viewController class]]) {
        
        mainViewController = viewController;
        
    } else if (addViewController == nil && [viewController isKindOfClass: [AddViewController class]]) {
        addViewController = viewController;
    }
    
    if (addViewController != nil) {
        addViewController.todosObserver = self;
    }
}

- (void) updateTodosAfterAdd:(NSMutableArray *) list {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool: true forKey: @"changed"];
    [self setSelectedIndex: 0];
}

@end
