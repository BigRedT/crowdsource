function [perc_err, work_err] = compute_error(true_labels,pred_labels,true_worker,pred_worker)
correct = sum(true_labels==pred_labels);
num_tasks = numel(true_labels);
perc_err = (1 - correct/num_tasks)*100;
disp(['Error:' num2str(perc_err) '%']);
% work_err = norm(true_worker-pred_worker,1)/numel(true_worker);
worker_mask  = pred_worker>0;
work_err = norm(true_worker(worker_mask)-pred_worker(worker_mask),Inf);
disp(['Max worker ability error:' num2str(work_err)]);
