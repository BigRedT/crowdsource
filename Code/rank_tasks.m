function idx = rank_tasks(ps,prob_t)

empty_tasks = find(prob_t==-1);
non_empty_tasks = find(prob_t~=-1);
[~,sorted_non_empty_idx] = sort(ps(non_empty_tasks,1),'descend');

idx = [empty_tasks; non_empty_tasks(sorted_non_empty_idx)];
