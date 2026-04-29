本项目依赖MATLAB的[SPM](https://www.fil.ion.ucl.ac.uk/spm/docs/installation)、[DPABI](http://rfmri.net/dpabi)工具包，命令行运行fmriNF即可进入GUI界面。

演示功能为提取最近 n TR的数据，计算全脑（aal模板）功能连接，并同目标功能连接模式（FCtemplate.mat）计算表征相似性指标，暂存于value.txt中，被e-prime程序（EEG-NF.es2）实时读取且可视化。

test.bat用于模拟逐TR接收dcm数据（从example dcm中每2s转移一个dcm文件进数据文件夹test\dcm中）。
