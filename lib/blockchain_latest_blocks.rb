require 'net/http'
require 'json'

class BlockchainLatestBlockGet
  def get
    JSON.parse(Net::HTTP.get(URI.parse('https://blockchain.info/latestblock')))
  end
end

class BitcoindGetblockcount
  def get
    JSON.parse(Net::HTTP.get(URI.parse('http://localhost:8332/rest/chaininfo.json')))
  end
end
