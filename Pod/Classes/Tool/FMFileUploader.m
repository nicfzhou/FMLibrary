//
//  FMFileUploader.m
//  Pods
//
//  Created by 周峰 on 16/3/24.
//
//

#import "FMFileUploader.h"
@import MobileCoreServices;

static NSString *TOKEN = @"3d2fa53a28f0cbdbdf6dfb006271077e";

static NSString *FILE_SERVER = @"http://121.42.192.146/fsrv/upload_file.php";

#define BOUNDARY @"---------------------------350A2CA2235F746A50287B59F42C833F"
#define START_BOUNDARY [NSString stringWithFormat:@"--%@\r\n",BOUNDARY]
#define END_BOUNDARY [NSString stringWithFormat:@"--%@--\r\n",BOUNDARY]
#define UTF8Encode(str)  [str dataUsingEncoding:NSUTF8StringEncoding]

@interface FMFileUploader() <NSURLConnectionDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate>

@end

@implementation FMFileUploader{
    NSString *_filePath;
    NSMutableDictionary *_params;
    NSMutableData *_responseData;
}

+ (void)setToken:(NSString *)token{
    TOKEN = [token copy];
}

+ (instancetype)uploaderWithFileAtPath:(NSString *)path params:(NSDictionary *)params{
    FMFileUploader *uploader = [FMFileUploader new];
    uploader->_filePath = [path copy];
    NSMutableDictionary *_parmas = [NSMutableDictionary dictionaryWithDictionary:params];
    _parmas[@"token"] = TOKEN;
    uploader->_params = _parmas;
    return uploader;
}

- (void)upload{
    BOOL isDirectory = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:_filePath isDirectory:&isDirectory] || isDirectory) {
        if (self.failure) {
            self.failure(isDirectory?@"不支持上传目录":@"指定文件不存在");
        }
        return;
    }
    
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:FILE_SERVER]];
    req.HTTPMethod = @"POST";
    
    
    //set http body
    NSMutableData *body = [NSMutableData data];
    //set file param
    NSString *fileName = [_filePath lastPathComponent];
    NSString *name = @"file";//[[fileName componentsSeparatedByString:@"."] firstObject];
    NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",name,fileName];
    [body appendData:UTF8Encode(START_BOUNDARY)];
    [body appendData:UTF8Encode(disposition)];
    NSString *contentType = [NSString stringWithFormat:@"Content-Type: %@\r\n",[self mimeType]];
    [body appendData:UTF8Encode(contentType)];
    [body appendData:UTF8Encode(@"\r\n")];
    [body appendData:[NSData dataWithContentsOfFile:_filePath]];
    [body appendData:UTF8Encode(@"\r\n")];
    
    
    //set common param
    [_params enumerateKeysAndObjectsUsingBlock:^(NSString *key,id obj,BOOL *needStop){
       //参数分隔符
        [body appendData:UTF8Encode(START_BOUNDARY)];
        NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", key];
        [body appendData:UTF8Encode(disposition)];
        [body appendData:UTF8Encode(@"\r\n")];
        [body appendData:UTF8Encode(obj)];
        [body appendData:UTF8Encode(@"\r\n")];
    }];
    
    //参数结束
    [body appendData:UTF8Encode(END_BOUNDARY)];
    [body appendData:UTF8Encode(@"\r\n")];
    req.HTTPBody = body;
    
    NSLog(@"%@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    
    [req setValue:[NSString stringWithFormat:@"%zd", body.length] forHTTPHeaderField:@"Content-Length"];
    [req setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",BOUNDARY] forHTTPHeaderField:@"Content-Type"];
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    __weak NSURLSession *weakSession = session;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:req completionHandler:^(NSData *data,NSURLResponse *resp ,NSError *error){
        if (error && self.failure) {
            self.failure(error.localizedDescription);
            return;
        }
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSString *res = json[@"RES"];
        NSString *serverUrl = json[@"PATH"];
        NSString *msg = json[@"ERR"];
        if (res && [res isEqualToString:@"0"] && self.successer) {
            self.successer(serverUrl);
            return;
        }
        if(res && [res isEqualToString:@"1"] && self.failure){
            self.failure(msg);
        }
        __strong NSURLSession *strongSession = weakSession;
        if (strongSession) {
            [session invalidateAndCancel];
        }
    }];
    [task resume];
}

- (void)dealloc{
    
}

#pragma session task delegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    
    int percent = (int)((totalBytesSent*1. / totalBytesExpectedToSend) * 100.);
    if (self.progresser) {
        self.progresser(percent);
    }
}


#pragma private api
- (NSString *)mimeType{
    NSString *fileExtension = [_filePath pathExtension];
    NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)fileExtension, NULL);
    NSString *contentType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)UTI, kUTTagClassMIMEType);
    return contentType;//@"application/octet-stream";
}
@end
