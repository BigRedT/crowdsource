num_data = 11;
error_wo_cell = cell(1,num_data);
error_w_cell = cell(1,num_data);
error_r_wo_cell = cell(1,num_data);
error_r_w_cell = cell(1,num_data);
num_edges_cell = cell(1,num_data);

for i=1:num_data
    load([num2str(i) '_error.mat']);
    load([num2str(i) '_error_r.mat']);
    load([num2str(i) '_num_edges.mat']);
    
    error_wo_cell{i} = error_wo(:,1);
    error_w_cell{i} = error_w(:,1);
    
    error_r_wo_cell{i} = error_r_wo(:,1);
    error_r_w_cell{i} = error_r_w(:,1);
    
end

error_wo = cell2mat(error_wo_cell);
error_w = cell2mat(error_w_cell);
error_r_wo = cell2mat(error_r_wo_cell);
error_r_w = cell2mat(error_r_w_cell);

num_edges = [2000:280:30000];


%% Average
% load error_wo_corrected.mat
error_wo_med = median(error_wo,2);
% error_wo_corrected_med = median(error_wo_corrected,2);
error_w_med = median(error_w,2);
error_r_wo_med = median(error_r_wo,2);
error_r_w_med = median(error_r_w,2);

error_wo_avg = mean(error_wo,2);
% error_wo_corrected_avg = mean(error_wo_corrected,2);
error_w_avg = mean(error_w,2);
error_r_wo_avg = mean(error_r_wo,2);
error_r_w_avg = mean(error_r_w,2);

figure(1),
semilogy(num_edges,error_wo_avg,'r-');
hold on;
semilogy(num_edges,error_w_avg,'g-');
semilogy(num_edges,error_r_wo_avg,'b-');
semilogy(num_edges,error_r_w_avg,'k-');
hold off;
xlabel('number of edges');
ylabel('mean percent error');
legend({'edge adapt without prior','edge adapt with prior','random without prior','random with prior'});

figure(2),
semilogy(num_edges,error_wo_med,'r-');
hold on;
semilogy(num_edges,error_w_med,'g-');
semilogy(num_edges,error_r_wo_med,'b-');
semilogy(num_edges,error_r_w_med,'k-');
hold off;
xlabel('number of edges');
ylabel('median percent error');
legend({'edge adapt without prior','edge adapt with prior','random without prior','random with prior'});

% figure(3),
% semilogy(num_edges,error_wo_corrected_avg,'r-');
% hold on;
% semilogy(num_edges,error_w_avg,'g-');
% semilogy(num_edges,error_r_wo_avg,'b-');
% semilogy(num_edges,error_r_w_avg,'k-');
% hold off;
% xlabel('number of edges');
% ylabel('mean percent error');
% legend({'edge adapt without prior','edge adapt with prior','random without prior','random with prior'});
