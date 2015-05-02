
num_workers = 30;
num_tasks = 2000;
graph = genGraph(num_tasks,num_workers,10);
% [A,t,p] = createGraph(num_workers,num_tasks,'method','custom','graph',graph);
[A,t,p] = createGraph(num_workers,num_tasks,'method','project','frac_edges',0.5);%4000.0/num_workers/num_tasks);

prob_t_given_A_p = rand(num_tasks,1);
[prob_t_given_A_p,worker_abilities] = EM(A,prob_t_given_A_p,'iterMax',30,'prior','betaPrior');
% [prob_t_given_A_p,worker_abilities] = EM(A,prob_t_given_A_p,'iterMax',30);

pred_labels = 2*(prob_t_given_A_p > 0.5) - 1;
task_mask = prob_t_given_A_p==-1;
pred_labels(task_mask) = 0;
err = compute_error(t,pred_labels,p,worker_abilities);
num_edges = numel(find(abs(A)));
disp(['Number of edges: ' num2str(num_edges)]);


