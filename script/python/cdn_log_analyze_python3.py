# -*- coding:utf-8 -*-
'''
说明:
脚本需要在python3环境下运行
所需环境：
    1.安装python3 brew install python3
    2.安装xlwt,tkinter,pandas,matplotlib模块，用于生成excel表格和图表:pip3 install xlwt;pip3 install tkinter;pip3 install pandas；
    pip3 install matplotlib
操作步骤：
    1.下载cdn日志，在阿里云cdn后台的日志选项中下载
    2.python3 cdn_log_analyze_python3_old.py        运行脚本
    3.在弹出框中选择日志存放文件夹即可
    4.自动生成excel表格
    如果生成的表格为空，重新运行一下脚本即可
'''
# 1.日志解压与汇总
import gzip
import os
import re
import json
import pandas as pd
from pandas import DataFrame


class LogAnalyze(object):

    def __init__(self):
        self.BASE_PATH = ''  # 日志文件夹存放路径
        self.log_download_list = []  # 日志文件名列表
        self.file = 'total_log.txt'  # 日志解压汇总后的文件名
        self.file2 = 'total_log_split.txt'  # 切割后的日志文件名
        self.result_dic = {}  # 结果字典
        self.res = []  # 正则匹配后的结果
        self.total_data = 0  # 初始日志的流量总和
        self.total_bytes = 0  # 结果字典里的流量总和
        self.project_infortmation_file = 'project.json'  # 项目信息文件
        self.txt_file_name = ''  # 解压后的文件夹名
        self.file_time = ''  # 日志产生的日期

    # 1.批量解压日志，将日志写到一个文件中去：total_log.txt
    def jieya_log(self):
        count = 1
        for l in self.log_download_list:
            if l.endswith('gz'):
                file_path = os.path.join(self.BASE_PATH, l)
                g = gzip.GzipFile(mode="rb", fileobj=open(file_path, 'rb'))
                open(self.txt_file_name % count, "wb").write(g.read())
                count += 1

        with open('total_log.txt', 'w') as f:
            for l in self.log_download_list:
                if l.endswith('txt'):
                    file_path = os.path.join(self.BASE_PATH, l)
                    with open(file_path, 'r') as f2:
                        f.write(f2.read())

    # 2.日志分析筛选
    def log_analysis(self):
        if os.path.exists(self.file):
            with open(self.file, 'r') as f, open(self.file2, 'w') as f2:
                for data in f:
                    res1 = data.split(" ")
                    self.total_data += int(res1[10])
                    res2 = res1[0].split(':')
                    res3 = res2[1] + res1[7] + res1[9] + '-' + res1[10]  # 将日志分割写成 '时间 链接 request_size - response_size'
                    f2.write(res3 + '\n')

        with open(self.file2, 'r') as f3:
            data = f3.read()
            # 匹配项目名和流量大小
            self.res = re.findall(
                r'([0-9]+)https://host.eyexpo.com.cn/tours/(.*?)/.+"([0-9]+)-([0-9]+)',
                data)
        with open(self.file2, 'r') as f4, open('not_tours.txt', 'w') as f5:  # not_tours.txt 不是tours下的项目
            for l in f4:
                if 'tours' not in l:
                    f5.write(l)
        with open('not_tours.txt', 'r') as f6:
            data = f6.read()
            self.res.extend(re.findall(
                r'([0-9]+)https://(host.eyexpo.com.cn)/.+"([0-9]+)-([0-9]+)',
                data))

    # 3.统计结果
    # 将结果写入字典
    def statistical_results(self):
        for l in self.res:
            time = l[0] + ':00' + '-' + str(int(l[0]) + 1).zfill(2) + ':00'
            if l[1] not in self.result_dic:
                self.result_dic[l[1]] = {time: round(int(l[3]) / 1024 / 1024, 2)}
            else:
                if time in self.result_dic[l[1]].keys():
                    self.result_dic[l[1]][time] += round(int(l[3]) / 1024 / 1024, 2)
                else:
                    self.result_dic[l[1]][time] = round(int(l[3]) / 1024 / 1024,
                                                        2)  # 结果格式 {'project name':{'时间段1'：流量大小，'时间段2'：流量大小，.....}}

        # 输出统计结果
        for item_project in self.result_dic.keys():
            for item_time in self.result_dic[item_project].keys():
                self.total_bytes += self.result_dic[item_project][item_time]
        print('总流量为:' + str(round(self.total_data / 1024 / 1024, 2)) + 'M')  # 初始流量总和
        # print('总流量为:' + str(self.total_bytes) + 'M')  # 统计结果字典中的流量总和
        # 将结果写入excel
        data = self.result_dic
        frame = DataFrame(data)
        frame = frame.fillna(0)
        frame.to_excel('cdn流量统计{0}.xls'.format(self.file_time), sheet_name='sheet1')

    # 打开excel
    def excel_to_png(self):
        import matplotlib.pyplot as plt
        from matplotlib.font_manager import FontProperties
        # 设置中文编码和符号的正常显示
        data = pd.read_excel('cdn流量统计{0}.xls'.format(self.file_time), index_col='Unnamed: 0')  # 设置第一列为索引

        for project in data.columns:
            font = FontProperties(fname='/System/Library/Fonts/STHeiti Light.ttc', size=16)
            plt.style.use("ggplot")
            # plt.rcParams["axes.unicode_minus"] = False

            # 从excel中获取数据
            # print(df)

            # 绘图
            fig = plt.figure(figsize=(10, 6))
            print(project)
            plt.plot(data.index,  # x轴数据
                     data[project],  # y轴数据
                     linestyle='-',  # 折线类型
                     linewidth=2,  # 折线宽度
                     color='blue',  # 折线颜色
                     marker='o',  # 点的形状
                     markersize=6,  # 点的大小
                     markeredgecolor='brown',  # 点的边框色
                     markerfacecolor='brown'
                     )  # 点的填充色

            # 添加标题和坐标轴标签
            plt.title('{}每日流量使用趋势'.format(project), fontproperties=font)  # 用到中文的地方就加一个字体属性
            plt.xlabel('时间', fontproperties=font)
            plt.ylabel('流量(Mb)', fontproperties=font)

            plt.tick_params(top='off', right='off')  # 剔除图框上边界和右边界的刻度

            fig.autofmt_xdate(rotation=45)  # 为了避免x轴日期刻度标签的重叠，设置x轴刻度自动展现，并且45度倾斜

            # plt.show()            # 显示图形

            # plt.legend()             # 显示图例

            # 保存图片
            plt.savefig('每日流量使用趋势%s.png' % project, bbox_inches='tight')  # dpi 分辨率 dpi每英寸点数和bbox_inches可以剪出当前图表周围的空白部分。
            plt.close()


if __name__ == '__main__':
    log1 = LogAnalyze()
    from tkinter import *
    import tkinter.filedialog

    root = Tk()
    root.withdraw()  # ****实现主窗口隐藏

    log_path = tkinter.filedialog.askdirectory()  # 获取打开的目录

    log1.BASE_PATH = log_path
    log1.log_download_list = os.listdir(log_path)
    log1.txt_file_name = "%s/cdn%%s.txt" % log_path
    temp_file_name = log1.log_download_list[0]
    file_obj = temp_file_name.split('_')
    log1.file_time = file_obj[2] + file_obj[3]
    import os

    if os.path.exists(log1.file_time):
        os.chdir(log1.file_time)
    else:
        os.mkdir(log1.file_time)
        os.chdir(log1.file_time)

    log1.jieya_log()
    log1.log_analysis()
    log1.statistical_results()
    log1.excel_to_png()
    print("\033[1;32mSuccess!\n结果已经记录到《cdn流量统计%s.xls》文件中\033[0m" % log1.file_time)
