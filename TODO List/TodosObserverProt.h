#import <Foundation/Foundation.h>
#import "Todo.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TodosObserverProt <NSObject>

- (void) updateTodosAfterAdd: (NSMutableArray*) list;

@end

NS_ASSUME_NONNULL_END
