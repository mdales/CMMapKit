@import <Foundation/CPObject.j>
@import "CMMapView.j"

@implementation CMLatLngBounds : CPObject 
{
    CMLatLng _northEast @accessors(property=northEast);
    CMLatLng _southWest @accessors(property=southWest);
}

- (id)initWithNorthEastLocation: (CMLatLng)northEast
    andSouthWestLocation: (CMLatLng)southWest
{
    if (self = [super init]) 
    {
        _northEast = northEast;
        _southWest = southWest;
    }
    
    return self;
}

- (JSObject)cmRepresentation
{
    var cm = [CMMapView cmNamespace];
    return new cm.LatLngBounds([_southWest cmRepresentation], [_northEast cmRepresentation])
}

- (CMLatLng)center
{
    var bounds = [self cmRepresentation];
    var location = gbounds.getCenter();
    return [[CMLatLng alloc] initWithLatitude: location.lat()
        andLongitude: location.lng()];
}


@end;