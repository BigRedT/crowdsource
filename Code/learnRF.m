function model = learnRF(graph,ensemble_size)
prob_t_given_A_p = cell(ensemble_size,1);
worker_abilities = cell(ensemble_size,1);
% abilityHist_cell = cell(ensemble_size,1);
% degree = cell(ensemble_size,1);
t = cell(ensemble_size,1);
[num_tasks,num_workers] = size(graph);
for T=1:ensemble_size
    [A,t{T},p] = createGraph(num_workers,num_tasks,'method','custom','graph',graph);
%     [A,t{T},p] = createGraph(num_workers,num_tasks,'method','project','frac_edges',20000.0/num_workers/num_tasks);
    prob_t_given_A_p_init = rand(num_tasks,1);
    [prob_t_given_A_p{T},worker_abilities{T}] = EM(A,prob_t_given_A_p_init,'iterMax',40,'prior','betaPrior');
%     degree{T} = sum(graph,2);
%     degree{T} = sum(abs(A),2);
%     abilityHist_cell{T} = histWorkerAbilities(worker_abilities{T},A);
end
true_t = cell2mat(t);
prob_t = cell2mat(prob_t_given_A_p);
pred_labels = 2*(prob_t > 0.5) - 1;
task_mask = prob_t==-1;
pred_labels(task_mask) = 0;

% entropy_t = -prob_t.*log2(prob_t) - (1-prob_t).*log2(1-prob_t);
% nanidx = isnan(entropy_t);
% entropy_t(nanidx) = 0;

worker_abil = cell2mat(worker_abilities);
graph_repmat = repmat(graph,T,1);
% degree_task = cell2mat(degree);
% abilityHist = cell2mat(abilityHist_cell);
X = genFeatures(prob_t,worker_abil,graph_repmat);
% X = [entropy_t degree_task abilityHist];

correct = pred_labels==true_t;
Y = double(correct);

[model,hs,ps] = learnClassifier(X,Y+1);
pred_label = hs-1;
[sort_p_correct,sort_idx] = sort(ps(:,1),'descend');
[sort_p_correct,Y(sort_idx)];

% B = glmfit(X, [Y ones(size(X,1),1)], 'binomial', 'link', 'logit')
% save('LRcoeff.mat','B');
% load LRcoeff.mat;
% log_ratio = [ones(size(X,1),1) X]*B;
% [sort_p_correct,sort_idx] = sort(log_ratio);
% [sort_p_correct,Y(sort_idx)];

[precision,recall] = getROC(ps,Y,T,num_tasks);

disp('Total EM error')
sum(~correct)






