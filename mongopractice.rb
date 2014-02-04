# -*- coding: utf-8 -*-

require 'mongo'

conn = Mongo::Connection.new

puts 'databases'
puts conn.database_names
