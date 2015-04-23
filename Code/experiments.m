rng(10);
%% Effect of r-regularization
num_tasks = 2000;
prob_t_given_A_p_init = 0.5*ones(num_tasks,1);
N = 50;
workers = round(logspace(log10(15),log10(30000),N));
error_r_reg = zeros(N,1);
num_edges = zeros(N,1);
T = 1;
for k = 1:T
    for i = 1:N
        disp([num2str(k) ' ' num2str(i)]);
        frac_edges = 30000/(workers(i)*num_tasks);
        [A,t,p] = createGraph(workers(i),num_tasks,'method','project','frac_edges',frac_edges);
        [prob_t_given_A_p,worker_abilities] = EM(A,prob_t_given_A_p_init,'iterMax',10);
        pred_labels = 2*(prob_t_given_A_p > 0.5) - 1;
        error_r_reg(i) = error_r_reg(i) + compute_error(t,pred_labels);
        num_edges(i) = num_edges(i) + size(find(abs(A)==1),1);
    end
end

error_r_reg = error_r_reg/T;
num_edges = num_edges/T;