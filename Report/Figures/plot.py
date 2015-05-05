import mpl_helper
import numpy as np

def plot_perc_err():
   (figure, axes) = mpl_helper.make_fig(figure_width=(12 / 2.54), left_margin=0.7, bottom_margin=0.42, right_margin=0.2, top_margin=0.2)
   num_edges = np.genfromtxt('./data2/Mean_perc_err_100_workers_num_edges.txt')
   err_w_r = np.genfromtxt('./data2/Mean_perc_err_100_workers_perc_err_w_r.txt')
   err_wo_r = np.genfromtxt('./data2/Mean_perc_err_100_workers_perc_err_wo_r.txt')
   err_w = np.genfromtxt('./data2/Mean_perc_err_100_workers_perc_err_w.txt')
   err_wo = np.genfromtxt('./data2/Mean_perc_err_100_workers_perc_err_wo.txt')

   axes.plot(num_edges, err_w_r, 'k-', label='random with prior')
   axes.plot(num_edges, err_wo_r, 'b-', label='random without prior')
   axes.plot(num_edges, err_w, 'r-', label='adaptive with prior')
   axes.plot(num_edges, err_wo, 'g-', label='adaptive without prior')

   axes.set_yscale('log')
   axes.set_xlabel('number of edges')
   axes.set_ylabel('assignment error + std dev (percent)')
   axes.grid(b=1, which='major', linestyle='-')
   axes.grid(b=1, which='minor', linestyle=':')
   axes.legend(loc=0)
   return(figure,axes)

(figure,axes) = plot_perc_err()
filename = "py_mean_perc_err_100_workers.pdf"
figure.savefig(filename)

def plot_perc_err_30():
   (figure, axes) = mpl_helper.make_fig(figure_width=(12 / 2.54), left_margin=0.7, bottom_margin=0.42, right_margin=0.2, top_margin=0.2)
   num_edges = np.genfromtxt('./data2/Mean_perc_err_30_workers_num_edges.txt')
   err_w_r = np.genfromtxt('./data2/Mean_perc_err_30_workers_perc_err_w_r.txt')
   err_wo_r = np.genfromtxt('./data2/Mean_perc_err_30_workers_perc_err_wo_r.txt')
   err_w = np.genfromtxt('./data2/Mean_perc_err_30_workers_perc_err_w.txt')
   err_wo = np.genfromtxt('./data2/Mean_perc_err_30_workers_perc_err_wo.txt')

   axes.plot(num_edges, err_w_r, 'k-', label='random with prior')
   axes.plot(num_edges, err_wo_r, 'b-', label='random without prior')
   axes.plot(num_edges, err_w, 'r-', label='adaptive with prior')
   axes.plot(num_edges, err_wo, 'g-', label='adaptive without prior')

   axes.set_yscale('log')
   axes.set_xlabel('number of edges')
   axes.set_ylabel('assignment error + std dev (percent)')
   axes.grid(b=1, which='major', linestyle='-')
   axes.grid(b=1, which='minor', linestyle=':')
   axes.legend(loc=0)
   return(figure,axes)

(figure,axes) = plot_perc_err_30()
filename = "py_mean_perc_err_30_workers.pdf"
figure.savefig(filename)



