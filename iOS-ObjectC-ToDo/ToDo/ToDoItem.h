//
//  ToDoItem.h
//  ToDo
//
//  Created by iOS Students on 5/4/15.
//  Copyright (c) 2015 Zhaolong Zhong. All rights reserved.
//
//
#import <Foundation/Foundation.h>

@interface ToDoItem : NSObject

@property NSString *itemName;
@property BOOL completed;
@property (readonly) NSDate *creationDate;

@end
