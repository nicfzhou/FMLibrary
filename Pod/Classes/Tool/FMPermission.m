//
//  FMPermission.m
//  Pods
//
//  Created by 周峰 on 16/1/25.
//
//

#import "FMPermission.h"
@import AddressBook;
@import Contacts;//iOS 9新的通讯录框架

@import AVFoundation;

@import AssetsLibrary;
@import Photos;

@import CoreLocation;


#define FM_SAFE_BLOCK(_block,...) if(_block) {_block(__VA_ARGS__);}




@interface FMLocationManagerDelegate : NSObject <CLLocationManagerDelegate>
@property(nonatomic,assign) BOOL askingPermission;
@property(nonatomic,weak) NSThread *targetThread;
@end

@implementation FMLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status != kCLAuthorizationStatusNotDetermined) {
        [self performSelector:@selector(setAskingPermission:) onThread:_targetThread withObject:@(NO) waitUntilDone:NO];
    }
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    NSLog(@"update location");
}

@end

@implementation FMPermission

+ (PermissionStatus)statustOfPermissionType:(PermissionType)type{
    
    NSInteger systemMajorVersion = [self systemMajorVersion];
    
    switch (type) {
        case PermissionTypeContact: {
            //iOS 9 and later
            if (systemMajorVersion>=9) {
                switch ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts]) {
                    case CNAuthorizationStatusNotDetermined: {
                        return PermissionStatusNotDetermined;
                    }
                    case CNAuthorizationStatusRestricted: {
                        return PermissionStatusDenied;
                    }
                    case CNAuthorizationStatusDenied: {
                        return PermissionStatusDenied;
                    }
                    case CNAuthorizationStatusAuthorized: {
                        return PermissionStatusAuthorized;
                    }
                }
            }
            //ios 2.0 ~ 8.0
            if (systemMajorVersion>=2) {
                ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
                switch (status) {
                    case kABAuthorizationStatusNotDetermined: {
                        return PermissionStatusNotDetermined;
                    }
                    case kABAuthorizationStatusRestricted: {
                        return PermissionStatusDenied;
                    }
                    case kABAuthorizationStatusDenied: {
                        return PermissionStatusDenied;
                    }
                    case kABAuthorizationStatusAuthorized: {
                        return PermissionStatusAuthorized;
                    }
                }
            }
    
            break;
        }
        case PermissionTypePhoto: {
            if (systemMajorVersion>=9) {
                switch ([PHPhotoLibrary authorizationStatus]) {
                    case PHAuthorizationStatusNotDetermined: {
                        return PermissionStatusNotDetermined;
                    }
                    case PHAuthorizationStatusRestricted: {
                        return PermissionStatusDenied;
                    }
                    case PHAuthorizationStatusDenied: {
                        return PermissionStatusDenied;
                    }
                    case PHAuthorizationStatusAuthorized: {
                        return PermissionStatusAuthorized;
                    }
                };
            }
            //iOS 6 and earlier
            if(systemMajorVersion >= 6){
                ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
                switch (status) {
                    case ALAuthorizationStatusNotDetermined: {
                        return PermissionStatusNotDetermined;
                    }
                    case ALAuthorizationStatusRestricted: {
                        return PermissionStatusDenied;
                    }
                    case ALAuthorizationStatusDenied: {
                        return PermissionStatusDenied;
                    }
                    case ALAuthorizationStatusAuthorized: {
                        return PermissionStatusAuthorized;
                    }
                }
            }
            
            break;
        }
        case PermissionTypeLocationAlways: {
            if (systemMajorVersion>=4) {
                CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
                switch (status) {
                    case kCLAuthorizationStatusNotDetermined: {
                        return PermissionStatusNotDetermined;
                    }
                    case kCLAuthorizationStatusRestricted: {
                        return PermissionStatusDenied;
                    }
                    case kCLAuthorizationStatusDenied: {
                        return PermissionStatusDenied;
                    }
                    default:{
                        if(systemMajorVersion>=8){
                            if (kCLAuthorizationStatusAuthorizedAlways == status) {
                                return PermissionStatusAuthorized;
                            }else if (kCLAuthorizationStatusAuthorizedWhenInUse == status){
                                return PermissionStatusDenied;
                            }
                        }else{
                            return PermissionStatusAuthorized;
                        }
                    }
                }
            }
            break;
        }
        case PermissionTypeLocationWhenInUse:{
            if (systemMajorVersion>=4) {
                CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
                switch (status) {
                    case kCLAuthorizationStatusNotDetermined: {
                        return PermissionStatusNotDetermined;
                    }
                    case kCLAuthorizationStatusRestricted: {
                        return PermissionStatusDenied;
                    }
                    case kCLAuthorizationStatusDenied: {
                        return PermissionStatusDenied;
                    }
                    default:{
                        return PermissionStatusAuthorized;
                    }
                }
            }
            break;
        }
        case PermissionTypeCalendar: {
            
            break;
        }
        case PermissionTypeReminder: {
            
            break;
        }
        case PermissionTypeBluetooth: {
            
            break;
        }
        case PermissionTypeMicrophone: {
            
            break;
        }
        case PermissionTypeCamera: {
            if (systemMajorVersion>=7) {
                switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
                    case AVAuthorizationStatusNotDetermined: {
                        return PermissionStatusNotDetermined;
                    }
                    case AVAuthorizationStatusRestricted: {
                        return PermissionStatusDenied;
                    }
                    case AVAuthorizationStatusDenied: {
                        return PermissionStatusDenied;
                    }
                    case AVAuthorizationStatusAuthorized: {
                        return PermissionStatusAuthorized;
                    }
                }
            }
            
            break;
        }
        case PermissionTypeHealth: {
            
            break;
        }
        case PermissionTypeHomeKit: {
            
            break;
        }
        case PermissionTypeSports: {
            
            break;
        }
    }
    
    return PermissionStatusAuthorized;
}


/**
 *  @author Feng.z, 16-01-25 14:01:30
 *
 *  @brief 申请获取各项权限（将调用系统授权）<br>
 *  <li>PermissionTypeContact - 在Plist中添加NSContactsUsageDescription(String)字段，设置申请时的系统提示内容</li>
 *
 *  @param type     权限类型
 *  @param complete 申请毁掉
 *
 *  @since 1.2
 */
+ (void) askPermissionOfType:(PermissionType)type complete:(void (^)(PermissionStatus))complete{
    __block void(^_complete)(PermissionStatus) = [complete copy];
    //判断是否已经获取权限
    PermissionStatus status = [self statustOfPermissionType:type];
    if (PermissionStatusNotDetermined != status) {
        FM_SAFE_BLOCK(_complete,status)
        return;
    }
    NSInteger systemMajorVersion = [self systemMajorVersion];
    switch (type) {
        case PermissionTypeContact: {
            if (systemMajorVersion>=9) {
                CNContactStore *contactStore = [[CNContactStore alloc] init];
                [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted,NSError *error){
                    FM_SAFE_BLOCK(_complete,granted&&!error?PermissionStatusAuthorized:PermissionStatusDenied);
                }];
                return;
            }
            //iOS 6 and earlier
            if (systemMajorVersion>=6) {
                ABAddressBookRef abref = ABAddressBookCreateWithOptions(NULL, NULL);
                ABAddressBookRequestAccessWithCompletion(abref, ^(bool granted,CFErrorRef error){
                    FM_SAFE_BLOCK(_complete,granted&&error==NULL?PermissionStatusAuthorized:PermissionStatusDenied);
                    if (abref) {
                        CFRelease(abref);
                    }
                });
                return;
            }
            break;
        }
        case PermissionTypePhoto: {
            if (systemMajorVersion>=9) {
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
                    PermissionStatus _status;
                    switch (status) {
                        case PHAuthorizationStatusNotDetermined: {
                            _status = PermissionStatusNotDetermined;
                            break;
                        }
                        case PHAuthorizationStatusRestricted: {
                            _status = PermissionStatusDenied;
                            break;
                        }
                        case PHAuthorizationStatusDenied: {
                            _status = PermissionStatusDenied;
                            break;
                        }
                        case PHAuthorizationStatusAuthorized: {
                            _status = PermissionStatusAuthorized;
                            break;
                        }
                    }
                    FM_SAFE_BLOCK(_complete,_status);
                }];
                return;
            }
            if(systemMajorVersion>=6){
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                [library enumerateGroupsWithTypes:ALAssetsGroupAll
                                       usingBlock:^(ALAssetsGroup *group,BOOL *stop) {
                                           *stop = YES;
                                           FM_SAFE_BLOCK(_complete,PermissionStatusAuthorized);
                                           _complete = nil;
                                       }failureBlock:^(NSError *error){
                                           FM_SAFE_BLOCK(_complete,PermissionStatusDenied);
                                       }
                ];
                return;
            }
            break;
        }
        case PermissionTypeLocationAlways:
        case PermissionTypeLocationWhenInUse:{
            if (systemMajorVersion >= 7) {
                __block CLLocationManager *manager = [[CLLocationManager alloc] init];
                __block FMLocationManagerDelegate *delegate = [[FMLocationManagerDelegate alloc] init];
                manager.delegate = delegate;
                delegate.askingPermission = YES;
                
                dispatch_async(dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL), ^{
                    NSRunLoop *runloop = [NSRunLoop currentRunLoop];//setup runloop
                    [runloop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
                    delegate.targetThread = [NSThread currentThread];
                    while (delegate.askingPermission) {//wait askpermission changed
                        [runloop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                    }
                    
                    [manager stopUpdatingLocation];
                    FM_SAFE_BLOCK(_complete,[self statustOfPermissionType:type]);
                    delegate = nil;
                    manager = nil;
                });
                
                if (systemMajorVersion >=8) {
                    if (type == PermissionTypeLocationAlways) {
                        [manager requestAlwaysAuthorization];
                    }else{
                        [manager requestWhenInUseAuthorization];
                    }
                }else{
                    [manager startUpdatingLocation];
                }
                return;
            }
            break;
        }
        case PermissionTypeCalendar: {
            
            break;
        }
        case PermissionTypeReminder: {
            
            break;
        }
        case PermissionTypeBluetooth: {
            
            break;
        }
        case PermissionTypeMicrophone: {
            
            break;
        }
        case PermissionTypeCamera: {
            if(systemMajorVersion>=7){
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted){
                    FM_SAFE_BLOCK(_complete,granted?PermissionStatusAuthorized:PermissionStatusDenied);
                }];
                return;
            }
            break;
        }
        case PermissionTypeHealth: {
            
            break;
        }
        case PermissionTypeHomeKit: {
            
            break;
        }
        case PermissionTypeSports: {
            
            break;
        }
    }
    FM_SAFE_BLOCK(_complete,PermissionStatusAuthorized);
}

#pragma mark private method
+ (NSInteger)systemMajorVersion{
    static NSInteger version;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = floor([UIDevice currentDevice].systemVersion.doubleValue);
    });
    return version;
}
@end
