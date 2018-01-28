# git 上手流程

**适用于小组协作**

* 前期准备：

  1. git 软件下载，安装
  2. 下载安装 Typora 用于 md 文档的查看和编写
  3. 注册 Github 账号
  4. 申请加入小组

* GIt 上手步骤：

  1. 克隆版本库到本机

     在磁盘内选择一个空文件夹，右击鼠标，选择 `git Bash here` 在此处打开命令行窗口：

     ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180128/j10d2Id09K.png)

     输入以下指令克隆 git 版本库：

     ```
      git clone https://github.com/SUMStudio/WinterVacation.git
     ```

     视网络情况，用时可能稍久，克隆结束之后如下：

     ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180128/mjhfigIhif.png)

  2. 接下来，创建自己的分支

     **master 为公共分支，切勿在此分支上直接修改，务必创建自有分支**

     双击打开 WinterVacation 右键，选择 `git Bash here` 在此处打开命令行窗口：

     可以看到master是我们目前的分支

     ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180128/JIHJmA1lFG.png)

     我们建立自己的分支：

     ```
     git checkout -b 新分支的名称
     ```

     ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180128/4JFiK5Ge61.png)

     接下来，就可以在这个目录下进行文件修改，写日报，写笔记了

  3. 本地库推送

     自己对版本库修改之后，如何同步到云端呢？

     例如，我们在资源文件夹下面 新增加了 test.txt 文件

     ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180128/1a7GhabjF0.png)

     我们在工程的根目录下面 打开 git 命令行

     我们先把文件保存到暂存区，然后本地commit：

     ```
     git add .
     git commit -m "简短描述一下你做了什么"
     ```

     **注意，若第一次执行 git commit，可能需要设置自己的姓名和邮箱，按照提示设置即可**

     ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180128/KAh1Dbl8cG.png)

     然后，我们提交到github：

     他会提示这个：

     ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180128/3i361jg6Im.png)

     按他说的，我们需要先转换本地分支为远端分支 **只有第一次需要，之后的提交没有这个步骤**

     ```
     git push --set-upstream origin test
     ```

     ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180128/EF2fcgBi8b.png)

     接下来需要登录你的 Github 账号。

     至此，分支上的内容就提交到远端了

     **注意，若第一次执行 git commit，可能需要设置自己的姓名和邮箱，按照提示设置即可**

     ​

