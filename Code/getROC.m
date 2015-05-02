function [precision,recall] = getROC(ps,Y,T,num_tasks)
recall = zeros(1000,1);
precision = zeros(1000,1);
K = zeros(1000,1);
[~,sort_idx] = sort(ps(:,1),'descend');
for i=1:1000
    K(i) = round(i*0.001*T*num_tasks);
    num_catches = double(K(i) - sum(Y(sort_idx(1:K(i)))));
    %num_errors = double(T*num_tasks - sum(Y));
    num_errors = sum(Y==0);
    recall(i) = num_catches/num_errors;
    precision(i) = num_catches/K(i);
end
% figure(35);
% subplot(1,2,1), plot(recall,precision,'r-');
% xlabel('Recall');
% ylabel('Precision');
% axis([0 1 0 1])
% subplot(1,2,2), plot(K,precision,'b-');
% xlabel('Number of ranked tasks observed');
% ylabel('Precision');
% axis([1 T*num_tasks 0 1])
