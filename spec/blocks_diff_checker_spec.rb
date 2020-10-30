require 'spec_helper'
require_relative "../lib/blocks_diff_checker"

RSpec.describe 'BlocksDiffChecker' do
  before do
    # モック作成
    @explorer_mock = double('explorer')
    allow(@explorer_mock).to receive(:get)

    @local_wallet_mock = double('Local wallet mock')
    allow(@local_wallet_mock).to receive(:get)

    @slack_web_hook = double('Slack web hook')
    allow(@slack_web_hook).to receive(:post)

    # 対象インスタンスを作成し、モックを登録
    @checker = BlocksDiffChecker.new

    allow(@checker).to receive(:blockchain_latest_block_get).and_return(@explorer_mock)
    allow(@checker).to receive(:bitcoind_getblockcount).and_return(@local_wallet_mock)
    allow(@checker).to receive(:slack_web_hook).and_return(@slack_web_hook)
  end

  it 'bitcondとexplorerの差分の±3 block以上のDiffがあればslackに通知する' do
    # 前提条件
    allow(@explorer_mock).to receive(:get).and_return({ "height": 50_000 })
    allow(@local_wallet_mock).to receive(:get).and_return({ "blocks": 50_003 })

    # 期待動作
    expect(@explorer_mock).to receive(:get).once
    expect(@local_wallet_mock).to receive(:get).once
    expect(@slack_web_hook).to receive(:post).with(
      'bitcondとexplorerのlatest block number差分が±3 block以上です。(bitcond: 50000, explorer: 50003)'
    ).once

    # テスト実行
    @checker.execute
  end

  [
    ['差分が-3のとき、Slack通知する', 60_000, 59_997, true],
    ['差分が-2のとき、何もしない', 60_000, 59_998, false],
    ['差分が±0のとき、何もしない', 60_000, 60_000, false],
    ['差分が+2のとき、何もしない', 60_000, 60_002, false],
    ['差分が+3のとき、Slack通知する', 60_000, 60_003, true]
  ].each do |name, explorer_blocks, bitcoind_blocks, is_post_expected|
    it(name) do
      # 前提条件
      allow(@explorer_mock).to receive(:get).and_return({ "height": explorer_blocks })
      allow(@local_wallet_mock).to receive(:get).and_return({ "blocks": bitcoind_blocks })
      allow(@slack_web_hook).to receive(:post)

      # 期待動作
      expect(@slack_web_hook).to receive(:post).once if is_post_expected

      # テスト実行
      @checker.execute
    end
  end
end
