# Dice


# 运行

在 Godot 编辑器的右上角可以找到运行按钮：

![](https://github.com/LunarDrive/Images/blob/master/Pasted%20image%2020250721110658.png?raw=true)

这几个按钮分别是: 
1. **运行主场景** `F5`
2. 暂停游戏 `F7`
3. 停止游戏 `F8`
4. **在特定平台上运行游戏** `shift F5` （安卓按钮需要电脑连接到设备才会显示）
5. **运行当前场景** `F6`
6. 选择场景运行 `Ctrl + Shift + F5`
7. 电影模式（可以无视）

实际我们主要会用到的就是前五个。


# 导出

点击菜单栏的 Project > Export ：

![](https://raw.githubusercontent.com/LunarDrive/Images/refs/heads/master/Screenshot%20-%202025-07-21%2011.23.45.png)

第一次导出时需要安装导出模板，点击 Manage Export Templates

![](https://docs.godotengine.org/zh-cn/4.x/_images/export_error.png)

可以从 [官网地址](https://godotengine.org/download/windows/#:~:text=arm64%20%C2%B7%20C%23%20support-,Export%20templates,-Used%20to%20export) 下载导出模板，并点击 Install From File 导入：

![](https://github.com/LunarDrive/Images/blob/master/Screenshot%20-%202025-07-21%2011.55.52.png?raw=true)

然后再次选择对应平台点击 Export Project 即可

![](https://github.com/LunarDrive/Images/blob/master/Screenshot%20-%202025-07-21%2011.37.48.png?raw=true)

详细请参考 Godot 文档：[导出项目](https://docs.godotengine.org/zh-cn/4.x/tutorials/export/exporting_projects.html)
