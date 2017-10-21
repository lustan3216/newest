require 'open-uri'

class Crawler::Website

  attr_reader :website, :main_url, :dom, :rdb, :host
  attr_accessor :current_episode

  def initialize(website)
    @website         = website
    @main_url        = website.url
    @host            = parse_host
    @dom             = Nokogiri::HTML(open(url))
    @rdb             = Rdb::Website.new(main_url)
    @current_episode = website.current_episode

    store_main_url_title
  end

  def update
    if rdb.sub_url_exist?(current_episode)
      next_episode

    elsif current_node.present?
      link  = node_link(current_node)
      title = node_text(current_node)
      rdb.add_sub_url(Hash[current_episode, link])
      rdb.add_sub_url_title(Hash[current_episode, title])
      next_episode

    end
  end

  private

  def current_node
    dom.xpath("//a[contains(text(), '#{current_episode}')]")
  end

  def node_link(node)
    host + node.attribute('href').value
  end

  def node_text(node)
    node.text
  end

  def next_episode
    self.current_episode += 1
    update
  end

  def store_main_url_title
    rdb.main_url_title = dom.search('title').text
  end

  def parse_host
    "#{URI(url).scheme}://#{URI(url).host}"
  end

end

# 先用keyword 檢查 用全部的字檢查，檢查出來網址拿前面那段去找所有的網址，再把所有網址跟原始網址的class比對