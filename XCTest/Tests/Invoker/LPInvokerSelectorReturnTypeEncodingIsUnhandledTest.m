#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LPInvoker.h"

// Testing the #selectorReturnTypeEncodingIsUnhandled LPInvoker method.

@interface LPInvokerEncodingIsUnhandledTest : XCTestCase

@end

@implementation LPInvokerEncodingIsUnhandledTest

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

#pragma mark - Mocking

- (id) expectInvokerEncoding:(NSString *) mockEncoding {
  LPInvoker *invoker = [[LPInvoker alloc] initWithSelector:@selector(length)
                                                    target:@"string"];
  id mock = [OCMockObject partialMockForObject:invoker];
  [[[mock expect] andReturn:mockEncoding] encodingForSelectorReturnType];
  return mock;
}

- (void) testUnhandledEncodingVoidStar {
  NSString *encoding = @(@encode(void *));
  id mock = [self expectInvokerEncoding:encoding];
  XCTAssertTrue([mock selectorReturnTypeEncodingIsUnhandled]);
  [mock verify];
}

- (void) testUnhandledEncodingTypeStar {
  NSString *encoding = @(@encode(float *));
  id mock = [self expectInvokerEncoding:encoding];
  XCTAssertTrue([mock selectorReturnTypeEncodingIsUnhandled]);
  [mock verify];
}

- (void) testUnhandledEncodingNSObjectStarStar {
  NSString *encoding = @(@encode(typeof(NSObject **)));
  id mock = [self expectInvokerEncoding:encoding];
  XCTAssertTrue([mock selectorReturnTypeEncodingIsUnhandled]);
  [mock verify];
}

- (void) testUnhandledEncodingClassObject {
  NSString *encoding = @(@encode(typeof([NSObject class])));
  id mock = [self expectInvokerEncoding:encoding];
  XCTAssertFalse([mock selectorReturnTypeEncodingIsUnhandled]);
  [mock verify];
}

- (void) testUnhandledEncodingClassInstance {
  NSString *encoding = @(@encode(typeof(NSObject)));
  id mock = [self expectInvokerEncoding:encoding];
  XCTAssertFalse([mock selectorReturnTypeEncodingIsUnhandled]);
  [mock verify];
}

- (void) testUnhandledEncodingStruct {
  typedef struct _struct {
    short a;
    long long b;
    unsigned long long c;
  } Struct;
  NSString *encoding = @(@encode(typeof(Struct)));
  id mock = [self expectInvokerEncoding:encoding];
  XCTAssertFalse([mock selectorReturnTypeEncodingIsUnhandled]);
  [mock verify];
}

- (void) testUnhandledEncodingCArray {
  int arr[5] = {1, 2, 3, 4, 5};
  NSString *encoding = @(@encode(typeof(arr)));
  id mock = [self expectInvokerEncoding:encoding];
  XCTAssertTrue([mock selectorReturnTypeEncodingIsUnhandled]);
  [mock verify];
}

- (void) testUnhandledEncodingSelector {
  NSString *encoding = @(@encode(typeof(@selector(length))));
  id mock = [self expectInvokerEncoding:encoding];
  XCTAssertTrue([mock selectorReturnTypeEncodingIsUnhandled]);
  [mock verify];
}

- (void) testUnhandledEncodingUnion {

  typedef union _myunion {
    double PI;
    int B;
  } MyUnion;

  NSString *encoding = @(@encode(typeof(MyUnion)));
  id mock = [self expectInvokerEncoding:encoding];
  XCTAssertTrue([mock selectorReturnTypeEncodingIsUnhandled]);
  [mock verify];
}

- (void) testUnhandledEncodingBitField {
  // Don't know how to create a bitfield
  NSString *encoding = @"b5";
  id mock = [self expectInvokerEncoding:encoding];
  XCTAssertTrue([mock selectorReturnTypeEncodingIsUnhandled]);
  [mock verify];
}

- (void) testUnhandledUnknown {
  NSString *encoding = @"?";
  id mock = [self expectInvokerEncoding:encoding];
  XCTAssertTrue([mock selectorReturnTypeEncodingIsUnhandled]);
  [mock verify];
}

- (void) testUnhandledCGPoint {
  NSString *encoding = @(@encode(typeof(CGPointZero)));
  id mock = [self expectInvokerEncoding:encoding];
  XCTAssertFalse([mock selectorReturnTypeEncodingIsUnhandled]);
  [mock verify];
}

- (void) testUnhandledCGRect {
  NSString *encoding = @(@encode(typeof(CGRectZero)));
  id mock = [self expectInvokerEncoding:encoding];
  XCTAssertFalse([mock selectorReturnTypeEncodingIsUnhandled]);
  [mock verify];
}

- (void) testConstCharStar {
  NSString *encoding = @(@encode(typeof(const char *)));
  id mock = [self expectInvokerEncoding:encoding];
  BOOL actual = [mock selectorReturnTypeEncodingIsUnhandled];
  expect(actual).to.equal(NO);
  [mock verify];
}

- (void) testConst {
  NSString *encoding = @"r";
  id mock = [self expectInvokerEncoding:encoding];
  BOOL actual = [mock selectorReturnTypeEncodingIsUnhandled];
  expect(actual).to.equal(YES);
  [mock verify];

  encoding = @"r?";
  mock = [self expectInvokerEncoding:encoding];
  actual = [mock selectorReturnTypeEncodingIsUnhandled];
  expect(actual).to.equal(YES);
  [mock verify];
}

@end
