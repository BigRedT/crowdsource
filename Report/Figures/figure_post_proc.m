clear all;

figure(1)=openfig('Mean_perc_err_100_workers.fig','reuse');
set(gca, 'FontSize', 12);
set(gcf, 'PaperSize', [7 5]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [0 0 7 5]);
grid on
set(gca,'GridLineStyle','-')
hline = findobj(gcf, 'type', 'line');
set(hline,'LineWidth',1.1);
x = get(get(gca,'Children'),'XData');
y = get(get(gca,'Children'),'YData');
num_edges = x{1}';
perc_err_w_r=y{1}';
perc_err_wo_r=y{2}';
perc_err_w=y{3}';
perc_err_wo=y{4}';
save('./data/Mean_perc_err_100_workers_num_edges.txt','num_edges','-ascii','-double')
save('./data/Mean_perc_err_100_workers_perc_err_w_r.txt','perc_err_w_r','-ascii','-double')
save('./data/Mean_perc_err_100_workers_perc_err_wo_r.txt','perc_err_wo_r','-ascii','-double')
save('./data/Mean_perc_err_100_workers_perc_err_w.txt','perc_err_w','-ascii','-double')
save('./data/Mean_perc_err_100_workers_perc_err_wo.txt','perc_err_wo','-ascii','-double')
%set(gca,'LineWidth',2)
% fontname = 'Helvetica';
% set(0,'defaultaxesfontname',fontname);
% set(0,'defaulttextfontname',fontname);

