import math

km_per_mile = 0.621371

def haversine(lat1,lon1,lat2,lon2):
    rlat1 = math.radians(lat1)
    rlat2 = math.radians(lat2)
    rlon1 = math.radians(lon1)
    rlon2 = math.radians(lon2)
    radius = 6371 * 1000
    t1 = math.pow(math.sin((rlat2-rlat1)/2),2)
    t2 = math.cos(rlat1) * math.cos(rlat2) * math.pow(math.sin((rlon2-rlon1)/2),2)
    return (2 * radius * math.sqrt(t1 + t2))/1000

#compute distance from Boston to LA
dist = haversine(42.3601,-71.0589, 34.0500, -118.2500)
print "km = %f, miles = %f"%(dist, dist * km_per_mile)

#compute distance along Vassar St
dist = haversine(42.362563, -71.089984, 42.360319, -71.094855)
print "km = %f, miles = %f"%(dist, dist * km_per_mile)
