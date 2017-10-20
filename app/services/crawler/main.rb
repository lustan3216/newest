require 'open-uri'

class Crawler::Main

  attr_reader :website, :url, :host
  attr_accessor :episode, :result, :dom

  def initialize(website)
    @website = website
    @url     = website.url
    @episode = website.current_episode
    @host    = deal_host
    @result  = []
    @dom     = Nokogiri::HTML(open(url))

    redis_set_title
  end

  # def perform
  #   update && fetch_data
  # end
  #
  # def fetch_data
  #   keys = $redis.keys("#{url}*")
  #   keys.each { |episode| save_result(episode, $redis.get(key)) }
  #   result
  # end

  def update
    if redis_get_end_url
      update_next

    elsif node.present?
      link = node_link(node)
      save_result(episode, link)
      redis_set_end_url(link)
      update_next

    end
  end

  private

  def node
    dom.xpath("//a[contains(text(), '#{episode}')]")
  end

  def update_next
    self.episode += 1
    update
  end

  def node_link(node)
    host + node.attribute('href').value
  end

  def redis_get_end_url
    $redis.get("#{url}:episode:#{episode}")
  end

  def redis_set_end_url(link)
    $redis.set("#{url}:episode:#{episode}", link)
  end

  def redis_set_title
    $redis.set("#{url}:title", dom.search('title').text)
  end

  def save_result(episode, link)
    self.result << Hash[episode, link]
  end

  def deal_host
    "#{URI(url).scheme}://#{URI(url).host}"
  end

end