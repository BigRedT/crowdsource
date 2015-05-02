num_workers = 100;
num_tasks = 2000;
edge_budget = 30000;

error = cell(100,1);
error_r = cell(100,1);
num_edges = cell(100,1);
A = cell(100,1);
graph_init = cell(100,1);
parfor i = 1:100
    disp(['Monte Carlo Ensemble:' num2str(i)]);
    [A{i},~,~] = createGraph(num_workers,num_tasks,'method','random_connected');
    graph_init{i} = abs(A{i});
    [error{i},error_r{i},num_edges{i}] = adaptiveCrowdSource(graph_init{i},edge_budget);
end


save('error.mat','error');
save('error_r.mat','error_r');
save('num_edges.mat','error_r');