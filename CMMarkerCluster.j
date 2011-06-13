@import <Foundation/CPObject.j>
@import "CMMapView.j"

@implementation CMMarkerCluster: CPObject
{
    JSObject _cluster;
}


///////////////////////////////////////////////////////////////////////////////
//
- (id)initWithMapView: (CMMapView)mapView
{
    if (self = [super init])
    {
        // don't be lazy here, create the object immediately
        var cm = [CMMapView cmNamespace];
        
        _cluster = cm.MarkerCluster([mapView cmRepresentation]);
    }
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////
//
- (id)initWithMapView: (CMMapView)mapView
    clusterRadius: (float)radius
{
    if (self = [super init])
    {
        // don't be lazy here, create the object immediately
        var cm = [CMMapView cmNamespace];
        
        _cluster = cm.MarkerCluster([mapView cmRepresentation], {clusterRadius: radius});
    }
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////
//
- (JSObject)cmRepresentation
{
    return _cluster;
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)addMarker: (CMMarker)marker
{
    _cluster.addMarker([marker cmRepresentation]);
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)addMarkers: (CPArray)markerList
{
    var list = [];
    for (in i = 0; i < [markerList count]; i++)
    {
        var marker = [markerList objectAtIndex: i];
        list.push([marker cmRepresentation]);
    }
    
    _cluster.addMarkers(list);
}




@end