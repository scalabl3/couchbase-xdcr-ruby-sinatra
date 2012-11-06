require 'sinatra'
require 'sinatra/basic_auth'
require 'json'
require 'active_support'



basic_auth do
  realm 'Give me password!'
  username 'Administrator'
  password 'ababab'
end



XDCR_RECEIVER = "127.0.0.1"
XDCR_PORT = 4567
XDCR_BUCKET = "default"
UUID_POOL = "3b5211459ec34c589522f78c2284099e" #SecureRandom.uuid.gsub("-", "")
UUID_BUCKET = "9e4d14d5a9be45cba5ec5534f42e129b" #SecureRandom.uuid.gsub("-", "")
VBucketMap = []
1024.times { VBucketMap << [0,-1] }




get '/pools' do
  require_basic_auth
  content_type :json
  
  5.times { puts }
  puts 'GET requested /pools'
  puts params.inspect
  
  out = {
    :pools => [ {
      :name => "default",
      :uri => "/pools/default?uuid=#{UUID_POOL}",      
    } ],
    :uuid => UUID_POOL
  }
  
  puts out.to_json
  out.to_json
end




get '/pools/default' do
  require_basic_auth
  content_type :json
  
  5.times { puts }
  puts 'GET requested /pools/default'
  puts params.inspect
  
  out = {    
    :buckets => { :uri => "/pools/default/buckets?uuid=#{UUID_POOL}" },        
    :nodes => [ {
        :ports => {
          :direct => XDCR_PORT
        },
        :couchApiBase => "http://#{XDCR_RECEIVER}:#{XDCR_PORT}/",
        :hostname => "#{XDCR_RECEIVER}:#{XDCR_PORT}"
    } ]
  }
      
  puts out.to_json
  out.to_json
end




get '/pools/default/buckets' do
  require_basic_auth
  content_type :json
  
  5.times { puts }
  puts 'GET requested /pools/default/buckets'
    
  out = [
    {
      :bucketCapabilities => [ "couchapi" ],
      :bucketType => "membase",
      :nodes => [ {
          :ports => { :direct => XDCR_PORT },
          :couchApiBase => "http://#{XDCR_RECEIVER}:#{XDCR_PORT}/#{XDCR_BUCKET}",
          :hostname => "#{XDCR_RECEIVER}:#{XDCR_PORT}"
      } ],
      :name => XDCR_BUCKET,
      :vBucketServerMap => {
        :serverList => [ "#{XDCR_RECEIVER}:#{XDCR_PORT}" ],
        :vBucketMap => VBucketMap
      },
      :uuid => "00000000000000000000000000000000",
      :uri => "/pools/default/buckets/#{XDCR_BUCKET}?bucket_uuid=00000000000000000000000000000000"
    }
  ]
  
  puts out.to_json
  out.to_json
end




get '/pools/default/buckets/:bucket' do
  require_basic_auth
  content_type :json
  
  5.times { puts }
  puts "GET requested /pools/buckets/#{params[:bucket]}"

  out = [
    {
      :bucketCapabilities => [ "couchapi" ],
      :bucketType => "membase",
      :nodes => [ {
          :ports => { :direct => XDCR_PORT },
          :couchApiBase => "http://#{XDCR_RECEIVER}:#{XDCR_PORT}/#{XDCR_BUCKET}",
          :hostname => "#{XDCR_RECEIVER}:#{XDCR_PORT}"
      } ],
      :name => XDCR_BUCKET,
      :vBucketServerMap => {
        :serverList => [ "#{XDCR_RECEIVER}:#{XDCR_PORT}" ],
        :vBucketMap => vBucketMap
      },
      :uuid => "00000000000000000000000000000000",
      :uri => "/pools/default/buckets/#{XDCR_BUCKET}?bucket_uuid=00000000000000000000000000000000"
    }
  ]
  
  puts out.to_json
  out.to_json
end




get '/:database' do #(HEAD, GET)
  require_basic_auth
  content_type :json
  
  5.times { puts }
  puts "GET requested [database] /#{params[:database]}"
  
  
  
  if params[:database] == XDCR_BUCKET 
    out = { :db_name => XDCR_BUCKET }
    status 200
    
    puts out.to_json
    out.to_json
  else
    status 404
    nil
  end
end




get '/:database/:docid' do #(GET)
  require_basic_auth
  content_type :json
  
  5.times { puts }
  puts "GET requested [database] /#{params[:database]}/#{params[:docid]}"
  
  if params[:database] == XDCR_BUCKET 
    status 200
    nil
  else
    status 404
    nil
  end
end




post '/:database/_ensure_full_commit' do  #(POST)
  require_basic_auth
  content_type :json
  
  5.times { puts }
  puts "POST requested [database] /#{params[:database]}/_ensure_full_commit"
  status 201

  out = { :ok => true }
  
  puts out.to_json
  out.to_json
end




post '/{database}/_revs_diff' do  #(POST)
  require_basic_auth
  content_type :json
  
  5.times { puts }
  puts "POST requested [database] /#{params[:database]}/_revs_diff"
  status 201
  
  nil
end




post '/:database/_bulk_docs' do #(POST)
  require_basic_auth
  content_type :json
  
  5.times { puts }
  puts "POST requested [database] /#{params[:database]}/_bulk_docs"
  status 201
  
  nil
end
