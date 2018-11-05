# mac 使用技巧

## 在顶部显示完整的路径

```zsh
defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES
```

复制文件路径：`cmd + option + c`

## 提取视频中的音频文件

```bash
ffmpeg -i video-filename -vn -ar 44100 -ac 2 -ab 192 -f mp3 sound.mp3
```

## 环境变量

[设置环境变量PATH](https://www.jianshu.com/p/acb1f062a925)


