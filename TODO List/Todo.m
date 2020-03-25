#import "Todo.h"

@implementation Todo

- (id)initWithName:(NSString *)name andDescription:(NSString *)todoDescription andStatus:(NSString *)status andDate:(NSDate *)date andDateOfCreation:(NSDate *)dateOfCreation andPriority:(NSInteger)priority {
    self = [self init];
    self.name = name;
    self.todoDescription = todoDescription;
    self.status = status;
    self.date = date;
    self.dateOfCreation = dateOfCreation;
    self.priority = priority;
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject: self.name forKey: @"name"];
    [coder encodeObject: self.todoDescription forKey: @"description"];
    [coder encodeObject: self.status forKey: @"status"];
    [coder encodeObject: self.date forKey: @"date"];
    [coder encodeObject: self.dateOfCreation forKey: @"dateOfCreation"];
    [coder encodeInteger: self.priority forKey: @"priority"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self.name = [coder decodeObjectForKey: @"name"];
    self.todoDescription = [coder decodeObjectForKey: @"description"];
    self.status = [coder decodeObjectForKey: @"status"];
    self.date = [coder decodeObjectForKey: @"date"];
    self.dateOfCreation = [coder decodeObjectForKey: @"dateOfCreation"];
    self.priority = [coder decodeIntegerForKey: @"priority"];
    
    return self;
}


@end
