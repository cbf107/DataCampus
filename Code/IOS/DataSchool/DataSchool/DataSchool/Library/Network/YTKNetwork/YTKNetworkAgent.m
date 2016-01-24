//
//  YTKNetworkAgent.m
//
//  Copyright (c) 2012-2014 YTKNetwork https://github.com/yuantiku
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "YTKNetworkAgent.h"
#import "YTKNetworkConfig.h"
#import "YTKNetworkPrivate.h"
#import "AFDownloadRequestOperation.h"

@implementation YTKNetworkAgent {
    AFHTTPRequestOperationManager *_manager;
    YTKNetworkConfig *_config;
    NSMutableDictionary *_requestsRecord;

}

+ (YTKNetworkAgent *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        _config = [YTKNetworkConfig sharedInstance];
        _manager = [AFHTTPRequestOperationManager manager];
        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        _manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
        _requestsRecord = [NSMutableDictionary dictionary];
        _manager.operationQueue.maxConcurrentOperationCount = 4;
        
        [_manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    NSLog(@"-------AFNetworkReachabilityStatusReachableViaWWAN------");
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    NSLog(@"-------AFNetworkReachabilityStatusReachableViaWiFi------");
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    NSLog(@"-------AFNetworkReachabilityStatusNotReachable------");
                    break;
                default:
                    break;
            }
        }];
        [_manager.reachabilityManager startMonitoring];
    }
    return self;
}

- (NSString *)buildRequestUrl:(YTKBaseRequest *)request {
    NSString *detailUrl = [request requestUrl];
    if ([detailUrl hasPrefix:@"http"]) {
        return detailUrl;
    }
    // filter url
    NSArray *filters = [_config urlFilters];
    for (id<YTKUrlFilterProtocol> f in filters) {
        detailUrl = [f filterUrl:detailUrl withRequest:request];
    }

    NSString *baseUrl;
    if ([request useCDN]) {
        if ([request cdnUrl].length > 0) {
            baseUrl = [request cdnUrl];
        } else {
            baseUrl = [_config cdnUrl];
        }
    } else {
        if ([request baseUrl].length > 0) {
            baseUrl = [request baseUrl];
        } else {
            baseUrl = [_config baseUrl];
        }
    }
    
    // lewis
    return [NSString stringWithFormat:@"%@%@", baseUrl, detailUrl];
}

- (void)addRequest:(YTKBaseRequest *)request {
    YTKRequestMethod method = [request requestMethod];
    NSString *url = [self buildRequestUrl:request];
    id param = request.requestArgument;

    AFConstructingBlock constructingBlock = [request constructingBodyBlock];

    if (request.requestSerializerType == YTKRequestSerializerTypeHTTP) {
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    } else if (request.requestSerializerType == YTKRequestSerializerTypeJSON) {
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }

    // if api need server username and password
    NSArray *authorizationHeaderFieldArray = [request requestAuthorizationHeaderFieldArray];
    if (authorizationHeaderFieldArray != nil) {
        [_manager.requestSerializer setAuthorizationHeaderFieldWithUsername:(NSString *)authorizationHeaderFieldArray.firstObject
                                                                   password:(NSString *)authorizationHeaderFieldArray.lastObject];
    }

    // if api build custom url request
    NSURLRequest *customUrlRequest= [request buildCustomUrlRequest];
    if (customUrlRequest) {
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:customUrlRequest];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self handleRequestResult:operation error:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleRequestResult:operation error:error];
        }];
        request.requestOperation = operation;
        [_manager.operationQueue addOperation:operation];
    } else {
        if (method == YTKRequestMethodGet) {
            if (request.resumableDownloadPath) {
                // add parameters to URL;
                NSString *filteredUrl = [YTKNetworkPrivate urlStringWithOriginUrlString:url appendParameters:param];

                NSURLRequest *requestUrl = [NSURLRequest requestWithURL:[NSURL URLWithString:filteredUrl]];
                AFDownloadRequestOperation *operation = [[AFDownloadRequestOperation alloc] initWithRequest:requestUrl
                                                                                                 targetPath:request.resumableDownloadPath shouldResume:YES];
                [operation setProgressiveDownloadProgressBlock:request.resumableDownloadProgressBlock];
                [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [self handleRequestResult:operation error:nil];
                }                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self handleRequestResult:operation error:error];
                }];
                request.requestOperation = operation;
                [_manager.operationQueue addOperation:operation];
            } else {
                request.requestOperation = [_manager GET:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [self handleRequestResult:operation error:nil];
                }                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self handleRequestResult:operation error:error];
                }];
            }
        } else if (method == YTKRequestMethodPost) {
            if (constructingBlock != nil) {
                request.requestOperation = [_manager POST:url parameters:param constructingBodyWithBlock:constructingBlock
                                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                      [self handleRequestResult:operation error:nil];
                                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self handleRequestResult:operation error:error];
                        }];
            } else {
                request.requestOperation = [_manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [self handleRequestResult:operation error:nil];
                }                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self handleRequestResult:operation error:error];
                }];
            }
        } else if (method == YTKRequestMethodHead) {
            request.requestOperation = [_manager HEAD:url parameters:param success:^(AFHTTPRequestOperation *operation) {
                [self handleRequestResult:operation error:nil];
            }                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleRequestResult:operation error:error];
            }];
        } else if (method == YTKRequestMethodPut) {
            request.requestOperation = [_manager PUT:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self handleRequestResult:operation error:nil];
            }                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleRequestResult:operation error:error];
            }];
        } else if (method == YTKRequestMethodDelete) {
            request.requestOperation = [_manager DELETE:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self handleRequestResult:operation error:nil];
            }                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleRequestResult:operation error:error];
            }];
        } else {
            YTKLog(@"Error, unsupport method type");
            return;
        }
    }

    YTKLog(@"Add request: %@", NSStringFromClass([request class]));
    [self addOperation:request];
}

- (void)cancelRequest:(YTKBaseRequest *)request {
    [request.requestOperation cancel];
    [self removeOperation:request.requestOperation];
    [request clearCompletionBlock];
}

- (void)cancelAllRequests {
    NSDictionary *copyRecord = [_requestsRecord copy];
    for (NSString *key in copyRecord) {
        YTKBaseRequest *request = copyRecord[key];
        [request stop];
    }
}

- (NSError *)checkResult:(YTKBaseRequest *)request {
    
    id result = request.responseJSONObject;
    
    if ([result isKindOfClass:[NSDictionary class]]) {
        
        id head = result[@"head"];
        
        if ([head isKindOfClass:[NSDictionary class]]) {
            
            int code = [head[@"errorCode"] intValue];
            NSString *msg = head[@"msg"];
            
            if (code == IWanDaRequestSuccess) {//返回数据成功，判断格式
                id validator = [request jsonValidator];
                if (validator != nil) {
                    id json = result[@"body"];
                    NSString *ret = [YTKNetworkPrivate checkJson:json withValidator:validator];
                    
                    if (ret) {
                        return [NSError errorWithDomain:IWanDaErrorDomain code:IWanDaRequestInvalidData userInfo:@{NSLocalizedDescriptionKey:@"数据异常"}];//Body数据异常
                    }
                }
            }
            return [NSError errorWithDomain:IWanDaErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey:msg}];
        }else{
            return [NSError errorWithDomain:IWanDaErrorDomain code:IWanDaRequestInvalidData userInfo:@{NSLocalizedDescriptionKey:@"数据异常"}];//Head数据异常
        }
    }else{
        return [NSError errorWithDomain:IWanDaErrorDomain code:IWanDaRequestInvalidData userInfo:@{NSLocalizedDescriptionKey:@"数据异常"}];
    }

    return nil;
}

- (void)handleRequestResult:(AFHTTPRequestOperation *)operation error:(NSError *)err{
    NSString *key = [self requestHashKey:operation];
    YTKBaseRequest *request = _requestsRecord[key];
    NSLog(@"%@: %@:%@", [request requestUrl],err?@"请求失败":@"请求成功",err?err.localizedDescription:operation.responseString);
    
    if (request) {
        
        if (err) {
            request.responseError = err;
            [request toggleAccessoriesWillStopCallBack];
            [request requestFailedFilter];
            if (request.delegate != nil) {
                [request.delegate requestFailed:request];
            }
            if (request.failureCompletionBlock) {
                request.failureCompletionBlock(err);
            }
            [request toggleAccessoriesDidStopCallBack];
        }else{
        
            NSError *err = [self checkResult:request];
            request.responseError = err;

            if (err.code == IWanDaRequestSuccess) {
                [request toggleAccessoriesWillStopCallBack];
                
                if (request.delegate != nil) {
                    [request.delegate requestFinished:request];
                }
                if (request.successCompletionBlock) {
                    request.successCompletionBlock(request);
                }
                [request requestCompleteFilter];

                [request toggleAccessoriesDidStopCallBack];
            }else{
                YTKLog(@"Request %@ failed, err:%@(%ld)\n",
                         NSStringFromClass([request class]), err.localizedDescription,(long)err.code);
                
                [request toggleAccessoriesWillStopCallBack];
                [request requestFailedFilter];
                if (request.delegate != nil) {
                    [request.delegate requestFailed:request];
                }
                
                // lewis
                if (![UserManager handInvalidUser:err]) {
                    if (request.failureCompletionBlock) {
                        request.failureCompletionBlock(err);
                    }
                }
                [request toggleAccessoriesDidStopCallBack];
                
            }
        }
    }
    [self removeOperation:operation];
    [request clearCompletionBlock];
}

- (NSString *)requestHashKey:(AFHTTPRequestOperation *)operation {
    NSString *key = [NSString stringWithFormat:@"%@", @([operation hash])];
    return key;
}

- (void)addOperation:(YTKBaseRequest *)request {
    if (request.requestOperation != nil) {
        NSString *key = [self requestHashKey:request.requestOperation];
        _requestsRecord[key] = request;
    }
}

- (void)removeOperation:(AFHTTPRequestOperation *)operation {
    NSString *key = [self requestHashKey:operation];
    [_requestsRecord removeObjectForKey:key];
    YTKLog(@"Request queue size = %lu", (unsigned long)[_requestsRecord count]);
}

@end
