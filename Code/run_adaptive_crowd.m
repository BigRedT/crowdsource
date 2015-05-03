function run_adaptive_crowd(i)
rng(i);
num_workers = 100;
num_tasks = 2000;
edge_budget = 30000;

disp(['Monte Carlo Ensemble:' num2str(i)]);
[A,~,~] = createGraph(num_workers,num_tasks,'method','random_connected');
graph_init= abs(A);
[error_w,error_r_w,num_edges_w] = adaptiveCrowdSource(graph_init,edge_budget,'betaPrior',i);
[error_wo,error_r_wo,num_edges_wo] = adaptiveCrowdSource(graph_init,edge_budget,'noPrior',i);



save(['Data/' num2str(i) '_error.mat'],'error_w','error_wo');
save(['Data/' num2str(i) '_error_r.mat'],'error_r_w','error_r_wo');
save(['Data/' num2str(i) '_num_edges.mat'],'num_edges_w','num_edges_wo');
save(['Data/' num2str(i) '_A.mat'],'A');
save(['Data/' num2str(i) '_graph_init.mat'],'graph_init');

end