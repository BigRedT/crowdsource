num_workers = 2000;
num_tasks = 2000;
[A,t,p] = createGraph(num_workers,num_tasks,'method','project');
prob_t_given_A_p = 0.5*ones(num_tasks,1);
[prob_t_given_A_p,worker_abilities] = EM(A,prob_t_given_A_p,'iterMax',20);
pred_labels = 2*(prob_t_given_A_p > 0.5) - 1;
err = compute_error(t,pred_labels);