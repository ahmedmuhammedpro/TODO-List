#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "AddViewController.h"
#import "TodosObserverProt.h"

NS_ASSUME_NONNULL_BEGIN

@interface TabBarViewController : UITabBarController <UITabBarControllerDelegate, TodosObserverProt>

//@property ViewController *viewController;
//@property AddViewController *addViewController;

@end

NS_ASSUME_NONNULL_END
