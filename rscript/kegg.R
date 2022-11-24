install.packages('svglite',repos = "https://mirrors.ustc.edu.cn/CRAN/")
library(ggplot2)

############################ 加载数据 ##########################
data <- read.csv("../data/data.csv")

head(data)
ggplot(data)+
  # 柱状图：注意stat参数
  geom_bar(aes(Chr, Number), stat = "identity")+
  # 反转x和y
  coord_flip()

# 这个图的难点就在于如何调整细节：
# 加颜色：对数据进行分组：
na_index <- which(is.na(data$Number))

group <- c(NA, rep(data$Chr[na_index[1]], na_index[2] - na_index[1] - 1),
           NA, rep(data$Chr[na_index[2]], nrow(data) - na_index[2]))

data$Group <- group
data$Chr <- factor(data$Chr, levels = rev(data$Chr))

table(data$Group)

colors <- c("black", rep("#9dd1c9", na_index[2] - na_index[1] - 1),
            "black", rep("#f4b76e", nrow(data) - na_index[2]))

face <- c("bold", rep(NULL, nrow(data) - na_index[2]))

ggplot(data, aes(Chr, Number))+
  # 柱状图：注意stat参数
  geom_bar(aes(fill = Group), stat = "identity")+
  # 加数据标签：
  geom_text(aes(label = Number, y = Number + 5), size = 2) +
  # 设置颜色：
  scale_fill_manual(values = c("#9dd1c9","#f2b06f","#bebbd7",
                               "#eb8776","#88afcf","#f4b76e"))+
  # 反转x和y
  coord_flip()+
  # 设置主题:
  theme_bw()+
  # 设置坐标轴刻度：
  scale_y_continuous(breaks=seq(0,1000, 200))+
  # 设置坐标轴标题：
  ylab("Number of Annotation")+
  xlab("")+
  theme(legend.position = "none", # 去掉图例
        # 修改网格线：
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_line(linetype = "dashed"),
        panel.grid.major.y = element_line(linetype = "dashed"),
        # 去掉y轴刻度：
        axis.ticks.y = element_blank(),
        # y轴标签：
        axis.text.y = element_text(face = "bold",
                                   color = rev(colors),
                                   hjust = 0, # 左对齐
                                   size = 8,lineheight = 2),
        # 标题居中：
        plot.title = element_text(hjust = 0.5, size = 10)
        )+
  ggtitle("Statistical Chr 2D annotation")

ggsave("sta.png", height = 9, width = 7)


