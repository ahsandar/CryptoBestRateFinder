require 'bundler/setup'
require 'pry'
require_relative 'price/price'
require_relative 'price/price_node'
require_relative 'price/price_edge'
require_relative 'price/price_graph'
require_relative 'exchange/currency_source_exchange'
require_relative 'exchange/currency_destination_exchange'
require_relative 'exchange/exchange_rate'
require_relative 'exchange/best_rate'
require_relative 'crypto_exceptions'
require_relative 'crypto_exchange'

CryptoExchange.run
