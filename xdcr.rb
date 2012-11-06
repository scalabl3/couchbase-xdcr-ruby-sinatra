require 'sinatra'
require 'sinatra/basic_auth'
require 'json'
require 'active_support'

basic_auth do
  realm 'Give me password!'
  username 'Administrator'
  password 'ababab'
end

UUID_POOL = "3b5211459ec34c589522f78c2284099e" #SecureRandom.uuid.gsub("-", "")
UUID_BUCKET = "9e4d14d5a9be45cba5ec5534f42e129b" #SecureRandom.uuid.gsub("-", "")

5.times { puts }

get '/pools' do
  require_basic_auth
  content_type :json
  
  5.times { puts }
  puts 'GET requested /pools'
  puts params.inspect
  
  pool = {
    :pools => [
      {
      :name => "default",
      :uri => "/pools/default?uuid=#{UUID_POOL}",      
      }],
    :uuid => UUID_POOL
  }
  
  puts pool.to_json
  pool.to_json
end

get '/pools/default' do
  require_basic_auth
  content_type :json
  
  5.times { puts }
  puts 'GET requested /pools/default'
  puts params.inspect
  
  default_pool = {
    :name => "default",
    :buckets => { :uri => "/pools/default/buckets?uuid=#{UUID_POOL}" }    
  }
      
  puts default_pool.to_json
  default_pool.to_json
end

get '/pools/default/buckets' do
  require_basic_auth
  
  5.times { puts }
  puts 'GET requested /pools/default/buckets'
  
end

get '/pools/default/buckets/:bucket' do
  require_basic_auth
  puts "GET requested /pools/buckets/#{params[:bucket]}"

end


get '/:database' do #(HEAD, GET)
  require_basic_auth
  puts "GET requested [database] /#{params[:database]}"
  
end

get '/:database/:docid' do #(GET)
  require_basic_auth
  puts "GET requested [database] /#{params[:database]}/#{params[:docid]}"
  
end

post '/:database/_ensure_full_commit' do  #(POST)
  require_basic_auth
  puts "POST requested [database] /#{params[:database]}/_ensure_full_commit"
  
end

post '/{database}/_revs_diff' do  #(POST)
  require_basic_auth
  puts "POST requested [database] /#{params[:database]}/_revs_diff"
  
end

post '/:database/_bulk_docs' do #(POST)
  require_basic_auth
  puts "POST requested [database] /#{params[:database]}/_bulk_docs"
  
end

=begin

=begin
0: {name:Humin, bucketType:membase, authType:sasl, saslPassword:, proxyPort:0, replicaIndex:false,…}
authType: "sasl"
autoCompactionSettings: false
basicStats: {quotaPercentUsed:2.9049456119537354, opsPerSec:0, viewOps:0, diskFetches:0, itemCount:0,…}
bucketCapabilities: [touch, couchapi]
bucketCapabilitiesVer: ""
bucketType: "membase"
controllers: {flush:/pools/default/buckets/Humin/controller/doFlush,…}
ddocs: {uri:/pools/default/buckets/Humin/ddocs}
fastWarmupSettings: false
localRandomKeyUri: "/pools/default/buckets/Humin/localRandomKey"
name: "Humin"
nodeLocator: "vbucket"
nodes: [{systemStats:{cpu_utilization_rate:20.875, swap_total:9663676416, swap_used:8909201408},…}]
proxyPort: 0
quota: {ram:1073741824, rawRAM:1073741824}
replicaIndex: false
replicaNumber: 1
saslPassword: ""
stats: {uri:/pools/default/buckets/Humin/stats, directoryURI:/pools/default/buckets/Humin/statsDirectory,…}
streamingUri: "/pools/default/bucketsStreaming/Humin?bucket_uuid=ff5e6309de6095b842f101813c5c1fa3"
uri: "/pools/default/buckets/Humin?bucket_uuid=ff5e6309de6095b842f101813c5c1fa3"
uuid: "ff5e6309de6095b842f101813c5c1fa3"
vBucketServerMap: {hashAlgorithm:CRC, numReplicas:1, serverList:[127.0.0.1:11210],…}
1: {name:cbfs, bucketType:membase, authType:sasl, saslPassword:, proxyPort:0, replicaIndex:false,…}
authType: "sasl"
autoCompactionSettings: false
basicStats: {quotaPercentUsed:2.8981730341911316, opsPerSec:0, viewOps:0, diskFetches:0, itemCount:201,…}
bucketCapabilities: [touch, couchapi]
bucketCapabilitiesVer: ""
bucketType: "membase"
controllers: {flush:/pools/default/buckets/cbfs/controller/doFlush,…}
ddocs: {uri:/pools/default/buckets/cbfs/ddocs}
fastWarmupSettings: false
localRandomKeyUri: "/pools/default/buckets/cbfs/localRandomKey"
name: "cbfs"
nodeLocator: "vbucket"
nodes: [{systemStats:{cpu_utilization_rate:20.875, swap_total:9663676416, swap_used:8909201408},…}]
proxyPort: 0
quota: {ram:1073741824, rawRAM:1073741824}
replicaIndex: false
replicaNumber: 1
saslPassword: ""
stats: {uri:/pools/default/buckets/cbfs/stats, directoryURI:/pools/default/buckets/cbfs/statsDirectory,…}
streamingUri: "/pools/default/bucketsStreaming/cbfs?bucket_uuid=3fceefcf9ce939b0bdbd066cc126a703"
uri: "/pools/default/buckets/cbfs?bucket_uuid=3fceefcf9ce939b0bdbd066cc126a703"
uuid: "3fceefcf9ce939b0bdbd066cc126a703"
vBucketServerMap: {hashAlgorithm:CRC, numReplicas:1, serverList:[127.0.0.1:11210],…}
2: {name:default, bucketType:membase, authType:sasl, saslPassword:, proxyPort:0, replicaIndex:false,…}
authType: "sasl"
autoCompactionSettings: false
basicStats: {quotaPercentUsed:14.880996704101562, opsPerSec:0, viewOps:0, diskFetches:0, itemCount:6,…}
bucketCapabilities: [touch, couchapi]
bucketCapabilitiesVer: ""
bucketType: "membase"
controllers: {flush:/pools/default/buckets/default/controller/doFlush,…}
ddocs: {uri:/pools/default/buckets/default/ddocs}
fastWarmupSettings: false
=end


=begin
localRandomKeyUri: "/pools/default/buckets/default/localRandomKey"
name: "default"
nodeLocator: "vbucket"
nodes: [{systemStats:{cpu_utilization_rate:20.875, swap_total:9663676416, swap_used:8909201408},…}]
proxyPort: 0
quota: {ram:209715200, rawRAM:209715200}
replicaIndex: false
replicaNumber: 1
saslPassword: ""
stats: {uri:/pools/default/buckets/default/stats, directoryURI:/pools/default/buckets/default/statsDirectory,…}
streamingUri: "/pools/default/bucketsStreaming/default?bucket_uuid=72e8847e947a3c03748df0e155dc2760"
uri: "/pools/default/buckets/default?bucket_uuid=72e8847e947a3c03748df0e155dc2760"
uuid: "72e8847e947a3c03748df0e155dc2760"
vBucketServerMap: {hashAlgorithm:CRC, numReplicas:1, serverList:[127.0.0.1:11210],…}

=end