//
//  DeviceSender.m
//  PushNotificationDemo
//
//  Created by 罗 永亮 on 12-2-20.
//  Copyright (c) 2012年 luoyl.info. All rights reserved.
//

#define push_server		@"http://www.ycombo.com/che/mac/msg/IF00062"
#import "DeviceSender.h"

@interface DeviceSender()
-(void) sendRequestByGet:(NSString*)urlString;
@end


@implementation DeviceSender
@synthesize userUUid;
@synthesize delegate;

- (void)dealloc
{
    if (receivedData) {
        [receivedData release];
    }
    [super dealloc];
}


- (id)initWithDelegate:(id<DeviceSenderDelegate>)delegate_
{
    if (self = [super init]) {
        self.delegate = delegate_;
    }
    return self;
}

-(void) sendDeviceToPushServer:(NSString*)deviceToken
{
    [self getUUidForthis];
    if (userUUid) {
        NSRange range=NSMakeRange(1, deviceToken.length-2);
        
        NSString *tokenString=[deviceToken substringWithRange:range];
        NSLog(@"tokenString=======%@",tokenString);
        NSString *urlString = [NSString stringWithFormat:@"%@?token=%@&uuid=%@", push_server, tokenString, userUUid];
        NSLog(@"---->发送设备id到：%@", urlString);
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
        NSString *strUrld8 = [urlString stringByAddingPercentEscapesUsingEncoding:enc];
        //调用http get请求方法
        [self sendRequestByGet:strUrld8];
    }
}

//HTTP get请求方法
- (void)sendRequestByGet:(NSString*)urlString
{   
	NSURL *url=[NSURL URLWithString:urlString];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
																cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
															timeoutInterval:60];
	//设置请求方式为get
	[request setHTTPMethod:@"GET"];
	//添加用户会话id
	[request addValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
	//连接发送请求
	receivedData=[[NSMutableData alloc] initWithData:nil];
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];       
	[conn release];
}

- (void)connection:(NSURLConnection *)aConn didReceiveResponse:(NSURLResponse *)response {
    // 注意这里将NSURLResponse对象转换成NSHTTPURLResponse对象才能去
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
        NSDictionary *dictionary = [httpResponse allHeaderFields];
        NSLog(@"[connection,didReceiveResponse =%@]",[dictionary description]);
		
    }
}

//接收NSData数据
- (void)connection:(NSURLConnection *)aConn didReceiveData:(NSData *)data {
	[receivedData appendData:data];
}
- (void)connection:(NSURLConnection *)aConn didFailWithError:(NSError *)error{
    NSLog(@"[connection,didFailWithError=%@]",[error localizedDescription]);
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSendDeviceFailed:withError:)]) {
        [self.delegate didSendDeviceFailed:self withError:error];
    }
}

//接收完毕,显示结果
- (void)connectionDidFinishLoading:(NSURLConnection *)aConn {
	NSString *results = [[NSString alloc] 
                         initWithBytes:[receivedData bytes] 
                         length:[receivedData length] 
                         encoding:NSUTF8StringEncoding];
	NSLog(@"[connectionDidFinishLoading,result=%@]",results);
    [results release];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSendDeviceSuccess:)]) {
        [self.delegate didSendDeviceSuccess:self];
    }
} 

-(void)getUUidForthis
{
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir=[path objectAtIndex:0];
    //NSFileManager *fm=[NSFileManager defaultManager];
    NSString *imagePath=[docDir stringByAppendingPathComponent:@"myFile.txt"];
    NSMutableArray *stringmutable=[NSMutableArray arrayWithContentsOfFile:imagePath];
    NSString *stringUUID=[stringmutable objectAtIndex:0];
    NSLog(@"wwwwwwwwwwwwwwwwwwww%@",stringUUID);
    self.userUUid=stringUUID;
}

@end
