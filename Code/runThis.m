num_workers = 2000;
num_tasks = 2000;
graph = eye(num_tasks,num_workers);
graph = spdiag(1999,1,graph);
[A,t,p] = createGraph(num_workers,num_tasks,'method','custom','graph',);
prob_t_given_A_p = 0.5*ones(num_tasks,1);
[prob_t_given_A_p,worker_abilities] = EM(A,prob_t_given_A_p,'iterMax',20);
pred_labels = 2*(prob_t_given_A_p > 0.5) - 1;
err = compute_error(t,pred_labels);

