#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    return YES;
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey: @"todos"];
    NSMutableArray *todos = [NSKeyedUnarchiver unarchiveObjectWithData: data];
    
    UNNotificationContent *content = notification.request.content;
    
    for (int i = 0; i < [todos count]; i++) {
        Todo *todo = [todos objectAtIndex: i];
        if ([todo.name isEqualToString: content.title]) {
            todo.status = @"done";
        }
    }
    data = [NSKeyedArchiver archivedDataWithRootObject: todos];
    [defaults setObject: data forKey: @"todos"];
    [defaults setBool: true forKey: @"changed"];
    
    UNNotificationPresentationOptions present = UNNotificationPresentationOptionAlert + UNNotificationPresentationOptionSound;
    completionHandler(present);
}

@end
