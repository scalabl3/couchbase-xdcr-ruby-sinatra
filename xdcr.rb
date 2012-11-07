require 'sinatra'
require 'sinatra/basic_auth'
require 'json'
require 'active_support'

#set :server, 'webrick'

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
1024.times { VBucketMap << [0,1] }
#puts VBucketMap.size



get '/pools' do
  require_basic_auth
  content_type :json
  
  #5.times { puts }
  #puts 'GET requested /pools'
  #puts params.inspect
  
  out = {
    :pools => [ {
      :name => "default",
      :uri => "/pools/default?uuid=#{UUID_POOL}",      
    } ],
    :uuid => UUID_POOL
  }
  
  #puts out.to_json
  out.to_json
end




get '/pools/default' do
  require_basic_auth
  content_type :json
  
  #5.times { puts }
  #puts 'GET requested /pools/default'
  #puts params.inspect
  
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
      
  #puts out.to_json
  out.to_json
end




get '/pools/default/buckets' do
  require_basic_auth
  content_type :json
  
  #5.times { puts }
  #puts 'GET requested /pools/default/buckets'
  #puts params.inspect
  
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
      :uuid => UUID_BUCKET,
      :uri => "/pools/default/buckets/#{XDCR_BUCKET}?bucket_uuid=#{UUID_BUCKET}"
    }
  ]
  
  #puts out.to_json
  out.to_json
end




get '/pools/default/buckets/:bucket' do
  require_basic_auth
  content_type :json
  
  #5.times { puts }
  #puts "GET requested /pools/buckets/#{params[:bucket]}"

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
      :uuid => UUID_BUCKET,
      :uri => "/pools/default/buckets/#{XDCR_BUCKET}?bucket_uuid=#{UUID_BUCKET}"
    }
  ]
  
  #puts out.to_json
  out.to_json
end


# matches 
#/default%2b602%3b9e4d14d5a9be45cba5ec5534f42e129b
#/default/602;9e4d14d5a9be45cba5ec5534f42e129b
vbucket_regex = %r{[\/]([\w]+)([\/]|%2f)([\d]+)([;]|%3b)([\w]+)}

head vbucket_regex do 
  require_basic_auth
  content_type :json
  
  #params[:captures].each_with_index do |c,i|
  #  puts "capture[#{i}] = #{c}"
  #end
  #puts params.inspect
  
  result = response_db_vbucket("HEAD", params[:captures][0], params[:captures][2].to_i, params[:captures][4])
  status result[0]
end




get vbucket_regex do  
  require_basic_auth
  content_type :json
  
  #params[:captures].each_with_index do |c,i|
  #  puts "capture[#{i}] = #{c}"
  #end
  #puts params.inspect
  
  result = response_db_vbucket("GET", params[:captures][0], params[:captures][2].to_i, params[:captures][4])
  status result[0]
  
  result_hash = { :db_name => XDCR_BUCKET }

  if result[0].to_i == 200 
    return result_hash.to_json
  else
    return nil
  end
end



#encapsulate GET and HEAD request results
def response_db_vbucket(method, database, vbucket_number, uuid)
    
  #5.times { puts }
  #puts "#{method} requested [database] /#{database}/#{vbucket_number};#{uuid}"
    
  if database == XDCR_BUCKET 
    return [200]
  else
    return [404]
  end
end






vbucket_master_regex = %r{[\/]([\w]+)([\/]|%2f|%2F)([\w]+)([;]|%3b|%3B)([\w]+)}

head vbucket_master_regex do 
  require_basic_auth
  content_type :json

  #params[:captures].each_with_index do |c,i|
  # puts "capture[#{i}] = #{c}"
  #end
  #puts params.inspect

  result = response_db_master("HEAD", params[:captures][0], params[:captures][2], params[:captures][4])
  status result[0]
end

get vbucket_master_regex do 
  require_basic_auth
  content_type :json
  
  #params[:captures].each_with_index do |c,i|
  #  puts "capture[#{i}] = #{c}"
  #end
  #puts params.inspect
  
  result = response_db_master("GET", params[:captures][0], params[:captures][2], params[:captures][4])
  status result[0]
  
  result_hash = { :db_name => XDCR_BUCKET }

  if result[0].to_i == 200 
    return result_hash.to_json
  else
    return nil
  end
end


#encapsulate GET and HEAD request results
def response_db_master(method, database, master, uuid)
    
  #5.times { puts }
  #puts "#{method} requested [database] /#{database}/#{master};#{uuid}"
    
  if database == XDCR_BUCKET 
    return [200]
  else
    return [404]
  end
end


revs_diff_regex = %r{[\/]([\w]+)([\/]|%2f|%2F)([\w]+)([;]|%3b|%3B)([\w]+)[\/](_revs_diff)}

post revs_diff_regex do  #(POST)
  require_basic_auth
  content_type :json
  
  5.times { puts }
  puts "POST requested [database] /_revs_diff"
  #puts "POST requested [database] /#{params[:captures][0]}/_revs_diff"
  #puts params.class.to_s
  #json = JSON.parse(params[0][0]) if params && params[0]

  #print "json: "
  #puts json.inspect
  #puts request.body.inspect
  
  request.body.rewind  # in case someone already read it
  raw_data = request.body.read
  data = JSON.parse raw_data
  puts raw_data
  #puts data.inspect
  puts
  
  
  out = {} # "03ee06461a12f3c288bb865b22000170": {"missing": ["2-3a24009a9525bde9e4bfa8a99046b00d"]} }
  data.each_pair do |k,v|
    out[k] = { :missing => v }
  end
  
  #params.each_pair do |k,v|
  #  puts "v[#{k}] = #{v}"
  #end
  
  status 200
  
  puts "RESPONSE: #{out.to_json}"
  out.to_json
end



ensure_commit_regex = %r{[\/]([\w]+)([\/]|%2f|%2F)([\w]+)([;]|%3b|%3B)([\w]+)[\/](_ensure_full_commit)}

post ensure_commit_regex do  #(POST)
  require_basic_auth
  content_type :json
  
  5.times { puts }
  #puts params.inspect
  puts "POST requested [database] /_ensure_full_commit"
  status 201

  out = { :ok => true }
  
  #puts out.to_json
  out.to_json
end


bulk_docs_regex = %r{[\/]([\w]+)([\/]|%2f|%2F)([\w]+)([;]|%3b|%3B)([\w]+)[\/](_bulk_docs)}

post bulk_docs_regex do #(POST)
  require_basic_auth
  content_type :json
  
  5.times { puts }
  puts "POST requested [database] /_bulk_docs"
  #puts "POST requested [database] /#{params[:database]}/_bulk_docs"
  
  request.body.rewind  # in case someone already read it
  data = JSON.parse request.body.read
  puts data.inspect
  
  status 201
  
  nil
end

=begin

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




get '/*' do
  puts "(GET) NO MATCH"
end

head '/*' do
  puts "(HEAD) NO MATCH"
end


=end