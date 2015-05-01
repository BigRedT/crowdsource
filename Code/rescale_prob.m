function prob = rescale_prob(prob,varargin)
p = inputParser;
expectedMethod = {'trunc','rescale','smart_rescale'};
addOptional(p,'method','trunc',@(x)(any(validatestring(x,expectedMethod))));
addOptional(p,'lb',0,@isnumeric);
addOptional(p,'ub',1,@isnumeric);
parse(p,varargin{:});
args = p.Results;

mask = prob~=-1;
maxProb = max(prob(mask));
minProb = min(prob(mask));
    
if(strcmp(args.method,'rescale'))
    prob(mask) = (args.ub-args.lb)*(prob(mask) - minProb)/(maxProb-minProb) + args.lb;
elseif(strcmp(args.method,'trunc'))
    mask_to_trunc_pos = mask & prob>=args.ub;
    prob(mask_to_trunc_pos) = args.ub;
    mask_to_trunc_pos = mask & prob<=args.lb;
    prob(mask_to_trunc_pos) = args.lb;
elseif(strcmp(args.method,'smart_rescale'))
    if(max(prob)>args.ub)
        mask_pos = mask & prob>args.ub;
        prob(mask_pos) = (args.ub-0.5)*(prob(mask_pos) - 0.5)/(maxProb-0.5) + 0.5;
    end
    if(min(prob(mask))<args.lb)
        mask_neg = mask & prob<args.ub;
        prob(mask_neg) = -(0.5-args.lb)*(0.5-prob(mask_neg))/(0.5-minProb) + 0.5;
    end
end
