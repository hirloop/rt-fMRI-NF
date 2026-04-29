% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % n发并行循环逻辑；整体封装，适用于参数传递app构建中！
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
function  main_NF(n,tp,sn,tr,order,ref,timepoint,start,sj,Txt,work_lj,fc,aal)
   

%     delete(gcp('nocreate'));  % 若未关闭，则先关闭                          
%     parpool(n);

    AAA=batch_file(n,tp,sn,tr,order,ref);                %创建batch
    
    % 使用 parfor 循环并行运行脚本
    parfor i = 1:n         
        run_batchloop(i,AAA,timepoint,tr,start,sj,Txt,work_lj,fc,aal);
    end

end
