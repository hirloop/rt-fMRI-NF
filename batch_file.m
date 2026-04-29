% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % %预处理SPM配置文件生成
% % % % % % % % % % % % % % % % % % % % % % % % % 
function [batch_file]=batch_file(n,tp,sn,tr,order,ref)
    for ii=1:n
        % 重要参数填写！
        tpm=tp;                             %normailise时的spm模板，随spm安装位置变化
        slice_number=sn;
        TR=tr;
        TA=TR-TR/slice_number;           
        slice_order=order;
        ref_slice=ref;                      %参考slice
        mask_rthresh=0.8;                   %体素纳入进mask的阈值，百分比
        con_name=['yyds' num2str(ii)];      %contrast名字，不能起中文


        matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_cd.dir = {}; %先保持为空！
        matlabbatch{2}.spm.util.import.dicom.data = {};              %先保持为空！
        
        matlabbatch{2}.spm.util.import.dicom.root = 'flat';
        matlabbatch{2}.spm.util.import.dicom.outdir = {''};
        matlabbatch{2}.spm.util.import.dicom.protfilter = '.*';
        matlabbatch{2}.spm.util.import.dicom.convopts.format = 'nii';
        matlabbatch{2}.spm.util.import.dicom.convopts.meta = 0;
        matlabbatch{2}.spm.util.import.dicom.convopts.icedims = 0;
        
        matlabbatch{3}.spm.temporal.st.scans{1}(1) = cfg_dep('DICOM Import: Converted Images', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
        matlabbatch{3}.spm.temporal.st.nslices = slice_number;     %关键参数，记得修改
        matlabbatch{3}.spm.temporal.st.tr = TR;                    %关键参数，记得修改
        matlabbatch{3}.spm.temporal.st.ta = TA;                    %关键参数，记得修改
        matlabbatch{3}.spm.temporal.st.so = slice_order;           %关键参数，记得修改
        matlabbatch{3}.spm.temporal.st.refslice = ref_slice;       %关键参数，记得修改
        matlabbatch{3}.spm.temporal.st.prefix = 'a';
        
        matlabbatch{4}.spm.spatial.realign.estwrite.data{1}(1) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 1)', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
        matlabbatch{4}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
        matlabbatch{4}.spm.spatial.realign.estwrite.eoptions.sep = 4;
        matlabbatch{4}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
        matlabbatch{4}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
        matlabbatch{4}.spm.spatial.realign.estwrite.eoptions.interp = 2;
        matlabbatch{4}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
        matlabbatch{4}.spm.spatial.realign.estwrite.eoptions.weight = '';
        matlabbatch{4}.spm.spatial.realign.estwrite.roptions.which = [2 1];
        matlabbatch{4}.spm.spatial.realign.estwrite.roptions.interp = 4;
        matlabbatch{4}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
        matlabbatch{4}.spm.spatial.realign.estwrite.roptions.mask = 1;
        matlabbatch{4}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
        
        matlabbatch{5}.spm.tools.oldnorm.estwrite.subj.source(1) = cfg_dep('Realign: Estimate & Reslice: Mean Image', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rmean'));
        matlabbatch{5}.spm.tools.oldnorm.estwrite.subj.wtsrc = '';
        matlabbatch{5}.spm.tools.oldnorm.estwrite.subj.resample(1) = cfg_dep('Realign: Estimate & Reslice: Resliced Images (Sess 1)', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{1}, '.','rfiles'));
        matlabbatch{5}.spm.tools.oldnorm.estwrite.eoptions.template = {tpm};
        matlabbatch{5}.spm.tools.oldnorm.estwrite.eoptions.weight = '';
        matlabbatch{5}.spm.tools.oldnorm.estwrite.eoptions.smosrc = 8;
        matlabbatch{5}.spm.tools.oldnorm.estwrite.eoptions.smoref = 0;
        matlabbatch{5}.spm.tools.oldnorm.estwrite.eoptions.regtype = 'mni';
        matlabbatch{5}.spm.tools.oldnorm.estwrite.eoptions.cutoff = 25;
        matlabbatch{5}.spm.tools.oldnorm.estwrite.eoptions.nits = 16;
        matlabbatch{5}.spm.tools.oldnorm.estwrite.eoptions.reg = 1;
        matlabbatch{5}.spm.tools.oldnorm.estwrite.roptions.preserve = 0;
        matlabbatch{5}.spm.tools.oldnorm.estwrite.roptions.bb = [-78 -112 -70
                                                                 78 76 85];
        matlabbatch{5}.spm.tools.oldnorm.estwrite.roptions.vox = [2 2 2];
        matlabbatch{5}.spm.tools.oldnorm.estwrite.roptions.interp = 1;
        matlabbatch{5}.spm.tools.oldnorm.estwrite.roptions.wrap = [0 0 0];
        matlabbatch{5}.spm.tools.oldnorm.estwrite.roptions.prefix = 'w';
        
        matlabbatch{6}.spm.spatial.smooth.data(1) = cfg_dep('Old Normalise: Estimate & Write: Normalised Images (Subj 1)', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
        matlabbatch{6}.spm.spatial.smooth.fwhm = [8 8 8];
        matlabbatch{6}.spm.spatial.smooth.dtype = 0;
        matlabbatch{6}.spm.spatial.smooth.im = 0;
        matlabbatch{6}.spm.spatial.smooth.prefix = 's';
        
        matlabbatch{7}.spm.stats.factorial_design.dir = {};
        matlabbatch{7}.spm.stats.factorial_design.des.t1.scans(1) = cfg_dep('Smooth: Smoothed Images', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
        matlabbatch{7}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
        matlabbatch{7}.spm.stats.factorial_design.multi_cov.files(1) = cfg_dep('Realign: Estimate & Reslice: Realignment Param File (Sess 1)', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{1}, '.','rpfile'));
        matlabbatch{7}.spm.stats.factorial_design.multi_cov.iCFI = 1;
        matlabbatch{7}.spm.stats.factorial_design.multi_cov.iCC = 1;
%         matlabbatch{8}.spm.stats.factorial_design.masking.tm.tma.athresh = 100;
        matlabbatch{7}.spm.stats.factorial_design.masking.tm.tmr.rthresh = mask_rthresh;
        matlabbatch{7}.spm.stats.factorial_design.masking.im = 1;
        matlabbatch{7}.spm.stats.factorial_design.masking.em = {''};
        matlabbatch{7}.spm.stats.factorial_design.globalc.g_omit = 1;
        matlabbatch{7}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
        matlabbatch{7}.spm.stats.factorial_design.globalm.glonorm = 1;
        
        matlabbatch{8}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
        matlabbatch{8}.spm.stats.fmri_est.write_residuals = 0;
        matlabbatch{8}.spm.stats.fmri_est.method.Classical = 1;
        
        matlabbatch{9}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{8}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
        matlabbatch{9}.spm.stats.con.consess{1}.tcon.name = con_name;   %不能起中文！！！
        matlabbatch{9}.spm.stats.con.consess{1}.tcon.weights = 1;
        matlabbatch{9}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
        matlabbatch{9}.spm.stats.con.delete = 0;
        % 放入batch_list中
        batch_file{ii}=matlabbatch;
    end
end
