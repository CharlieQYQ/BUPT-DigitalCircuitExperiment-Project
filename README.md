# BUPT-DigitalCircuitExperiment-Project
北邮信通院19届数电实验课程大作业
北邮数电实验课程大作业，请勿直接复制粘贴
## 题目：电子琴
Experiment后缀0→3是代码更新版本，最终版本是Experiment3

有附带testbench文件，可以进行仿真
## 实现功能
 - LED点阵点亮，并随音节变化
 - LED点阵三种颜色对应高中低音节（详见要求文档）
 - 四个开关对应切换高中低音和自动演奏
   - 四个开关只能有一个开关打开时工作，复数打开不工作
 - 七个按钮对应音阶的1-7
 - 蜂鸣器在按下按钮时发出对应音高的声音
 - 自动演奏设定的歌曲（《小星星》前四小节）
 - **其他可能还有但我忘了→总之是完成了所有基本任务的要求**
## 注意事项（？）
 - 代码模块化设计，各个模块开头都有注释
 - 如需要在自动演奏时变调，仿照Key_State的思路即可
