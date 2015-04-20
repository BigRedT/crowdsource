function perc_err = compute_error(true_labels,pred_labels)
correct = sum(true_labels==pred_labels);
num_tasks = numel(true_labels);
perc_err = (1 - correct/num_tasks)*100;
disp(['Error:' num2str(perc_err) '%']);