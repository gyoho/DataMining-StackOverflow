var ttCluster = function(){
    var instance = sigma.init(document.getElementById('sigma-example')).drawingProperties({
        drawEdges: false,
        edgeColor: 'default',
        defaultEdgeColor: '#000000'
    }).graphProperties({
        minNodeSize: 2,
        maxNodeSize: 2
    }).mouseProperties({
        maxRatio: 4
    });
    return(instance);
}
