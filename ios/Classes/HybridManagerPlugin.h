#import <Flutter/Flutter.h>

@protocol HybridManagerDelegate <NSObject>
//flutter 打开原生
- (void)flutterOpenNativeWithURL:(NSString *)url params:(NSDictionary *)params;
//网络请求
- (void)sendRequestWithURL:(NSString *)url params:(NSDictionary *)params complete:(void (^)(NSString *reponse,NSError *error))complete;

@end

@interface HybridManagerPlugin : NSObject<FlutterPlugin>

@property (nonatomic,strong) FlutterMethodChannel* methodChannel;
@property (nonatomic, copy) NSDictionary *mainEntryParams;
@property (nonatomic, weak) id<HybridManagerDelegate> delegate;

+ (instancetype)sharedInstance;
+ (void)openFlutterWithURL:(NSString *)url params:(NSDictionary *)params;
+ (void)openFlutterWithURL:(NSString *)url params:(NSDictionary *)params animated:(BOOL)animated;

@end
