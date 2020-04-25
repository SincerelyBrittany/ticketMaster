require_relative "ticketMasterApp/version"

require 'open-uri'
require 'HTTParty'
require 'net/http'
require 'json'
require 'pry'
require_relative "../secret"
require_relative "./cli"
require_relative "./apiManager"
require_relative "./ticketMasterScraper"


module TicketMasterApp
  class Error < StandardError; end
  # Your code goes here...
end
