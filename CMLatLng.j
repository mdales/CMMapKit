@import <Foundation/CPObject.j>
@import "CMMapView.j"


@implementation CMLatLng: CPObject
{
    float         _latitude   @accessors(property=latitude);
    float         _longitude  @accessors(property=longitude);
}


+ (CMLatLng)location
{
    return [[CMLatLng alloc] init];
}

+ (CMLatLng)locationWithLatitude:(float)aLat andLongitude:(float)aLng {
    return [[CMLatLng alloc] initWithLatitude:aLat andLongitude:aLng];
}

- (id)initWithLatLng:(LatLng)aLatLng {
    return [self initWithLatitude:aLatLng.lat() andLongitude:aLatLng.lng()];
}

- (id)initWithLatitude:(float)aLat andLongitude:(float)aLng
{
    if (self = [super init]) {
        _latitude = aLat;
        _longitude = aLng;
    }
    return self;
}

- (JSObject)cmRepresentation 
{
    var cm = [CMMapView2 cmNamespace];
    return new cm.LatLng(_latitude, _longitude);
}

- (void)encodeWithCoder:(CPCoder)coder
{
    [coder encodeObject:[_latitude, _longitude] forKey:@"location"];
}

@end