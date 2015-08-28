function init(graph) {

    /**
    * This is the code to write the FishEye plugin :
    */

    (function(){

        // First, let's write a FishEye class.
        // There is no need to make this class global, since it is made to be used through
        // the SigmaPublic object, that's why a local scope is used for the declaration.
        // The parameter 'sig' represents a Sigma instance.
        var FishEye = function(sig) {
            sigma.classes.Cascade.call(this);      // The Cascade class manages the chainable property
            // edit/get function.

            var self = this;                       // Used to avoid any scope confusion.
            var isActivated = false;               // Describes is the FishEye is activated.

            this.p = {                             // The object containing the properties accessible with
                radius: 200,                         // the Cascade.config() method.
                power: 2
            };

            // This method will apply a formula relatively to the mouse position.
            function applyFishEye(mouseX, mouseY) {

                var newDist, newSize, xDist, yDist, dist,
                radius   = self.p.radius,
                power    = self.p.power,
                powerExp = Math.exp(power);

                sig.graph.nodes.forEach(function(node) {
                    xDist = node.displayX - mouseX;
                    yDist = node.displayY - mouseY;
                    dist  = Math.sqrt(xDist*xDist + yDist*yDist);

                    if(dist < radius){
                        newDist = powerExp/(powerExp-1)*radius*(1-Math.exp(-dist/radius*power));
                        newSize = powerExp/(powerExp-1)*radius*(1-Math.exp(-dist/radius*power));

                        if(!node.isFixed){
                            node.displayX = mouseX + xDist*(newDist/dist*3/4 + 1/4);
                            node.displayY = mouseY + yDist*(newDist/dist*3/4 + 1/4);
                        }

                        node.displaySize = Math.min(node.displaySize*newSize/dist,10*node.displaySize);
                    }
                });
            };

            // The method will be triggered when Sigma's 'graphscaled' is dispatched.
            function handler() {
                applyFishEye(
                    sig.mousecaptor.mouseX,
                    sig.mousecaptor.mouseY
                );
            }

            this.handler = handler;

            // A public method to set/get the isActivated parameter.
            this.activated = function(v) {
                if(v==undefined){
                    return isActivated;
                }else{
                    isActivated = v;
                    return this;
                }
            };

            // this.refresh() is just a helper to draw the graph.
            this.refresh = function(){
                sig.draw(2,2,2);
            };
        };

        // Then, let's add some public method to sigma.js instances :
        sigma.publicPrototype.activateFishEye = function() {
            if(!this.fisheye) {
                var sigmaInstance = this;
                var fe = new FishEye(sigmaInstance._core);
                sigmaInstance.fisheye = fe;
            }

            if(!this.fisheye.activated()){
                this.fisheye.activated(true);
                this._core.bind('graphscaled', this.fisheye.handler);
                document.getElementById(
                    'sigma_mouse_'+this.getID()
                ).addEventListener('mousemove',this.fisheye.refresh,true);
            }

            return this;
        };

        sigma.publicPrototype.desactivateFishEye = function() {
            if(this.fisheye && this.fisheye.activated()){
                this.fisheye.activated(false);
                this._core.unbind('graphscaled', this.fisheye.handler);
                document.getElementById(
                    'sigma_mouse_'+this.getID()
                ).removeEventListener('mousemove',this.fisheye.refresh,true);
            }

            return this;
        };

        sigma.publicPrototype.fishEyeProperties = function(a1, a2) {
            var res = this.fisheye.config(a1, a2);
            return res == s ? this.fisheye : res;
        };
    })();


    // Instanciate sigma.js and customize rendering :
    if(graph=="300QuestionsSimilarityAnalysisTfIdf")
        var sigInst = thTfIdf();

    if(graph=="300QuestionsSimilarityAnalysisBin")
        var sigInst = thBin();

    if(graph=="1000QuestionsClusteringOpenOrd")
        var sigInst = ttCluster();

    if(graph=="AllQuestionsLinkAnalysis")
        var sigInst = allLink();

    // Parse a GEXF encoded file to fill the graph
    // (requires "sigma.parseGexf.js" to be included)
    sigInst.parseGexf('data/'+graph+'.gexf');



    // Bind events :
    sigInst.bind('overnodes',function(event){
        var nodes = event.content;
        var neighbors = {};
        sigInst.iterEdges(function(e){
            if(nodes.indexOf(e.source)>=0 || nodes.indexOf(e.target)>=0){
                neighbors[e.source] = 1;
                neighbors[e.target] = 1;
            }
        }).iterNodes(function(n){
            if(!neighbors[n.id]){
                n.hidden = 1;
            }else{
                n.hidden = 0;
            }
        }).draw(2,2,2);
    }).bind('outnodes',function(){
        sigInst.iterEdges(function(e){
            e.hidden = 0;
        }).iterNodes(function(n){
            n.hidden = 0;
        }).draw(2,2,2);
    });

    // Mod Dmitry
    sigInst.bind('downnodes',function(event){
        var node;
        sigInst.iterNodes(function(n){
            node = n;
        },[event.content[0]]);
        window.open("http://askubuntu.com/questions/"+node['id']);
    });

    // Draw the graph:
    sigInst.activateFishEye().draw();
}
