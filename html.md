## `WKWebView`加载本地网页的方式

1.直接加载字符串

```
- (void)loadHTMLString {
//直接加载字符串
NSString *path = [[NSBundle mainBundle] pathForResource:@"story" ofType:nil];
NSString *body = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:path] encoding:(NSUTF8StringEncoding) error:nil];
NSString *cssPath = [[NSBundle mainBundle] pathForResource:@"css" ofType:nil];
NSString *css = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:cssPath] encoding:NSUTF8StringEncoding error:nil];

NSString *html = @"<html>";
html = [html stringByAppendingString:@"<head>"];
html = [html stringByAppendingString:@"<meta name=\"viewport\" content=\"width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no,viewport-fit=cover\">"];
html = [html stringByAppendingString:@"<style type=\"text/css\">"];
html = [html stringByAppendingString:css];
html = [html stringByAppendingString:@"</style></head><body>"];
html = [html stringByAppendingString:body];
html = [html stringByAppendingString:@"</body></html>"];

[webview loadHTMLString:html baseURL:nil];
}
```
需要注意的是，`baseURL`可以用来控制请求权限

2.加载本地文件

```
- (void)loadHTMLContent {

//加载本地文件
NSString *rootPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
NSURL *rootURL = [NSURL fileURLWithPath:rootPath];

NSString *bodyTargetPath = [rootPath stringByAppendingPathComponent:@"index.html"];

NSURL *url = [NSURL fileURLWithPath:bodyTargetPath];

//这里必须指定到沙盒的具体文件夹，不能再沙盒根目录上
[webview loadFileURL:url allowingReadAccessToURL:rootURL];
}
```

### 重定向请求
1.通过`URLProtocol`


- 新建`Protocol`的子类，并添加请求属性

```
@property (nonnull,strong) NSURLSessionDataTask *task;
```

- 由于 `WKWebview`的特殊性，这里需要新建类别，并注册需要监听的请求头 `[NSURLProtocol wk_registerScheme:@"http"];`

- 注册监听 `[NSURLProtocol registerClass:[BZURLProtocol class]];`

- 过滤需要进行处理的请求，同时也要过滤那些已经处理过的请求。

```
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
if ([request.URL.absoluteString containsString:@"localhost"]) {
//看看是否已经处理过了，防止无限循环
if ([NSURLProtocol propertyForKey:kBZURLProtocolKey inRequest:request]) {
return NO;
}
return YES;
}
return NO;
}
```

- 将请求通过下面的方法，进行重新组装，设置成我们自己的请求

```
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
```

- 将上面组装好的请求，通过下面的方法发出。并在这里将发出的请求，进行标记，因为会重走流程，避免循环处理

```
- (void)startLoading {
NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
//给我们处理过的请求设置一个标识符, 防止无限循环,
[NSURLProtocol setProperty:@YES forKey:kBZURLProtocolKey inRequest:mutableReqeust];

NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
self.task = [session dataTaskWithRequest:self.request];
[self.task resume];
}
```

这里通过`task`来进行网络请求发送，也可以在这里进行请求的缓存处理，加快访问

- 最后需要设置代理方法，保证请求被允许和接收到数据后的加载

```
- (void)URLSession:(NSURLSession *)session
dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {

//允许请求加载
[[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session
dataTask:(NSURLSessionDataTask *)dataTask
didReceiveData:(NSData *)data {
//加载数据
[[self client] URLProtocol:self didLoadData:data];
}
```

-  停止请求的时候注意销毁对象 

```
- (void)stopLoading {
if (self.task != nil) {
[self.task  cancel];
}
}
```

- 退出的时候也要注意移除监听 

```
[NSURLProtocol wk_unregisterScheme:@"http"];
[NSURLProtocol unregisterClass:[BZURLProtocol class]];
```

2.通过第三方库 `GCDWebServer` 处理请求


- 建立`server`要在发出请求之前

```
server = [[GCDWebServer alloc] init];
```

- 添加监控方法，这里提供了很多种选择，包含了请求方式和异步同步回调等，这里选择了`GET`方法和异步回调。拿到结果后将其回调给`server`，完成重定向

```
//异步请求函数
[server addDefaultHandlerForMethod:@"GET"
requestClass:[GCDWebServerRequest class]
asyncProcessBlock:^(__kindof GCDWebServerRequest * _Nonnull request, GCDWebServerCompletionBlock  _Nonnull completionBlock) {

if ([request.URL.absoluteString containsString:@"localhost"]) {
//命中了需要特殊处理的请求，这里进行特定操作

NSURL *url = [NSURL URLWithString:@"http://m.baidu.com/static/search/baiduapp_icon.png"];
NSURLRequest *request = [NSURLRequest requestWithURL:url];
NSURLSession *session = [NSURLSession sharedSession];
//发出请求
NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
if (data && error == nil) {
//接收到正确的数据，并返回给server
GCDWebServerDataResponse *response = [GCDWebServerDataResponse responseWithData:data contentType:@"image/jpeg"];
completionBlock(response);
} else {
//数据请求失败，返回给server一个空的或者失败的结果
GCDWebServerDataResponse *response = [GCDWebServerDataResponse response];
completionBlock(response);
}
}];
[task resume];
}
}];
```

- 开启`server` `[server start];`

- 最后是发出请求，否则会发生监控不生效的问题 
