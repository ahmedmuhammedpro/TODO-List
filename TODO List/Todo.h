#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Todo : NSObject <NSCoding>

@property NSString *name;
@property NSString *todoDescription;
@property NSString *status;
@property NSDate *date;
@property NSDate *dateOfCreation;
@property NSInteger priority;

- (id) initWithName: (NSString*) name andDescription: (NSString*) todoDescription andStatus: (NSString*) status andDate: (NSDate*) date andDateOfCreation: (NSDate*) dateOfCreation andPriority: (NSInteger) priority;

@end

NS_ASSUME_NONNULL_END
