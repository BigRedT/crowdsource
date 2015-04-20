function [A,t,p] = createGraph(num_workers,num_tasks,varargin)
p = inputParser;
defaultMethod = 'random';
expectedPrior = {'random','project','lRegular','lrRegular'};
addOptional(p,'method',defaultMethod,@(x)(any(validatestring(x,expectedPrior))));
parse(p,varargin{:});
args = p.Results;
rng(10);
alpha = 6;
beta = 2;
if(strcmp(args.method,'random'))
    A = double(rand(num_tasks,num_workers)<0.5);
    idx = find(A);
    num_edges = numel(idx);
    responses = rand(num_edges,1)>0.5;
    responses = 2*responses-1;
    A(idx) = responses;
end

if(strcmp(args.method,'project'))
    A = double(rand(num_tasks,num_workers)<0.0075);
    idx = find(A);
    num_edges = numel(idx);
    t = double(rand(num_tasks,1)<0.75);
    t = 2*t-1;
    p = 0.1+0.9*betarnd(alpha,beta,num_workers,1);
    for j=1:num_workers
        task_mask = A(:,j)==1;
        num_tasks_by_worker_j = sum(task_mask);
        responses = rand(num_tasks_by_worker_j,1) < p(j);
        responses = 2*responses-1;
        A(task_mask,j) = responses.*t(task_mask);
    end
end

