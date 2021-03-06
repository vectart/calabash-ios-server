#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import <XCTest/XCTest.h>
#import "LPReflectionRoute.h"

@interface LPReflectionRoute (LPXCTEST)

- (NSArray *) libraryNames;
- (NSArray *) classNames;

@end

@interface LPReflectionRouteTest : XCTestCase

@property(nonatomic, strong) LPReflectionRoute *route;

@end

@implementation LPReflectionRouteTest

- (void) setUp {
  [super setUp];
  self.route = [LPReflectionRoute new];
}

- (void) tearDown {
  [super tearDown];
  self.route = nil;
}

- (void) testSupportsMethodGET {
  expect([self.route supportsMethod:@"GET" atPath:nil]).to.equal(YES);
}

- (void) testSupportsMethodAnythingButGET {
  expect([self.route supportsMethod:@"POST" atPath:nil]).to.equal(NO);
}

- (void) testImageNames {
  NSArray *imageNames = [self.route libraryNames];
  expect(imageNames).notTo.equal(nil);
  expect([imageNames count]).to.beGreaterThan(0);
}

- (void) testClassNames {
  NSArray *classNames = [self.route classNames];
  expect(classNames).notTo.equal(nil);
  expect([classNames count]).to.beGreaterThan(0);
}

- (void) testJSONResponseForMethod {
  NSDictionary *dictionary = [self.route JSONResponseForMethod:nil
                                                           URI:nil
                                                          data:nil];
  expect(dictionary).notTo.equal(nil);

  NSArray *libriaries = dictionary[@"libraries"];
  NSArray *classes = dictionary[@"classes"];

  expect(libriaries).notTo.equal(nil);
  expect([libriaries isKindOfClass:[NSArray class]]).to.equal(YES);
  expect([libriaries count]).to.beGreaterThan(0);


  expect(classes).notTo.equal(nil);
  expect([classes isKindOfClass:[NSArray class]]).to.equal(YES);
  expect([classes count]).to.beGreaterThan(0);
}

@end
