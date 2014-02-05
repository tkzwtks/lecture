require 'sinatra'
require 'mongo'
require 'json/ext'
require 'uri'

include Mongo

configure do 
  # @see https://devcenter.heroku.com/articles/mongohq#adding-a-mongohq-database
  db = URI.parse(ENV['MONGOHQ_URL'])
  db_name = db.path.gsub(/^\//, '')
  conn = Mongo::Connection.new(db.host, db.port)
  conn.db(db_name).authenticate(db.user, db.password)

  set :mongo_conn, conn
  set :mongo_db, conn.db(db_name)
  set :coll, conn.db(db_name).collection('test_coll')
end

helpers do
  def object_id val
    BSON::ObjectId.from_string(val)
  end

  def document_by_id id
    id = object_id(id) if String === id
    settings.coll.find_one(:_id => id).to_json
  end

  def document_by_type type
    settings.coll.find_one(:type => type).to_json
  end
end

get '/' do
  content_type :json
  settings.coll.find.to_a.to_json
end

get '/type/:type/?' do
  content_type :json
  document_by_type(params[:type])
end
