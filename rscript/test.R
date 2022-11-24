pacman::p_load(
  rio,            # import/export
  here,           # file pathways
  flextable,      # make HTML tables
  officer,        # helper functions for tables
  tidyverse)      # data management, summary, and visualization
table <- read.table("../data/1.txt",sep=',')
print(table)

# 创建基础三线表：
my_table <- flextable(table)
my_table

#################### 调整与个性化设置 ################
# 列宽调整：
# autofit()函数可以很好地展开表格，使每个单元格只有一行文本
my_table %>% autofit()

# 我们也可以使用qflextable()快速实现上述效果：
qflextable(table)

# 自定义列宽：
my_table <- my_table %>%
  width(j=1, width = 2.7) %>%
  width(j=c(2,3,4,5,7,8,9), width = 1)

my_table


# 设置列标题：
my_table <- my_table %>%
  # 添加标题行：
  add_header_row(
    top = TRUE,                # New header goes on top of existing header row
    values = c("sample",     # Header values for each column below
               "TAD",    # This will be the top-level header for this and two next columns
               "",
               "",
               "",
               "Loop",         # This will be the top-level header for this and two next columns
               "",             # Leave blank, as it will be merged with "Died"
               "",
               "")) %>%
  # 设置标题行的标签：
  set_header_labels(
   'V2' = "Total",
   'V3' = 'Avg. Size',
   'V4' = 'Max. Size',
   'V5' = 'Min. Size',
   'V6' = "Total",
   'V7' = 'Avg. Size',
   'V8' = 'Max. Size',
   'V9' = 'Min. Size'
  )%>%

  merge_at(i = 1, j = 2:5, part = "header") %>% # Horizontally merge columns 3 to 5 in new header row
  merge_at(i = 1, j = 6:9, part = "header")     # Horizontally merge columns 6 to 8 in new header row

my_table


# 边框和背景：
# 定义线的颜色和宽度等：
border_style = officer::fp_border(color="black", width=1)

# 加框线：
my_table <- my_table %>%
  # 移除所有框线：
  border_remove() %>%
  # 通过已有的主题设置添加水平线
  theme_booktabs() %>%
  # 添加竖线分开恢复和死亡部分
  vline(part = "all", j = 1, border = border_style) %>%   # at column 2
  vline(part = "all", j = 5, border = border_style)       # at column 5

my_table

# 字体和对齐：
my_table <- my_table %>%
  flextable::align(align = "center", j = c(2:8), part = "all") %>%
  # 调整列标题字体：
  fontsize(i = 1, size = 12, part = "header") %>%
  # 调整列标题的font face：
  bold(i = 1, bold = TRUE, part = "header")
  # 此外，也可以指定调整第7行的字体：

my_table


my_table <- my_table %>%
  merge_at(i = 1:2, j = 1, part = "header")

# 背景设置：
my_table <- my_table %>%
  bg(part = "body", bg = "gray95")

my_table

tf1 <- tempfile(fileext = ".html")
print(tf1)
save_as_html(my_table, path = './t.html')