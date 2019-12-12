function(cluster) {
    var c_count = cluster.getChildCount();
    var c = ' marker-cluster-';
    if (c_count < 10) {
        c += 'small';
    } else if (c_count < 20) {
        c += 'medium';
    } else if (c_count < 40) {
        c += 'medium-large';
    } else {
        c += 'large';
    }
    return new L.DivIcon({ html: '<div><span>' + c_count + '</span></div>', className: 'marker-cluster' + c, iconSize: new L.Point(40, 40) });
}
