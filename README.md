---
_自6.0起，请不要克隆和下载仓库，仓库涵盖8种辅助码，除非你知道自己在做什么。我在release做了分包处理，你可以在最新的版本号下载到正式的方案库，可以在每夜词库更新获得最新的词库和模型更新，小幅度微调我也会直接在最新的release update
区别是辅助码无需配置了而是通过选择下载来确认词库携带的辅助码，体积更小！_
---



# 万象系列方案——辅助码版(全拼用户移步标准版)

本方案为万象辅助码增强版   [>>万象标准版,支持同文9、14、18键](https://github.com/amzxyz/rime_wanxiang)  

---------------------

[为什么默认关闭调频的说明](https://github.com/amzxyz/RIME-LMDG/wiki/%E4%B8%BA%E4%BB%80%E4%B9%88%E8%A6%81%E5%85%B3%E9%97%AD%E8%B0%83%E9%A2%91%E4%BB%A5%E5%8F%8A%E4%B8%8E%E4%B9%8B%E5%85%B3%E8%81%94%E7%9A%84%E6%8E%AA%E6%96%BD%E6%9C%89%E5%93%AA%E4%BA%9B)   ```enable_user_dict: false # 是否开启自动调频，true为开启```

## 万象拼音——基于深度优化的词库和语言模型

[万象词库与万象语言模型](https://github.com/amzxyz/RIME-LMDG) 是一种带声调的词库，经过AI和大基数语料筛选、加频，结合语言模型获得更准确的整句输出。还结合了中英文混输，一套词库，多种用法，具体可以点击链接了解优势

### 优势

1. 词库词语全部加音调
2. 设计8种辅助码，头部使用全拼编码，可以转化为任何双拼编码
    - 词库解码顺序为：全拼拼音；墨奇码；鹤形；自然码；简单鹤；仓颉；虎码首末；五笔前2；汉心码
    - 因此，万象拼音支持拼音和辅助码任意两两组合

### 答疑

#### 为什么词库这么大，我见过只有单字携带辅助码的方案，词库可以缩小吗？

在这里我借助wiki深入阐述一下这个问题并解答这些问题：[万象词库PRO的设计理念](https://github.com/amzxyz/RIME-LMDG/wiki/%E4%B8%87%E8%B1%A1%E8%AF%8D%E5%BA%93PRO%E7%9A%84%E8%AE%BE%E8%AE%A1%E7%90%86%E5%BF%B5)

总而言之，**万象词库中的带声调拼音标注+词组构成+词频是整个万象项目的核心，是使用体验的基石，方案的其它功能皆可自定义，我希望使用者可以基于词库+转写的方式获得输入体验** [万象词库问题收集反馈表](https://docs.qq.com/smartsheet/DWHZsdnZZaGh5bWJI?viewId=vUQPXH&tab=BB08J2)

---------------------

**效果大赏**

![效果.png](https://storage.deepin.org/thread/202502200358104987_效果.png)

---------------------

### 使用方法

不了解rime基础的可以参考友情链接：

[oh my rime](https://www.mintimate.cc/zh/guide/installRime.html) 

[rime参数配置](https://xishansnow.github.io/posts/41ac964d.html)

整个rime配置生态都是通的，里面有非常完整的使用方法，(诸如放到哪里、换个皮肤、什么是用户目录。。。)我不想重复造轮子，如果看完了还能想起万象，欢迎来到你的进阶之旅！

由于万象**支持各种演变双拼编码方式**，所以不能一一列举，且方案文件多了容易混乱。然而，使用rime不可避免的要自定义，故而干脆将选项前置，初始化选择一番就是自己想要的方案，更深的定制再去修改其它地方

#### ①第一种方法：快速开始

1. 打开`wanxiang.schema.yaml`文件，表头按照提示进行3个维度的选择，定义属于自己的输入法方案

    ```yaml
    #本方案匹配词库解码顺序为：全拼拼音；墨奇；鹤形；自然码；简单鹤；仓颉首末；虎码首末；五笔前2；汉心码
    #############DIY你想要的方案组合,试试搭配一个自然码+墨奇辅助的方案吧！###########################
    set_shuru_schema:         #配置此项就是选择什么输入法,同时拆分反查和中英文混输也将匹配该输入方案
      __include: algebra_zrm  #可选解码规则有   algebra_pinyin, algebra_zrm, algebra_flypy, algebra_ziguang, algebra_sogou, algebra_mspy, algebra_abc  选择一个填入
    set_algebra_fuzhu:        #配置此项就是选择什么辅助码，分包版本无需配置此项
      __include: fuzhu_zrm    #可选辅助码有：fuzhu_kong，fuzhu_moqi, fuzhu_zrm, fuzhu_flypy, jdh, cj, fuzhu_tiger, fuzhu_wubi, fuzhu_hanxin 选择一个填入
    pro_comment_format:       # 超级注释模块，子项配置 true 开启，false 关闭
      candidate_length: 1     # 候选词辅助码提醒的生效长度，0为关闭  但同时清空其它，应当使用上面开关来处理
      fuzhu_type: zrm         # 用于匹配对应的辅助码注释显示，基于默认词典的可选注释类型有：(tone, moqi, flypy, zrm, jdh, cj, tiger, wubi, hanxin)选择一个填入，之所以单独列出是因为这里有更多的可配置性，而真正的辅助码默认只有7种
      corrector_type: "{comment}"  # 换一种显示类型，比如"({comment})" 
    ########################以下是方案配置######################################################
    ```

2. 打开 `wanxiang_radical.schema.yaml` 和 `wanxiang_en.schema.yaml` 表头进行选择，二者情况一致：

    ```yaml
    ###############选择与之匹配的拼音方案#####################
    set_shuru_schema:
      __include: algebra_zrm#可选的选项有（algebra_pinyin, algebra_zrm, algebra_flypy, algebra_mspy, algebra_sogou, algebra_abc, algebra_ziguang）
    ######################################################
    ```

3. 保存后部署方案即可！

#### ②进阶custom patch法（已经尽量为你简化）强烈推荐

1. 方案文件中有一个custom目录，里面存放了一些说明和三个yaml文件，这是帮你预设好的patch方法，你可以对里面的每一条进行仔细阅读修改为合适的选项，保存后将它们复制到你的配置文件根目录下，这样你就可以放心地更新配置而不用担心自己的特殊设置被覆盖了。

2. 其中重点注意的是 `custom_phrase.txt` 文件名称你最好自定义一个，custom里面 `custom_phrase/user_dict: xxxxxx` 改成什么就需要手动创建 `xxxxxx.txt` 文件在用户目录

**修改好这三个yaml一定要复制一份到用户目录，它才能真正生效，祝你顺利！**

### 其他功能

#### 辅助码

辅助码可以在输入一个确定得拼音后面继续输入一个部首的读音，使得这个字出现在靠前甚至第一位。这种方式易于理解，无须记忆字根，一切基于拼音得基础上。例如：

![截图_选择区域_20240704121653.png](https://storage.deepin.org/thread/202407041144502563_截图_选择区域_20240704121653.png)

**功能1**  如果想要 `镇` 字显示在前面  那么在本方案下提供两种方式，第一种就是辅助码声母，`vf`继续输入`j` 也就是金字旁得声母即可出现结果，如果还是出现不了你要的结果，可以输入另外主体字的声母来继续缩小范围。

![截图_选择区域_20240704121809.png](https://storage.deepin.org/thread/202407041147131421_截图_选择区域_20240704121809.png)

**功能2**  第二种方式是通过反查字库来定位，只是通过不同的方案实现，在输入主要拼音后，通过符号```  来引导进入反查状态，引导后继续输入`jn`金 则包含金的字就会被选出来；

![截图_选择区域_20240704121635.png](https://storage.deepin.org/thread/202407041149125588_截图_选择区域_20240704121635.png)

引导后继续输入`mu 木`则带`木`的字就会被选出来

![截图_选择区域_20240704121611.png](https://storage.deepin.org/thread/202407041149524870_截图_选择区域_20240704121611.png)

**功能3**  通过 拼音状态下``〔反查：部件|笔画〕`来引导拆字模式 举例 `震`  假设你不认识，你可以通过`雨和辰` 来合并输入，拼音状态输入后，继续输入其它字符字母az会消失如下图，输入 `yu if` 即雨 辰，结果出现了我们要的震字，且给出了辅助码 `y` 和  `i`  ，`y`是雨的声母`y`，`i`是辰的声母`ch`，同时通过hspnz分别代表横竖撇捺折，两种类型兼容。

 ![截图_选择区域_20240928112256.png](https://storage.deepin.org/thread/202409280324599355_截图_选择区域_20240928112256.png)

**功能4**  句子中间或者单字输入时需要输入全位辅助码时由于与双拼词语重码，因为我们设计的基本辅助码是2位，加上双拼共4位，由于在整句中我们为了整句输入的顺畅，不会将4码聚拢作为优先级较高的选择，这样会在很多时候造成你想打的句子缩成一团变成全辅助码的词汇。此时可以通过追加/的方式使其聚拢，这种方式是由于我们是直接辅助码导致的，如果我们通过一个符号引导辅助码，那么在输入时要每一个都用到符号，而采用这种方式我们只需要在必要的时候使用/节省了输入的按键开支，下面由两个图片说明问题：

![截图_选择区域_20240821093644.png](https://storage.deepin.org/thread/202408210142513354_截图_选择区域_20240821093644.png)

![截图_选择区域_20240821093701.png](https://storage.deepin.org/thread/202408210143144721_截图_选择区域_20240821093701.png)

**功能5**  句子中间或者单字输入时需要可以使用更精确的聚拢方式"声调辅助"，7890数字按键代表1234声，轻声归并到4声，在功能4中我们可以在双拼两码后面3个编码的位置任意插入声调与两位辅助码混合使用，就是除了不用斜杠了，我们还顺序自由了，下面由两个图片说明问题：

![截图_选择区域_20250512101814.png](https://storage.deepin.org/thread/202505120222182012_截图_选择区域_20250512101814.png)

![截图_选择区域_20250512101752.png](https://storage.deepin.org/thread/20250512022217432_截图_选择区域_20250512101752.png)

![截图_选择区域_20250512101713.png](https://storage.deepin.org/thread/202505120222163619_截图_选择区域_20250512101713.png)

#### 其他亮点功能

**日期、时间、节日、节气、问候模板：**

```yaml
#时间：osj 或者 /sj
#日期：orq 或者 /rq
#农历：onl 或者 /nl
#星期：oxq 或者 /xq
#今年第几周：oww 或者 /ww
#节气：ojq 或者 /jq
#日期+时间：ors 或者 /rs
#时间戳：ott 或者 /tt
#大写N日期：N20250315
#节日：ojr 或者 /jr
#问候模板：/day 或者 oday
```

**Unicode：** 大写 U 开头，如 U62fc 得到「拼」。

**数字、金额大写：**  大写 R 开头，如 R1234 得到「一千二百三十四、壹仟贰佰叁拾肆元整」。

 **/模式：**  通过输入 /sx 快捷输入关于“数学”的特殊符号，具体能输入什么可以打开 symbols.yaml学习。

**计算器：**  通过输入大写V引导继续输入如：V3+5  候选框就会有8和3+5=8，基础功能 `+ - * / % ^` 还支持 `sin(x) cos(x)` 等众多运算方式 [点击全面学习](https://github.com/gaboolic/rime-shuangpin-fuzhuma/blob/main/md/calc.md)

**自动上屏：**  例如：三位、四位简码唯一时，自动上屏如`jjkw岌岌可危` `zmhu怎么回事` 。默认未开启，方案文件中`speller:`字段下取消注释这两句开启 `#  auto_select: true  #  auto_select_pattern: ^[a-z]+/|^[a-df-zA-DF-Z]\w{3}|^e\w{4}`

**错音错字提示：**  例如：输入`gei yu给予`，获得`jǐ yǔ`提示，此功能与双拼类型无关全部支持；

**快符Lua：** 例如 ```'q``` 通过单引号键引导的26字母快速符号自动上屏，双击''重复上一个符号；

**超级tips：** 支持将表情、化学式、翻译、简码 提示等等你能想到得数据获得提示显示并将通过一个自定义按键直接上屏，默认为“.” 避免了占用候选框，通过Control+t 进行开关；

**辅助码提示：** 任意长度候选词的辅助码提示能力，默认开启1个字的辅助码，Ctrl+a开启和关闭辅助码，Ctrl+c开启拆分辅助提示，这些都是共用配置可在开关中按自己需求配置，保留一个；

**音调显示：** 在辅助码配置中有tone这一参数，可以将音调拼音显示到注释里，通过Ctrl+s可以使得输入码显示全拼并加音调；

**用户按需造词：** 默认通过``` `` ```引导的方式进入用户词自造词模式，继续输入则``` `` ```前缀消失，后面打出来的字上屏后完成造词。 pro版本讲究自主可控，由于辅助码的使用在很多时候不熟悉的时候可能会上屏更加异常的词汇或者生僻字，有的用户还不会使用Esc退出输入，而是选择直接敲下空格。按需造词可以有效把控造出的词是有意义的，而且默认靠后，原因简单基本上有意义的高频词万象已经提供，你应该使用辅助码将其前置。

**用户词删除：** 不管什么删除都不能直接作用于固定词典，使用Ctrl+del是rime系统删除用户词。

**手动排序：** 对选中的候选词操作，使用Ctrl+j向左一步，Ctrl+k向右一步，Ctrl+0(零)移除排序。

**Tab循环切换音节：**  当输入多个字词时想要给前面补充辅助码，可以多次按下tab循环切换，这种可能比那些复杂的快捷键好用一些；

**翻译模式：**  输入状态按下Ctrl+E快捷键进入翻译模式，原理是opencc查表进行中英文互译，能否翻译取决于词表的丰富度；

 **反查：** 支持``` ` ```引导状态下的显示格式化，同时支持部件组字模式和笔画模式。反查模式不受字符集过滤影响，默认开放大字集,也不受辅助码开关影响，会显示注释，如：功能2相关展示；

**字符集过滤：** 默认开启过滤，写在charset.dict.yaml的就是可以通过的字表，默认为8105+𰻞𰻞，如果你想什么字在小字集模式可以通过可以写在这里，配套开关【小、大】，快捷键Ctrl+g

![思维导图](https://github.com/amzxyz/rime_wanxiang_pro/blob/main/.github/%E4%B8%87%E8%B1%A1%E8%BE%93%E5%85%A5%E6%96%B9%E6%A1%88.png)

## Rime输入框架下万象拼音、词库设计思路拆解

### 痛点

- **配置复杂：**  rime的配置本就复杂(对于新手)，常常会看到很多的方案和分支，这就又导致新手接触的时候要理清这些都是干什么的、有什么关联、我该选择什么？
- **用户词库：**  词库涉及到丰富度、词频，一味地堆砌并不能提升体验，反而会提升内存占用，词频不恰当候选词可能排序不理想，影响输入效率。
- **探索适应期：** 选择困难，每个都有各自的特点，无法一次性选择好方案，一个一个去尝试，耗费的是精力，损失的是用户词，找到与自己习惯匹配的方案似乎很难，这个过程越久越容易放弃。

### 思路

#### 简化合并词库

- 简化选择，但又不能完全放弃选择，让用户有一个词库可选，却有多种方案可用。于是首先想到的是合并词库，每个方案都有自己的特定词库，他们编码方式不一样，词库内容和词频不一样，如果将其合并为一个词库，并解决这个词库的丰富度，解决词频问题，那将成为可扩展的元词库，我们将其称为——万象词库。

  ```yaml
  #词库解码顺序为：全拼拼音；墨奇码；鹤形；自然码；简单鹤；仓颉；虎码首末；五笔前2
  万	wàn;av;ap;ag,ap;du;ms;fp;dn;	87991
  象	xiàng;du;dn;du,pd,ua;gh;no;wx;qj;	3107
  拼	pīn;fk;fk;fb;jp;qt,qj;ul;ru;	5904
  音	yīn;lo;lo;lo;cc;ya;xy;uj;	13619
  ```

  这样的编码方式使用全拼作为基础意味着他能转换为任意一种双拼编码，有了共同的基底，后面通过分号隔开分别列举多种辅助码方式，我们可以通过运算规则来调用不同的辅助码。

#### 拼写运算

- 如何实现我们设想的两两组合呢，是否真的可以做到，经过分析使用自然码举例：

  1. 我们先去转换拼音为双拼编码，并命名为对应的输入方案，如：algebra_zrm；
  2. 当词库编码发生变化后我们通过运算实现双拼+辅助码的形式，从而真正可以打出这些字，我们把运算辅助码的部分命名为：fuzhu_zrm；
  最后在 speller/algebra: 段落下按照顺序列出，从而形成一个完整连贯的运算规则。

- 下面来看自然码双运算规则，我们要把编码拼音部分做转换，但要保留第一个分号后及其后面所有内容：

  ```YAML
  algebra_zrm: 
    __append:
      - derive/^([jqxy])u(;.*)$/$1v$2/
      - derive/^([aoe])([ioun])(;.*)$/$1$1$2$3/
      - xform/^([aoe])(ng)?(;.*)$/$1$1$2$3/
      - xform/^(\w+?)iu(;.*)$/$1Ⓠ$2/
      - xform/^(\w+?)[uv]an(;.*)$/$1Ⓡ$2/
      - xform/^(\w+?)[uv]e(;.*)$/$1Ⓣ$2/
      - xform/^(\w+?)ing(;.*)$/$1Ⓨ$2/
      - xform/^(\w+?)uai(;.*)$/$1Ⓨ$2/
      - xform/^(\w+?)uo(;.*)$/$1Ⓞ$2/
      - xform/^(\w+?)[uv]n(;.*)$/$1Ⓟ$2/
      - xform/^(\w+?)i?ong(;.*)$/$1Ⓢ$2/
      - xform/^(\w+?)[iu]ang(;.*)$/$1Ⓓ$2/
      - xform/^(\w+?)en(;.*)$/$1Ⓕ$2/
      - xform/^(\w+?)eng(;.*)$/$1Ⓖ$2/
      - xform/^(\w+?)ang(;.*)$/$1Ⓗ$2/
      - xform/^(\w+?)ian(;.*)$/$1Ⓜ$2/
      - xform/^(\w+?)an(;.*)$/$1Ⓙ$2/
      - xform/^(\w+?)iao(;.*)$/$1Ⓒ$2/
      - xform/^(\w+?)ao(;.*)$/$1Ⓚ$2/
      - xform/^(\w+?)ai(;.*)$/$1Ⓛ$2/
      - xform/^(\w+?)ei(;.*)$/$1Ⓩ$2/
      - xform/^(\w+?)ie(;.*)$/$1Ⓧ$2/
      - xform/^(\w+?)ui(;.*)$/$1Ⓥ$2/
      - xform/^(\w+?)ou(;.*)$/$1Ⓑ$2/
      - xform/^(\w+?)in(;.*)$/$1Ⓝ$2/
      - xform/^(\w+?)[iu]a(;.*)$/$1Ⓦ$2/
      - xform/^sh/Ⓤ/
      - xform/^ch/Ⓘ/
      - xform/^zh/Ⓥ/
      - xlit/ⓆⓌⓇⓉⓎⓊⒾⓄⓅⓈⒹⒻⒼⒽⓂⒿⒸⓀⓁⓏⓍⓋⒷⓃ/qwrtyuiopsdfghmjcklzxvbn/
  ```

  此时获得的输出是：

  ```YAML
  #词库解码顺序为：全拼拼音；墨奇码；鹤形；自然码；简单鹤；仓颉；虎码首末；五笔前2
  万	wj;av;ap;ag,ap;du;ms;fp;dn;	87991
  象	xd;du;dn;du,pd,ua;gh;no;wx;qj;	3107
  拼	pn;fk;fk;fb;jp;qt,qj;ul;ru;	5904
  音	yn;lo;lo;lo;cc;ya;xy;uj;	13619
  ```

  在此基础之上对于辅助码进行运算，这里针对不同位置的辅助码分别写了提取规则，但是提取之后则采用了统一格式的运算，这就大大减小了运算难度:

  ```YAML
  fuzhu_zrm:  ########################################位于词库第三个分号后
    __append:
      - xform|^(.{2});.*?;.*?;(.*?);.*$|$1;$2|
      - xform|^(\w+?);.*?;.*?;(.*?);.*$|$1;$2|  #匹配当前方案，转换为 双拼；辅助码（当前方案）的形式
      - derive/^(.{2}|\w+?);.*$/$1/ # 纯双拼的情况
      - derive/^(.{2}|\w+?);(\w)(\w).*$/$1$2/ # 双拼+一位辅助码的情况
      - derive/^(.{2}|\w+?);(\w)(\w).*$/$1[$2/ # 双拼+[一位辅助码的情况
      - derive/^(.{2}|\w+?);.*?,(\w)(\w).*$/$1$2/ # 双拼+一位辅助码的情况
      - derive/^(.{2}|\w+?);.*?,(\w)(\w).*$/$1[$2/ # 双拼+[一位辅助码的情况
  
      - abbrev/^(.{2}|\w+?);(\w)(\w).*$/$1$2$3/ # 双拼+2位辅助码的情况，abbrev类型不可以整句内输入2位辅助码，必须加o或/
      - abbrev/^(.{2}|\w+?);.*?,(\w)(\w).*$/$1$2$3/ # 双拼+2位辅助码的情况，abbrev类型不可以整句内输入2位辅助码，必须加o或/
  
      - derive/^(.{2}|\w+?);(\w)(\w).*$/$1$2$3o/ # 整句模式下，输入syffo 出单字 增强单字性能
      - derive|^(.{2});(\w)(\w).*$|$1$2$3/| # 整句模式下，输入syff/ 出单字 增强单字性能
      - derive|^(\w+?);(\w)(\w).*$|$1$2$3/| # 整句模式下，输入syff/ 出单字 增强单字性能
  
      - derive/^(.{2}|\w+?);.*,(\w)(\w).*$/$1$2$3o/ # 整句模式下，输入syffo 出单字 增强单字性能
      - derive|^(.{2});.*,(\w)(\w).*$|$1$2$3/| # 整句模式下，输入syff/ 出单字 增强单字性能
      - derive|^(\w+?);.*,(\w)(\w).*$|$1$2$3/| # 整句模式下，输入syff/ 出单字 增强单字性能
      - derive|^(.{2});.*,(\w)(\w).*$|$1$2$3/| # 整句模式下，输入syff/ 出单字 增强单字性能
  ```

  第一二条就是把很长的编码缩短到双拼+辅助码的形态，本来一条即可，为了照顾微软和搜狗方案中使用了分号作为一个韵母多写了一条，毕竟我们说了要自由搭配的，所以兼容性必须做。

  输出：

  ```YAML
  万	wj;ag,ap	87991
  象	xd;du,pd,ua	3107
  拼	pn;fb	5904
  音	yn;lo	13619
  ```

  没错用逗号隔开的是辅助容错码，不管输入哪两个都可以打出这个字，这样大部分时候靠猜测也能利用起来辅助码，这个场景也做了兼容。

  最后通过运算规则这个“万”字就有了以下几种组合可以输出：

  ```YAML
  万	wj
  万	wja
  万	wjag
  万	wjap
  为了增强整句中单字性能，通过增加o或者/的方式还可以获得以下输出
  万	wjago
  万	wjapo#o其实为了一些手机输入法不方便使用符号作为增强按键，但是可能会存在 类似于：你心理想的： ui uio，实际的：uiuio只输出一个字
  万	wjag/
  万	wjap/
  ```

#### 缝合

在rime中`speller/algebra:`就是拼写运算之处，我们为了用户自定义变得方便，我们基于三个维度制作了一个表头，用来前置参数配置：

```YAML
#本方案匹配词库解码顺序为：全拼拼音；墨奇;鹤形;自然码;简单鹤;仓颉首末;虎码首末;五笔前2
#############DIY你想要的方案组合,试试搭配一个自然码+墨奇辅助的方案吧！###########################
set_shuru_schema: #配置此项就是选择什么输入法,同时拆分反查和中英文混输也将匹配该输入方案
  __include: algebra_zrm  #可选解码规则有   algebra_pinyin, algebra_zrm, algebra_flypy,  algebra_ziguang, algebra_sogou, algebra_mspy, algebra_abc  选择一个填入
set_algebra_fuzhu:#配置此项就是选择什么辅助码
  __include: fuzhu_zrm #可选辅助码有：fuzhu_kong，fuzhu_moqi, fuzhu_zrm, fuzhu_flypy, fuzhu_tiger, fuzhu_cj, fuzhu_wubi, fuzhu_jdh 选择一个填入
#Lua 配置: 超级注释模块
pro_comment_format:   # 超级注释，子项配置 true 开启，false 关闭
  candidate_length: 1 # 候选词辅助码提醒的生效长度，0为关闭  但同时清空其它，应当使用上面开关来处理
  fuzhu_type: zrm # 用于匹配对应的辅助码注释显示，可选显示类型有：moqi, flypy, zrm, jdh, cj, tiger, wubi, hx选择一个填入，应与上面辅助码类型一致
  corrector_type: "{comment}" # 新增一个显示类型，比如"【{comment}】" 
########################以下是方案配置######################################################
```

我们需要按照如下格式对`speller/algebra:`进行排序：

```YAML
speller:
# table_translator翻译器，支持自动上屏。例如 “zmhu”可以自动上屏“怎么回事”
auto_select: true

#  auto_select_pattern: ^[a-z]+/|^[a-df-zA-DF-Z]\w{3}|^e\w{4}
  # 如果不想让什么标点直接上屏，可以加在 alphabet，或者编辑标点符号为两个及以上的映射
  alphabet: zyxwvutsrqponmlkjihgfedcbaZYXWVUTSRQPONMLKJIHGFEDCBA`/
  # initials 定义仅作为始码的按键，排除 ` 让单个的 ` 可以直接上屏
  initials: zyxwvutsrqponmlkjihgfedcbaZYXWVUTSRQPONMLKJIHGFEDCBA
  delimiter: " '"  # 第一位<空格>是拼音之间的分隔符；第二位<'>表示可以手动输入单引号来分割拼音。
  algebra:
__patch:
  - set_shuru_schema #拼音转双拼码
  - set_algebra_fuzhu #辅助码部分
```

至此只需要模块化分别列举出不同的双拼方案，不同的辅助码形态交叉调用即可实现自然码+鹤形，小鹤+自然码，搜狗+五笔，甚至全拼+辅助码的形态等各种奇怪的组合。

表头的第三个维度，为用户留出了初学需要看辅助码，可以用于记忆慢慢让字都能出现在第一位。

## 鸣谢

- 项目英文词库部分来自"[rime-ice](https://github.com/iDvel/rime-ice)"
- 拼音标注来自万象词库与语法模型项目，并在该项目下进行鸣谢！
- 感谢网友的热情提报问题，使得模型和词库体验进一步提升。

## 赞赏

如果觉得项目好用，可以请AMZ喝咖啡

<img alt="pay" src="./.github/赞赏.jpeg" height="312" width="446">
