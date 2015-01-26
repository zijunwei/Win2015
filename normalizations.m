classdef normalizations
    properties(Constant)
        slots=[1,7680,24576,27648,49152];
    end;
    
    methods(Static)
        
        
        function outD=power2(outD)
            
            fv_sub=cell(4,1);
            for i=1:1:length(normalizations.  slots)-1
                start_idx=sum( normalizations. slots(1:i));
                end_idx=sum(normalizations. slots(1:i+1))-1;
                fv_sub{i}=outD(start_idx:end_idx,:);
                fv_sub{i}=Zj_Normalization.power2(fv_sub{i});
            end
            
            outD=[fv_sub{1};fv_sub{2};fv_sub{3};fv_sub{4}];
        end
        
        
    end
    
    
    
end