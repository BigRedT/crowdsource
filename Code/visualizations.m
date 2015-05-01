wrong_idx = pred_labels ~= t;
% figure(1), hist(prob_t_given_A_p(wrong_idx))
% figure(2), hist(prob_t_given_A_p(~wrong_idx))
% figure(3), plot(p,worker_abilities,'ro')
find(A(wrong_idx(1),:))
wrong_tasks = find(wrong_idx)
worker_task_1= find(A(wrong_tasks(1),:));
p(worker_task_1)
[p(worker_task_1) worker_abilities(worker_task_1)]

%% num workers

num_workers_per_task = sum(abs(A),2);
figure(4),hist(num_workers_per_task);
figure(5),hist(num_workers_per_task(wrong_idx));
figure(6),hist(num_workers_per_task(~wrong_idx)); 
sum(num_workers_per_task)/2000

% correct_predictions = A==repmat(t,1,num_workers);
% classification_mat = A;
% classification_mat(correct_predictions) = 1;
% classification_mat()

figure(7)
plot(prob_t_given_A_p(wrong_idx),num_workers_per_task(wrong_idx),'ro')
%hold on
%plot(prob_t_given_A_p(~wrong_idx),num_workers_per_task(~wrong_idx),'bo')

figure(8)
plot(prob_t_given_A_p(wrong_idx),num_workers_per_task(wrong_idx),'ro')
hold on
plot(prob_t_given_A_p(~wrong_idx),num_workers_per_task(~wrong_idx),'bo')
hold off

high_entropy_mask = prob_t_given_A_p>0.001 &  prob_t_given_A_p < 0.999;
low_edges_mask = num_workers_per_task < mean(num_workers_per_task);
wrong_with_high_entropy = wrong_idx & high_entropy_mask;
wrong_with_high_entropy_low_edges = wrong_with_high_entropy & low_edges_mask;
wrong_with_low_edges = low_edges_mask & wrong_idx;
sum(high_entropy_mask)
sum(wrong_with_high_entropy)
sum(wrong_with_high_entropy_low_edges)
sum(wrong_with_low_edges)
sum(wrong_idx)

