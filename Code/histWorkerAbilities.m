function abilityHist = histWorkerAbilities(worker_abilities,A)
[num_tasks, ~] = size(A);
abilityHist = zeros(num_tasks,21);
for i=1:num_tasks
    nbrIdx = A(i,:)~=0;
    abilityHist(i,:) = histc(worker_abilities(nbrIdx),[0:0.05:1]);
    if(sum(abilityHist(i,:))>0)
        abilityHist(i,:) = abilityHist(i,:);%/sum(abilityHist(i,:));
    end
end
end

