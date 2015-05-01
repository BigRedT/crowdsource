function [Anew,pnew] = updategraph(A,t,p,chosen_task_idx)

workers_per_task = 1;
%% create A new
Anew = A;

%% for each chosen_task_idx sample worker
num_task_chosen = numel(chosen_task_idx);
for i=1:num_task_chosen
    task = chosen_task_idx(i);
    set_rem_workers = find(A(task,:)==0);
    selected_workers = sample_workers(set_rem_workers,workers_per_task);
    for j=1:workers_per_task
        response = rand(1) < p(selected_workers(j));
        response = 2*response-1;
        Anew(task,selected_workers(j)) = response.*t(task);
    end
end
pnew = p;
end

function selected_workers = sample_workers(worker_idx,sample_size)
set_size = numel(worker_idx);
idx = randperm(set_size,sample_size);
selected_workers = worker_idx(idx);
end