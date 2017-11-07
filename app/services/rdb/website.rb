class Rdb::Website

  attr_reader :main_url, :redis, :keyword

  def initialize(website)
    @redis    = $redis
    @main_url = website.url
    @keyword  = website.keyword
    @pattern  = website.pattern
  end

  # sub-url / sub-url-title / main-url = { 'episodes1': 'url1',  'episodes2': 'url2' }

  # def episodes
  #   redis.hkeys("#{main_url}:sub-url-title")
  # end

  def main_url_title
    redis.get("#{main_url}:main-url-title")
  end

  def main_url_title=(value)
    redis.set("#{main_url}:main-url-title", value)
  end

  def sub_url_key
    "#{keyword}:#{pattern}:#{main_url}:sub-url"
  end

  def sub_url_newest
    redis.set("#{sub_url_key}-newest")
  end

  def sub_url_newest=(value)
    redis.set("#{sub_url_key}-newest", value)
  end

  def sub_url(key)
    redis.hget(sub_url_key, key)
  end

  def sub_urls
    redis.hgetall(sub_url_key)
  end

  def add_sub_url(hash)
    redis.hset(sub_url_key, hash.keys[0], hash.values[0])
  end

  def sub_url_exist?(key)
    redis.hexists("#{sub_url_key}-title", key)
  end

  def sub_url_title(key)
    redis.hget("#{sub_url_key}-title", key)
  end

  def sub_urls_title
    redis.hgetall("#{sub_url_key}-title")
  end

  def add_sub_url_title(hash)
    redis.hset("#{sub_url_key}-title", hash.keys[0], hash.values[0])
  end

end