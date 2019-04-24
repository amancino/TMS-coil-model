function [scirunfield] = writeCoilGeometry(Nwires,Hsteps,conf,filename,Npoints)

  % conf = xo2conf(data.xo{1});
  [Gamma,offset,alpha] = Figure8AirFilmCoil(Nwires,Hsteps,conf,Npoints);

  scirunfield.fieldbasis = 'ConstantBasis';
  scirunfield.fieldbasisorder = 0;
  scirunfield.fieldtype = 'double';
  scirunfield.meshbasis = 'CrvLinearLgn';
  scirunfield.meshbasisorder = 1;
  scirunfield.meshtype = 'CurveMesh';

  scirunfield.node = [];
  scirunfield.edge = [];
  scirunfield.field = [];
  scirunfield.fieldedge = [];
  start = 1;
  
  for coil = 1:length(Gamma)
    
    node = 1000*Gamma{coil}';
    N = size(node,2);

    % scirunfield.node has the nodes of the coil


    scirunfield.node = [scirunfield.node node];

    % scirunfield.edge has tuples of nodes determining the edges or conducting
    % wires
    edge(1,1:N-1) = start:start+N-2;
    edge(2,1:N-1) = start+1:start+N-1;
    scirunfield.edge = [scirunfield.edge edge];

    % scirunfield.field has the magnitude and direction of the running current
    % for each edge
    scirunfield.field = [scirunfield.field ones(1,N-1)*alpha*1000000];

    % scirunfield.fieldedge might be the order of the edges (array from 1 to Nel)
    scirunfield.fieldedge = [scirunfield.fieldedge uint32(start:start+N-2)];
    
    start = start+N;
  end

end
