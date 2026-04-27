---
name: trading-settlement-model
description: 交易与结算模型设计方法。定义账户体系、订单模型、资金流、账本（Ledger）、清算（Settlement）的核心结构。Use when 设计涉及资金流转的系统：交易所、电商、游戏、分销、AI付费、合约交易。
---

# 交易与结算模型

## 一、适用场景

任何涉及资金流转的系统：交易所 / 电商 / 游戏 / 分销 / AI 付费 / 合约交易

## 二、核心模型

- **账户体系（Account）**：主账户 / 子账户 / 资金账户
- **订单模型（Order）**：订单状态机（创建→成交→结算→完成）
- **资金流（Fund Flow）**：资金类型（可用/冻结/在途/锁定）
- **账本（Ledger）**：借贷记账法，每笔交易不可篡改
- **清算（Settlement）**：T+0 / T+1 / 实时清算

## 三、设计步骤（SOP）

1. **定义账户结构**（主账户/子账户/资金账户层级）
2. **定义资金类型**（可用余额/冻结/在途/锁定/持仓保证金）
3. **定义交易事件**（下单/成交/撤单/清算/提现/入金）
4. **定义账本记录规则**（借贷方向、科目编码）
5. **定义异常处理**（回滚/补偿/对账不平）

## 四、标准模板

### 订单表字段结构

```
order_id（主键）
user_id（用户ID）
account_id（账户ID）
symbol（交易对/商品）
side（buy/sell）
price（成交价）
quantity（数量）
amount（金额）
fee（手续费）
status（pending/filled/cancelled/settled）
created_at / settled_at
```

### 账本表结构

```
ledger_id（主键）
account_id（账户ID）
order_id（关联订单）
type（debit/credit）
amount（金额）
balance_before
balance_after
currency
category（交易/手续费/入金/提现/清算）
created_at
remark
```

## 五、可复用案例

- **中心化交易所**：用户A买入1 BTC，冻结USDT→成交→释放→记入账本
- **电商支付**：用户下单¥100，冻结→发货确认→清算到商家账户
- **分销佣金**：下级购买→触发佣金计算→记入上级佣金账户→可提现
- **合约交易**：开多→保证金冻结→浮动盈亏→平仓结算→释放保证金
