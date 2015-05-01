function graph = genGraph(num_tasks,num_workers,r)

graph = eye(num_tasks,num_workers);
B = ones(max(num_workers,num_tasks),2*r);
graph = spdiags(B,[[1:r-1] [-num_tasks+max(num_tasks-num_workers+r-1,0)-r+1:-num_tasks+max(num_tasks-num_workers+r-1,0)]],graph);

