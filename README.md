# Bitcoinウォレットブロック数監視スクリプト
## 概要

Bitcoinノードの最新ブロックと、Explorerの最新ブロックのブロック差分（以下 Diffとする）を監視するスクリプト。
ruby wheneverで定期バッチとしてローカルのBitcoinウォレットと、blockchain.infoのブロック数を比較し、±3 block以上のDiffがあればSlack通知する。

## bitcoindを起動
```
cd bitcoind/
docker-compose up
```

## Slack Webhook URLを設定
`.env.sample`のSLACK_WEBHOOK_URL=[この部分]を通知を発行したいSlackチャンネルのWebhook URLに変更、ファイル名を`.env`に変更します。

## 定期バッチを登録
```
bundle install

bundle exec whenever

crontab -l # 現在のcrontabを確認

bundle exec whenever --update-crontab

crontab -l
```

## 定期バッチ終了

```
bundle exec whenever --clear-crontab
```

## 単体テスト実行

```
bundle exec rspec
```
