var thBin = function(){
    var instance = sigma.init(document.getElementById('sigma-example')).drawingProperties({
      defaultLabelColor: 'white',
      defaultLabelSize: 18,
      defaultLabelHoverColor: 'black',
      labelThreshold: 8,
      defaultEdgeType: 'curve',
      nodeColor: 'default',
      edgeColor: 'default',
      defaultNodeColor: 'red',
      defaultEdgeColor: '#000000'
    }).graphProperties({
      minNodeSize: 0.2,
      maxNodeSize: 8,
      minEdgeSize: 1,
      maxEdgeSize: 1
    }).mouseProperties({
      maxRatio: 4
    });
    return(instance);
}
