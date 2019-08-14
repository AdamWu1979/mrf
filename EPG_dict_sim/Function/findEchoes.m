function echoes = findEchoes(seq,om_store)
%echoes = FINDECHOES(seq,om_store)
% Finds echo timings and intensities given sequence seq and 
% om_store (the later being generated by EPG_custom.m)
% 
% We only find the proper and unique echoes
% Criteria: 
% (a) The F(0) component must be non-zero (>5*eps)
% (b) If there are multiple echoes satisfying (a) at the same timing,
%     use the last value. So for grad->relax->RF, we only get F(0) after
%     the RF, and for grad->relax, we only get F(0) after the relaxation.
% 
% output: echoes is N x 2 matrix where N is the number of echoes found
%         1st col - timing; 2nd col - intensity (modulus of F(0)) 

echoes = [];
timing = seq.time;
for v = 1:length(om_store)
    if abs(om_store{v}(1,1)) > 5*eps %&& sum(rftimes == timing(v))==0 
        newecho = [timing(v),abs(om_store{v}(1,1))];
        if ~isempty(echoes) && echoes(end,1) == timing(v)
            % same timing - always take the 2nd one
            echoes = [echoes(1:end-1,:);newecho];
        else 
            echoes = [echoes;newecho];
        end
        
    end
end
echoes = unique(echoes,'rows');
end
