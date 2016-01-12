//
//  NSObject+FMKVO.h
//  Pods
//
//  Created by 周峰 on 15/12/22.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (FMKVO)

@end

@interface NSObject (Property4Category)

- (void) setProperty:(id) value forKey:(NSString *) key;
- (id) propertyForKey:(NSString *) key;
@end
