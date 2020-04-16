vimrc
====
自用的vimrc配置
====

依赖
----
智能补全: [YouCompleteMe](https://github.com/ycm-core/YouCompleteMe) \
模糊搜索: [ripgrep](https://github.com/BurntSushi/ripgrep) \
插件管理: [vim-plug](https://github.com/junegunn/vim-plug) \
请确保您已安装好python3和golang等基础环境

安装(仅面向纯新手)
----
在用户目录下新建 .vimrc 文件 \
复制粘贴入此repo中的 [vimrc文件](https://github.com/pokemonchw/vimrc/blob/master/vimrc) 中的内容 \
保存后,重新打开vim \
在 Normal 模式下按F7 \
等待自动安装插件依赖

说明
----
cd到你的任意项目目录下并打开当vim,它看上去就像这样: \
![Main](https://raw.github.com/pokemonchw/vimrc/master/image/1.png "Main")
(看上去比记事本更简陋) \
别着急,接下来开始介绍使用

基础功能:

1.按F2打开你的项目树: \
![ProjectTree](https://raw.github.com/pokemonchw/vimrc/master/image/2.png "ProjectTree")
支持使用鼠标对其进行操作,同时可以在选中后按下 s键 快速分割窗口打开一个文件
![ProjectTree2](https://raw.github.com/pokemonchw/vimrc/master/image/5.png "ProjectTree2")

2.智能补全: \
![AutoFix](https://raw.github.com/pokemonchw/vimrc/master/image/3.png "AutoFix")
依照个人喜好,会在输入第一个字符的时候就开始对代码进行智能补全提示,目前支持golang和python,感谢于社区的努力,ycm现在能够提示typehints和docstring,并将docstring放进popup中 \
关于docstring: python需放在函数内第一行,golang需放在函数定义前,需注意的是,golang的docstring在注释中需遵守godoc语法规则,否则无法识别换行

3.模糊搜索: \
![FuzzySearch](https://raw.github.com/pokemonchw/vimrc/master/image/4.png "FuzzySearch")
依赖于 [LeaderF](https://github.com/Yggdroot/LeaderF) 插件,可以进行简便强大的快速模糊搜索 \
按下 ctrl+f 底部会进入命令输入栏,按个人喜好, ctrl+f 被设置为了 :Leaderf rg ,在这里,你可以依照leaderf插件中的说明,将rg替换成别的选项,然后输入你想要搜索的内容然后回车,进入leaderf的popup菜单,可以进一步输入内容进行筛选,也可以回车跳转到选项,或是按 ctrl+f 分割窗口打开

4.跳转到声明和定义处: \
将光标移动到一个单词处,按下 ctrl+] 即可跳转,同时支持 ctrl+\ 进行分割屏幕跳转 \
按下 ctrl+t 即可退回
