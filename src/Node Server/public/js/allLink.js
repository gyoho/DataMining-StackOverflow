var allLink = function(){
    var instance = sigma.init(document.getElementById('sigma-example')).drawingProperties({
        defaultEdgeType: 'curve',
        nodeColor: 'default',
        edgeColor: 'default',
        defaultNodeColor: 'red',
        defaultEdgeColor: '#000000'
    }).graphProperties({
        minNodeSize: 0.2,
        maxNodeSize: 8,
        minEdgeSize: 0.05,
        maxEdgeSize: 0.05
    }).mouseProperties({
        maxRatio: 4
    });
    return(instance);
}
