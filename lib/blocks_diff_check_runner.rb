require 'dotenv'
require_relative 'blocks_diff_checker'

class BlocksDiffCheckRunner
  def self.run
    Dotenv.load("../.env")
    BlocksDiffChecker.new.execute
  end
end
