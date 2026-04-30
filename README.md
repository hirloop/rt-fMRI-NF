本项目依赖MATLAB的[SPM](https://www.fil.ion.ucl.ac.uk/spm/docs/installation)、[DPABI](http://rfmri.net/dpabi)工具包，命令行运行fmriNF即可进入GUI界面。
<img width="731" height="615" alt="4aa34b11-8381-4e4c-958c-61a6a90961f1" src="https://github.com/user-attachments/assets/4dd81432-2054-4be7-9d65-07a943496b89" />

演示功能为提取最近 n TR的数据，计算全脑（aal模板）功能连接，并同目标功能连接模式（FCtemplate.mat）计算表征相似性指标，暂存于value.txt中，被e-prime程序（rt-fMRI.es3）实时读取且可视化。
<img width="1341" height="936" alt="dc325e5c-8cd0-4001-891d-022cc44f90d2" src="https://github.com/user-attachments/assets/40d099f2-158c-485b-9f54-67f367207642" />

test.bat用于模拟逐TR接收dcm数据（从example dcm中每2s转移一个dcm文件进数据文件夹test\dcm中）。


