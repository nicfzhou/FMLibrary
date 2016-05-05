//
//  FMFileUploader.h
//  Pods
//
//  Created by 周峰 on 16/3/24.
//
//

#import <Foundation/Foundation.h>

@interface FMFileUploader : NSObject

@property(nonatomic,copy) void(^progresser)(NSInteger);
@property(nonatomic,copy) void(^successer)(NSString *serverFileUrl);
@property(nonatomic,copy) void(^failure)(NSString *failReason);

+ (void)setToken:(NSString *)token;

+ (instancetype) uploaderWithFileAtPath:(NSString *) path params:(NSDictionary *)params;

- (void)upload;
@end
