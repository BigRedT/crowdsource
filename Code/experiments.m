% rng(10);
%% Effect of r-regularization
num_tasks = 2000;
prob_t_given_A_p_init = 0.5*ones(num_tasks,1);
N = 30;
workers = round(logspace(log10(5),log10(100),N));
error_r_reg = zeros(N,1);
work_r_reg = zeros(N,1);
num_edges = zeros(N,1);
T = 100;
for k = 1:T
    tic;
    for i = 1:N
        disp([num2str(k) ' ' num2str(i)]);
        frac_edges = 10000/(workers(i)*num_tasks);
        [A,t,p] = createGraph(workers(i),num_tasks,'method','project','frac_edges',frac_edges);
        [prob_t_given_A_p,worker_abilities] = EM(A,prob_t_given_A_p_init,'iterMax',30,'prior','betaPrior');
        pred_labels = 2*(prob_t_given_A_p > 0.5) - 1;
        [perc_err,work_err] = compute_error(t,pred_labels,p,worker_abilities);
        error_r_reg(i) = error_r_reg(i) + perc_err;
        work_r_reg(i) = work_r_reg(i) + work_err;
        num_edges(i) = num_edges(i) + size(find(abs(A)==1),1);
    end
    toc;
end

error_r_reg = error_r_reg/T;
work_r_reg = work_r_reg/T;
num_edges = num_edges/T;
save('experiments.mat');