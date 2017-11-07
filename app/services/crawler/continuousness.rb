require 'open-uri'

class Crawler::Continuousness

  attr_reader :website, :main_url, :dom, :rdb, :host, :pattern,
              :keyword, :keyword_url

  attr_accessor :current_episode

  def initialize(website)
    @website     = website
    @main_url    = website.url
    @pattern     = website.pattern
    @keyword     = website.keyword
    @keyword_url = website.keyword_url
    @host        = parse_host
    @dom         = Nokogiri::HTML(open(main_url))
    @rdb         = Rdb::Website.new(website)

    store_main_url_title
  end

  def keyword_urls
    dom.xpath("//a[contains(text(), '#{keyword}')]").map do |x|
      { url: host + x.attr('href').to_s, text: x.text }
    end
  end

  def update
    episode_list = []
    link_nodes.each do |node|
      episode = fetch_episode(node)
      episode_list << episode
      rdb.add_sub_url(Hash[episode, host + node[:href].to_s])
      rdb.add_sub_url_title(Hash[episode, node.text])
    end

    rdb.sub_url_newest = episode_list.max
  end

  private

  def fetch_episode(node)
    node.text.match(/(\d+)/)[-1]
  end

  def link_nodes
    comparison = URI(main_url).path.match(/(\/.+)\/.+/).to_a.second
    dom.xpath("//a[contains(@href, '#{comparison}')]").select do |e|
      parent_comparision(major, e, 3) && text_comparision(major, e)
    end
  end

  def text_comparision(main, sub)
    (first_word(main) ? first_word(main) == first_word(sub) : true) &&
      (last_word(main) ? last_word(main) == last_word(sub) : true)
  end

  def first_word(node)
    node.text.strip.match(/^[^\d\s]/).to_a[0]
  end

  def last_word(node)
    node.text.strip.match(/[^\d\s]$|mp4|avi|MKV|mp3|mpeg|mpg|m4v|mov|rm|wmv/).to_a[0]
  end

  def parent_comparision(main, sub, layers)
    [*1..layers].all? { |x| parent_name(main, x, true) == parent_name(sub, x) }
  end

  def parent_name(main, layer, cache = false)
    cache_name = instance_variable_get("@c#{main.__id__}_#{layer}")
    return cache_name if cache_name
    tmp = main
    layer.times { tmp = tmp.parent }
    instance_variable_set("@c#{main.__id__}_#{layer}", tmp.name) if cache
    tmp.name
  end

  def major
    dom.xpath("//a[contains(@href, '#{ URI(keyword_url).path }')]").first
  end

  def store_main_url_title
    rdb.main_url_title = dom.search('title').text
  end

  def parse_host
    "#{URI(main_url).scheme}://#{URI(main_url).host}"
  end

end