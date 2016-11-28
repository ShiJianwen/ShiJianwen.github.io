title: Git简易教程
date: 2015-07-13 9:37:10
categories: "Git"
tags: "git"

---
##命令

***初始化仓库***
```git
git init
```

***查看仓库状态***
```git
git status
```

***查看修改信息***
```git
git diff
```

***版本回退***
```git
git reset --hard HEAD^
```
***查看提交历史***
```git
git log
```

***查看命令历史***
```git
git reflog
```
<!-- more -->
***丢弃工作区中的修改***
```git
git checkout -- filename
```

***丢弃暂存区中的修改***
```git
git reset HEAD filename
git checkout -- filename
```

***删除文件***
```git
git rm filename
```

***生成 SSH Key***
```git
ssh-keygen -t rsa -C "youremail@example.com"
```

***添加远程库***
```git
git remote add origin git@server-name:path/repo-name.git
```

***推送本地更新到远程库***
```git
git push -u origin master   //如果第一次提交
git push origin master      //之后的提交
```

***从远程仓库克隆***
```git
git clone git@server-name:path/repo-name.git    //推荐使用 SSH 协议
```

***分支操作***
```git
git branch   //查看分支
git branch [name] //创建分支
git checkout [name] //切换分支
git checkout -b [name] //创建并切换分支
git merge [name]     //合并目标分支到当前分支
git branch -d [name] //删除分支
git log --graph      //查看分支合并图
```

***查看远程库信息***
```git
git remote -v
```

***推送到远程仓库的某个分支***
```git
git push origin [branch-name]
```

***抓取远程更新***
```git
git pull
```

***在本地创建跟远程分支对应的分支***
```git
git checkout -b [branch-name] [origin/branch-name]
```

***本地分支和远程分支关联***
```git
git branch --set-upstream [branch-name] [origin/branch-name]
```





