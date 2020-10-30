require_relative 'blockchain_latest_blocks'
require_relative 'slack_webhook'

class BlocksDiffChecker
  def execute
    remote_res = blockchain_latest_block_get.get
    remote_blocks = remote_res[:height]

    local_res = bitcoind_getblockcount.get
    local_blocks = local_res[:blocks]

    diff = remote_blocks - local_blocks

    return if diff.abs < 3

    msg = "bitcondとexplorerのlatest block number差分が±3 block以上です。(bitcond: #{remote_blocks}, explorer: #{local_blocks})"
    slack_web_hook.post(msg)
  end

  def blockchain_latest_block_get
    BlockchainLatestBlockGet.new
  end

  def bitcoind_getblockcount
    BitcoindGetblockcount.new
  end

  def slack_web_hook
    SlackWebHook.new
  end
end
