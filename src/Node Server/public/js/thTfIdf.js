var thTfIdf = function(){
    var instance = sigma.init(document.getElementById('sigma-example')).drawingProperties({
      defaultLabelColor: 'white',
      defaultLabelSize: 18,
      defaultLabelBGColor: '#fff',
      defaultLabelHoverColor: '#000',
      labelThreshold: 6,
      defaultEdgeType: 'curve',
      nodeColor: 'default',
      edgeColor: 'default',
      defaultNodeColor: 'red',
      defaultEdgeColor: '#000000'
    }).graphProperties({
      minNodeSize: 0.2,
      maxNodeSize: 8,
      minEdgeSize: 5,
      maxEdgeSize: 5
    }).mouseProperties({
      maxRatio: 4
    });
    return(instance);
}
