//
//  IWHttpTool.m
//  MJWeiBo
//
//  Created by qianfeng on 15-4-20.
//  Copyright (c) 2015年 Jason Ding. All rights reserved.
//

#import "IWHttpTool.h"
#import "AFNetworking.h"

@implementation IWHttpTool

+(void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError * error))failure
{
    AFHTTPRequestOperationManager * mgr = [AFHTTPRequestOperationManager manager];
    //说明服务器,返回的是 json 类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //发送请求
    [mgr POST:url parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
          if (success) {
              success(responseObject);
          }
          
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          
          if (error) {
              failure(error);
          }
          
      }];
}


+(void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1,创建请求管理对象
    AFHTTPRequestOperationManager * mgr = [AFHTTPRequestOperationManager manager];

    // 2,发送请求
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> totalFormData) {
        
        for (IWFormData * formData in formDataArray) {
            [totalFormData appendPartWithFileData:formData.data name:formData.name fileName:formData.filename mimeType:formData.mimeType];
        }
        

        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


+(void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager * mgr = [AFHTTPRequestOperationManager manager];
    //说明服务器,返回的是 json 类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //发送请求
    [mgr GET:url parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
          if (success) {
              success(responseObject);
          }
          
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          
          if (error) {
              failure(error);
          }
          
      }];
}


@end

/**
 *  用来封装文件数据的模型
 */
@implementation IWFormData

@end