# Cross-Data Center Replication (XDCR) Simulator in Sinatra

**When working**, can be used to "do stuff" with documents as they are streamed through XDCR to Sinatra. Still a work in progress...

# Pre-Requisites

```ruby
gem 'sinatra'
gem 'sinatra-basicauth'
gem 'json'
gem 'active_support' # for generating UUID's
```

# Usage

```bash
$ git clone git@github.com:scalabl3/xdcr-sinatra.git
$ cd xdcr-sinatra
$ ruby xdcr.rb
```

  1. In Couchbase Web Admin, click on XDCR Tab
  2. Click on Create Cluster Reference Button
  3. Create a name, and Add host and port (i.e. 127.0.0.1:4567)
  4. Enter your u: Administrator p: [your password]
  5. Click Done
  
#### Right now not everything is working for the Cluster Reference to work all the way through the Registration Process

# Couchbase Requests supported: #

**WORKING**

- /pools (GET)
- /pools/default (GET)
- /pools/default/buckets (GET) 
- /pools/default/buckets/{bucket} (GET) 
- /{database} (HEAD, GET)
- /{database}/{vbucket};{uuid}
- /{database}/master/{vbucket};{uuid}
- /{database}/{docid} (GET)

- /{database}/_ensure_full_commit (POST)
- /{database}/_revs_diff (POST) **GETTING STUCK HERE on the Response**
- /{database}/_bulk_docs (POST)

# Currently Working on... #

***Current Error***
Error replicating vbucket 965: 

```javascript
{{nocatch, {bad_request, <<"Invalid rev format">>}}, [{couch_doc,parse_rev,1}, {couch_api_wrap, '-get_missing_revs/2-fun-0-', 1}, {lists,map,2}, {couch_api_wrap, '-get_missing_revs/2-fun-1-', 3}, {xdc_vbucket_rep_worker, find_missing,2}, {xdc_vbucket_rep_worker, queue_fetch_loop,4}]}
```