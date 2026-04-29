% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % 单次spm预处理 + 静息态dpabi FC计算 + 与FC模板（FCtemplate）的表征相似性分析 + 指标保存的实时监测、循环计算逻辑
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
function run_batchloop(x,batch_name,timepoint,tr,start,sj,Txt,work_lj,fc,aal)
    % 重要参数填写！
    num=timepoint;
    start_lj=start;
    sjwz=sj;
    txt=Txt;

    load('FCtemplate.mat','ROICorrelation');     %预设的fc模板数据
    
    work_lj=[work_lj '\temp_results' num2str(x)];
    load(fc,'Cfg');
    Cfg.WorkingDir=work_lj;    
    Cfg.DataProcessDir=work_lj;                                    %dpabi工作路径
    Cfg.StartingDirName='shuju';                                   %可统一为"shuju"
    Cfg.SubjectID={'s1';};                                         %可统一为"s1"
    Cfg.TimePoints=num;                                              %要同spm一致
    Cfg.TR=tr;                                                      %要同spm一致
    Cfg.CalFC.ROIDef={aal};%脑图谱模板位置

    %实时检测当前.dcm文件数量，等待n个TR数据生成
    while true
        wjlist=dir([sjwz '\?*']);       % \?* \*.dcm
        if size(wjlist,1)>num
            break;
        end
    end
    pause(5*(x-1));                    %实现并行且间隔5s！
    
    t=0;data=[];
    while true
        t=t+1;
        disp(['并行 ' num2str(x) ' 第 ' num2str(t) ' 次开始！  ' char(datetime)]);   

        %% 获取最近n个TR的数据并填入脚本中
        wjlist=dir([sjwz '\?*']);                                          %再次检索当前.dcm文件数量
        process_wj={};
        for i=[size(wjlist,1)-num+1]:size(wjlist,1)
            process_wj=[process_wj;fullfile(wjlist(i).folder,wjlist(i).name)]; %获取最近10个TR的数据
        end        
        batch_name{x}{1}.cfg_basicio.file_dir.dir_ops.cfg_cd.dir = {work_lj};
        batch_name{x}{2}.spm.util.import.dicom.data = process_wj;          %欲处理的数据填入脚本中
        batch_name{x}{7}.spm.stats.factorial_design.dir = {work_lj};
        % 清空临时结果文件夹（工作文件夹）
        cd(start_lj);    
        if isfolder(work_lj)
            rmdir(work_lj,"s");   %如果存在，先删除，避免干扰
        end
        mkdir(work_lj);           %提前生成工作文件夹！       
        %% 运行语句
        spm_jobman('run', batch_name{x});
        % 转存完成预处理的数据文件，供后续指标计算
        shuju_folder=fullfile(work_lj,'shuju','s1');        
        mkdir(shuju_folder);
        shuju=dir(fullfile(work_lj,'swra*.nii'));        
        for ii=1:size(shuju,1)
            movefile(fullfile(work_lj,shuju(ii).name),fullfile(shuju_folder,shuju(ii).name));
        end
        % 使用dpabi进行fc计算！
        cd(start_lj);
        mDPARSFA_run(Cfg,[],[],0);
        %% 传递fc相关性
        fc_path=fullfile(work_lj,'Results\ROISignals_shuju','ROICorrelation_s1.mat');
        txt_path = txt;
        value = corr2(load(fc_path).ROICorrelation,ROICorrelation);
        for iii = 1:3
            try         %若失败，仅跳出try循环!
                fid = fopen(txt_path, 'w');
                fprintf(fid, '%f', value); % 写入数值，可根据需要调整格式
                fclose(fid);       
                disp(value);
                break;  %若成功，则直接跳出上一级的for循环！
            end
        end

        disp(['并行 ' num2str(x) ' 已完成 ' num2str(t) ' 次！  ' char(datetime)]);   %考虑嵌入其他软件包的结果呈现！没用，并行循环只支持处理数据，不支持call figure！！！！
    end
end
