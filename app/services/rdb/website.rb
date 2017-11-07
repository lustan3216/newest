class Rdb::Website

  attr_reader :main_url, :redis, :keyword

  def initialize(website)
    @redis    = $redis
    @main_url = website.url
    @keyword  = website.keyword
  end

  # sub-url / sub-url-title / main-url = { 'episodes1': 'url1',  'episodes2': 'url2' }

  def episodes
    redis.hkeys("#{main_url}:sub-url-title")
  end

  def main_url_title
    redis.get("#{main_url}:main-url-title")
  end

  def main_url_title=(value)
    redis.set("#{main_url}:main-url-title", value)
  end

  def sub_url_exist?(key)
    redis.hexists("#{keyword}:#{main_url}:sub-url-title", key)
  end

  def sub_url_title(key)
    redis.hget("#{keyword}:#{main_url}:sub-url-title", key)
  end

  def sub_urls_title
    redis.hgetall("#{keyword}:#{main_url}:sub-url-title")
  end

  def add_sub_url_title(hash)
    redis.hset("#{keyword}:#{main_url}:sub-url-title", hash.keys[0], hash.values[0])
  end

  def sub_url(key)
    redis.hget("#{keyword}:#{main_url}:sub-url", key)
  end

  def sub_urls
    redis.hgetall("#{keyword}:#{main_url}:sub-url")
  end

  def add_sub_url(hash)
    redis.hset("#{keyword}:#{main_url}:sub-url", hash.keys[0], hash.values[0])
  end

end