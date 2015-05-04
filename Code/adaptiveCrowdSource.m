function [error,error_r,num_edges] = adaptiveCrowdSource(graph_init,edge_budget,prior_type,par_idx)

%% Pipeline Parameters
RF_ensemble_size = 5;
num_edges_graph_init = sum(graph_init(:));
num_levels = 100;
edges_per_level = (edge_budget - num_edges_graph_init)/num_levels;
% edges_per_task = edge_budget/4000
num_edges_used = num_edges_graph_init;
[num_tasks num_workers] = size(graph_init);
[A,t,p] = createGraph(num_workers,num_tasks,'method','custom','graph',graph_init);
A_r = A;
graph = graph_init;
graph_r = graph_init;
error = [];
num_edges = [];
error_r = [];
elapsed_time = [];
count =0;
fig_h = figure('units','normalized','outerposition',[0 0 1 1]);
% set(fig_h,'visible','off');
while(num_edges_used<edge_budget)
    count = count+1;
    tStart = tic;
    worker_counts = sum(abs(A),2);
%     figure(1),
    histvals=histc(worker_counts,[0:1:num_workers]);
%     bar(histvals);
%    xlim([0, 30]);
    %% Run EM
    prob_t_given_A_p_init = rand(num_tasks,1);
    [prob_t_given_A_p,worker_abilities] = EM(A,prob_t_given_A_p_init,'iterMax',30,'prior',prior_type);
    [prob_t_given_A_p_r,worker_abilities_r] = EM(A_r,prob_t_given_A_p_init,'iterMax',30,'prior',prior_type);
        
    %% Compute error
    pred_labels = 2*(prob_t_given_A_p > 0.5) - 1;
    task_mask = prob_t_given_A_p==-1;
    pred_labels(task_mask) = 0;
    [perc_err, work_err] = compute_error(t,pred_labels,p,worker_abilities);
    error = [error; [perc_err, work_err]];
    num_edges = [num_edges; num_edges_used];
    
    %% Compute error random update
    pred_labels_r = 2*(prob_t_given_A_p_r > 0.5) - 1;
    task_mask_r = prob_t_given_A_p_r==-1;
    pred_labels_r(task_mask_r) = 0;
    [perc_err_r, work_err_r] = compute_error(t,pred_labels_r,p,worker_abilities_r);
    error_r = [error_r; [perc_err_r, work_err_r]];
        
    %% learn RF
    [RF_model, precision, recall, selected_thresh] = learnRF(graph,RF_ensemble_size,prior_type);
    
    %% Gen features
    features = genFeatures(prob_t_given_A_p,worker_abilities,graph);
    
    %% Appy RF
    [~,ps] = forestApply(single(features),RF_model);
    
    %% Rank tasks in descending order of incorrectness
    sort_idx = rank_tasks(ps,prob_t_given_A_p);
    sort_idx_r = randperm(num_tasks,num_tasks);
    
    workers_per_task = sum(abs(A),2);
    sorted_workers_per_task = workers_per_task(sort_idx);
    finished_mask = sorted_workers_per_task==num_workers;
    filtered_sort_idx = sort_idx(~finished_mask);
    
    workers_per_task_r = sum(abs(A_r),2);
    sorted_workers_per_task_r = workers_per_task_r(sort_idx_r);
    finished_mask_r = sorted_workers_per_task_r==num_workers;
    filtered_sort_idx_r = sort_idx_r(~finished_mask_r);
    
    %% Select top num_task_chosen tasks
    num_tasks_chosen = min(round(edges_per_level),numel(filtered_sort_idx));
    num_tasks_chosen_r = min(round(edges_per_level),numel(filtered_sort_idx_r));
        
    %% A,p = updategraph(A,t,p,chosen_task_idx)
    % Select workers to work on task, sample new workers if needed, sample
    % new entries for A
    
    [A,p] = updategraph(A,t,p,filtered_sort_idx(1:num_tasks_chosen));
    [A_r,p] = updategraph(A_r,t,p,filtered_sort_idx_r(1:num_tasks_chosen_r));
    
    
    %% Update num edges used
    num_edges_used = sum(abs(A(:)));
    elapsed_time = [elapsed_time toc(tStart)];
    
    
%     [error(:,1) error_r(:,1)];

    figure(fig_h);
    subplot(1,2,1);
    bar(histvals); xlim([0 num_workers]); xlabel('Number of workers on the task'); ylabel('Frequency of tasks');
%     subplot(2,2,3);
%     plot(recall,precision,'r-'); xlabel('Recall'); ylabel('Precision'); axis([0 1 0 1]);
%     subplot(2,2,4);
%     plot(selected_thresh,precision,'b-'); xlabel('Number of ranked tasks observed'); ylabel('Precision'); axis([1 RF_ensemble_size*num_tasks 0 1]);
    subplot(1,2,2);
    semilogy(num_edges,error(:,1),'b-'); hold on; semilogy(num_edges,error_r(:,1),'r-'); hold off;
    xlim([0 30000]); ylim([0.01 100])
    legend({'EdgeAdapt','Random'});
    xlabel('number of edges used')
    ylabel('percent task assignment error')
    saveas(gcf,['Figures/' num2str(count) '.png']);
%     figure(3)
%     plot(num_edges, elapsed_time, 'b-');
    
end
   

tStart = tic;
prob_t_given_A_p_init = rand(num_tasks,1);
[prob_t_given_A_p,worker_abilities] = EM(A,prob_t_given_A_p_init,'iterMax',30,'prior',prior_type);
    
%% Compute error
pred_labels = 2*(prob_t_given_A_p > 0.5) - 1;
task_mask = prob_t_given_A_p==-1;
pred_labels(task_mask) = 0;
[perc_err, work_err] = compute_error(t,pred_labels,p,worker_abilities);
error = [error; [perc_err, work_err]];
num_edges = [num_edges; num_edges_used];

%% Random graph
[prob_t_given_A_p_r,worker_abilities_r] = EM(A_r,prob_t_given_A_p_init,'iterMax',30,'prior',prior_type);
    
%% Compute error random update
pred_labels_r = 2*(prob_t_given_A_p_r > 0.5) - 1;
task_mask_r = prob_t_given_A_p_r==-1;
pred_labels_r(task_mask_r) = 0;
[perc_err_r, work_err_r] = compute_error(t,pred_labels_r,p,worker_abilities_r);
error_r = [error_r; [perc_err_r, work_err_r]];

tStop = toc(tStart);
elapsed_time = [elapsed_time tStop];



% figure(2)
% plot(num_edges,error(:,1),'b-');
% hold on;
% plot(num_edges,error_r(:,1),'r-');
% hold off;
% xlabel('number of edges used')
% ylabel('percent task assignment error')
% legend({'EdgeAdapt','Random'});
% 
% figure(3)
% plot(num_edges, elapsed_time, 'b-');

%save(['Data/' num2str(par_idx) '_' prior_type '.mat'],'error','error_r','A','A_r');