require 'open-uri'
require 'openssl'
CrawlerUserAgent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE