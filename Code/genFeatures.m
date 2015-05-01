function feature = genFeatures(prob_t,worker_abil,graph)
degree = sum(graph,2);

abilityHist = histWorkerAbilities(worker_abil,graph);

idx_neg = prob_t==-1;
entropy_t = -prob_t.*log2(prob_t) - (1-prob_t).*log2(1-prob_t);
nanidx = isnan(entropy_t);
entropy_t(nanidx) = 0;
entropy_t(idx_neg) = 1;

feature = [entropy_t degree abilityHist];