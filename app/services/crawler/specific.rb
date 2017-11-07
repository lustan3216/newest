require 'open-uri'

class Crawler::Specific

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

end