# 模组指令说明
- 本文件包含模组所有可用的指令集合（均以mix开头，对大小写不敏感）

## 基本指令
- `mix stop` / `mix continue`
  - 完全停止/恢复缝合敌人的自然生成（游戏大退后自然结束）

- `mixspawn` / `mixspawnwith XX.XX.XX XX.XX.XX LR LR`
  - 根据前2个参数生成缝合敌人，根据后2个参数选择缝合敌人的左右边。
  - 参数说明：
    - Variant与SubType可不填，默认值为0
    - 参数为空时适用当前缝合规则
    - 参数会经过类型检查
        - 类型检查：根据参数查询对应敌人（包括subtype）是否在可用范围内。如失败，则忽略SubType再次执行。再失败后，放弃该参数，按当前规则随机抽取。
  - 示例：
    ```bash
    mixspawn 67 20
    # 生成戳戳与苍蝇公爵的缝合体
    
    mixspawn 67 20 L L
    # 生成戳戳与苍蝇公爵左半边的缝合体（一方会反转）
    ```
  - 注意：
    - `mixspawn`在单个输入时不会根据实体抽取
        - 例如，在第1层输入mixspawn 951，会生成祸兽和随机一层小怪的缝合体。
    - 如需根据实体抽取，请使用`mixspawnwith`

## 生成控制指令
- `mixchance YY`
  - 敌人生成时，有YY概率是缝合敌人（默认值：1）

- `mixfollowlevel YY`
  - 有YY概率根据当前楼层抽取缝合目标（默认值：0）
    - 楼层标签：1-5代表前5章节，6代表超级Boss，+0.5代表支线层。5.5代表堕化

- `mixhardlevel XX`
  - 纳入楼层标签不大于（当前标签+XX）的敌人（默认值：0）

- `mixbaselevel XX`
  - 纳入楼层标签不小于（当前标签+XX）的敌人（默认值：-999）
  - 当baselevel高于hardlevel时，将强制修改hardlevel与baselevel一致。

- `mixtaglevel tag XX`
  - 为特定tag的敌人调整楼层标签
  - 可用tag：
    - `boss`：Boss类型敌人（默认值：+2）
    - `noboss`：非Boss敌人（默认值：0）
    - `sin`：七罪类型敌人（默认值：-1）
    - `larry`：多体节类型敌人
    - `stone`：机关类敌人
    - `alt`：换色变种敌人
  - 上述tag可叠加。

## 生成继承指令
- `mixspawner`
  - 格式：
    ```bash
    mixspawner XX.XX.XX-YY  # 指定敌人
    mixspawner YY           # 所有敌人
    mixspawner clear        # 清除指令
    ```
  - 该指令允许批量输入，允许忽略Variant与Subtype。
  - 功能：控制缝合类敌人不通过亡语生成的子类被缝合的概率（默认值：0.2）
  - 通过子类缝合的敌人产生的子类不再具有缝合能力。

- `mixspawneronkill`
  - 格式同上
  - 功能：控制缝合类敌人亡语生成的子类被缝合的概率（默认值：0.2）

- `mixsamespawner`
  - 格式同上
  - 功能：控制缝合类敌人生成的子类继承父类缝合目标的概率（默认值：1）

## 强制规则指令
- `mixforce XX.XX.XX-WW`
  - 强制指定缝合目标
  - 该指令允许批量输入，允许忽略Variant与Subtype，允许忽略权重（默认值：1）。
  - 如果传入检查失败的参数，或是传入空参数，则会清空强制缝合目标。
  - 示例：
    ```bash
    mixforce 19          # 所有敌人变成LarryJr
    mixforce 19-1 20-3   # 25% LarryJr，75% 戳戳
    mixforce             # 清空强制规则内容
    ```

- `mixforcechance YY`
  - 设置强制缝合的概率（默认值：1）

- `mixsameinroom YY XX`
  - 同房间内统一缝合规则
  - 参数：
    - YY：概率，每个敌人分别计算（默认值：0）
    - XX：选取的目标数量（默认值：1）

- `mixsameinlevel YY XX`
  - 同楼层内统一缝合规则
  - 参数同上

## 精细规则指令
- `mixforceboss YY`
  - 从Boss池抽取的概率（默认值：0）

- `mixforcenoboss YY`
  - 从非Boss池抽取的概率（默认值：0）

- `mixforcetag tag YY`
  - tag标签的敌人从tag池抽取的概率（Boss默认值：0.3，其余均为0）

- `mixhprate main/nomain WW`
  - 设置HP计算权重
  - 默认值：main=4，nomain=1 此时，敌人血量为(4*main+1*nomain)/5

## 批量执行指令
- `mixexecutepack [CMD1 XXXX] [CMD2 XXXX]`
  - 批量执行多条指令

## 模式管理指令
- `mixrecordmode XX`
  - 记录当前设置为XX模式

- `mixsetmode XX`
  - 载入XX模式

## 预设模式
- `default`模式
  - 恢复所有设置至初始状态

- `chaos`模式
  - 继承随机mod 90%的风味。
  - 包含以下设置：
    ```bash
    mixhardlevel 10
    mixforcetag boss 0.8
    mixforcetag noboss 1
    mixhprate main 1
    mixhprate nomain 1
    ```
- `envy`模式
  - 堕胎的最爱
  - 包含以下设置：
    ```bash
    mixforce 51 51.10 51.20 51.1 51.11 51.21
    mixhprate main 1
    mixhprate nomain 0
    ```
   -嫉妒等纯分裂怪死亡时继承概率默认设置为0.4，不受全局影响，但依然可指定调控。用法：
    mixspawneronkill 51-1 51.10-1 51.20-1 51.1-1 51.11-1 51.21-1
    mixsamespawner 51-1 51.10-1 51.20-1 51.1-1 51.11-1 51.21-1