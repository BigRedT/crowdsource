function model = learnRF(graph,ensemble_size,prior_type)
prob_t_given_A_p = cell(ensemble_size,1);
worker_abilities = cell(ensemble_size,1);
t = cell(ensemble_size,1);
[num_tasks,num_workers] = size(graph);
for T=1:ensemble_size
    [A,t{T},p] = createGraph(num_workers,num_tasks,'method','custom','graph',graph);
    prob_t_given_A_p_init = rand(num_tasks,1);
    [prob_t_given_A_p{T},worker_abilities{T}] = EM(A,prob_t_given_A_p_init,'iterMax',30,'prior',prior_type);
end
true_t = cell2mat(t);
prob_t = cell2mat(prob_t_given_A_p);
pred_labels = 2*(prob_t > 0.5) - 1;
task_mask = prob_t==-1;
pred_labels(task_mask) = 0;

worker_abil = cell2mat(worker_abilities);
graph_repmat = repmat(graph,T,1);
X = genFeatures(prob_t,worker_abil,graph_repmat);

correct = pred_labels==true_t;
Y = double(correct);

[model,hs,ps] = learnClassifier(X,Y+1);
[sort_p_correct,sort_idx] = sort(ps(:,1),'descend');
[sort_p_correct,Y(sort_idx)];

[precision,recall] = getROC(ps,Y,T,num_tasks);

% disp('Total EM error')
% sum(~correct)






