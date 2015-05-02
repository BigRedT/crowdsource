function [prob_t_given_A_p_new,worker_abilities_new] = EM(A,prob_t_given_A_p_init,varargin)
p = inputParser;
defaultPrior = 'noPrior';
expectedPrior = {'noPrior','betaPrior'};
addOptional(p,'prior',defaultPrior,@(x)(any(validatestring(x,expectedPrior))));
addOptional(p,'iterMax',10,@isnumeric);
parse(p,varargin{:});
args = p.Results;

alpha = 6;
beta = 2;

num_tasks = size(A,1);
num_workers = size(A,2);

prob_t_given_A_p_old = prob_t_given_A_p_init;
prob_t_given_A_p_new = prob_t_given_A_p_old;
worker_abilities_old = Inf*ones(num_workers,1);


for t=1:args.iterMax
    %% M-Step withour prior
    if(strcmp(args.prior,'noPrior'))
        worker_abilities_new = zeros(num_workers,1);
        for j=1:num_workers
            task_mask = abs(A(:,j))==1;
            num_tasks_by_worker_j = sum(task_mask);
            if(num_tasks_by_worker_j>0)
                worker_abilities_new(j) = sum(((2*prob_t_given_A_p_old(task_mask)-1)/2).*A(task_mask,j) + 0.5)/num_tasks_by_worker_j;
            else
                worker_abilities_new(j) = -1;
            end
        end
    end
    
    %% M-Step with prior
    if(strcmp(args.prior,'betaPrior'))
        lambda = zeros(num_workers,1);
        worker_abilities_new = zeros(num_workers,1);
        r = zeros(num_workers,2);
        for j=1:num_workers
            task_mask = abs(A(:,j))==1;
            num_tasks_by_worker_j = sum(task_mask);
            if(num_tasks_by_worker_j>0)
                lambda(j) = sum(((2*prob_t_given_A_p_old(task_mask)-1)/2).*A(task_mask,j) + 0.5)/num_tasks_by_worker_j;
                %% Solve quadratic
                a = -(num_tasks_by_worker_j + alpha + beta - 2);
                b = num_tasks_by_worker_j*(lambda(j) + 0.1) + alpha + 0.1*beta - 1.1;
                c = 0.1*num_tasks_by_worker_j*lambda(j);
                r(j,:) = roots([a,b,c])';
                worker_abilities_new(j) = max(abs(r(j,:)));
            else
                worker_abilities_new(j) = -1;
                r(j,:) = [-2, -2];
            end
        end
        worker_abilities_new = rescale_prob(worker_abilities_new,'method','smart_rescale','lb',0.1,'ub',0.99);
    end
    
    
    %% E-Step
    for i = 1:num_tasks
        worker_masks = abs(A(i,:))==1;
        a_i = (3/4)*prod(((2*worker_abilities_new(worker_masks)-1)/2)'.*A(i,worker_masks) + 0.5);
        b_i = (1/4)*prod(((1-2*worker_abilities_new(worker_masks))/2)'.*A(i,worker_masks) + 0.5);
        if(sum(worker_masks)>0)
            prob_t_given_A_p_new(i) = a_i/(a_i+b_i);
        else
            prob_t_given_A_p_new(i) = -1;
        end
    end
    
    
    delta_task_prob = norm(prob_t_given_A_p_new-prob_t_given_A_p_old,Inf);
    delta_worker_prob = norm(worker_abilities_new-worker_abilities_old,Inf);
%     disp(['Iteration:' num2str(t) ' delta_task_prob:' num2str(delta_task_prob) ' delta_worker_prob:' num2str(delta_worker_prob)]);
    prob_t_given_A_p_old = prob_t_given_A_p_new;
    worker_abilities_old = worker_abilities_new;
end



