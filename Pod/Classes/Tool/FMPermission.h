//
//  FMPermission.h
//  Pods
//
//  Created by 周峰 on 16/1/25.
//
//

#import <Foundation/Foundation.h>



typedef NS_ENUM(NSInteger,PermissionType) {
    PermissionTypeContact,/**< 联系人权限 - NSContactsUsageDescription  */
    PermissionTypePhoto,/**< 相册 - NSPhotoLibraryUsageDescription*/
    PermissionTypeLocationAlways,/**< 定位(始终) - NSLocationAlwaysUsageDescription、NSLocationUsageDescription */
    PermissionTypeLocationWhenInUse,/**< 定位(app前台）- NSLocationWhenInUseUsageDescription  */
    PermissionTypeCalendar,/**<  日历 - NSCalendarsUsageDescription */
    PermissionTypeReminder,/**<  提醒事项 - NSRemindersUsageDescription */
    PermissionTypeBluetooth,/**<  蓝牙共享 - NSBluetoothPeripheralUsageDescription */
    PermissionTypeMicrophone,/**< 麦克风 - NSMicrophoneUsageDescription */
    PermissionTypeCamera,/**< 相机 - NSCameraUsageDescription  */
    PermissionTypeHealth,/**< 健康  */
    PermissionTypeHomeKit,/**< HomeKit  */
    PermissionTypeSports/**<  运动与健身 - NSMotionUsageDescription */
};


typedef NS_ENUM(NSInteger,PermissionStatus) {
    PermissionStatusAuthorized,/**< 已授权  */
    PermissionStatusDenied,/**<  已拒绝 */
    PermissionStatusNotDetermined/**<  尚未授权 */
};


/**
 *  @author Feng.z, 16-01-25 11:01:28
 *
 *  @brief 获取各种系统权限
 *
 *  @since 1.2
 */
@interface FMPermission : NSObject


+ (PermissionStatus)statustOfPermissionType:(PermissionType) type;

+ (void)askPermissionOfType:(PermissionType)type complete:(void(^)(PermissionStatus status))complete;

@end
