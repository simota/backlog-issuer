# coding: utf-8
require 'thor'

module BacklogIssuer
  class CLI < Thor
    desc "exec", "" # コマンドの使用例と、概要
    option :space, type: :string, aliases: '-s', desc: 'backlog space name', required: true
    option :projectkey, type: :string, aliases: '-p', desc: 'target project key', required: true
    option :apikey, type: :string, aliases: '-k', desc: 'your api key', required: true
    option :csvfile, type: :string, aliases: '-f', desc: 'csv file path', required: true

    def exec
      client = BacklogIssuer::Client.new(options[:space], options[:apikey])
      client.project_key = options[:projectkey]
      parser = BacklogIssuer::Parser.new(options[:csvfile])
      issuer = BacklogIssuer::Issuer.new(client, parser)
      issuer.execute
    end
  end
end
