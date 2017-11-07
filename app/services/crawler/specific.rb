class Crawler::Specific

  EXTRACT_EXPRESS = %w[head script style footer *[contains(@class,'footer')]].freeze
  attr_reader :website, :main_url, :dom, :rdb, :keyword

  def initialize(website)
    @website  = website
    @main_url = website.url
    @keyword  = website.keyword
    @dom      = Nokogiri::HTML(open(main_url, OPENURL_SETTING))
    @rdb      = Rdb::Website.new(website)

    store_main_url_title
  end

  def save
    rdb.sub_url_dom = extract_dom
    check
  end

  def check
    extracted_dom = extract_dom
    notify if rdb.sub_url_dom == extracted_dom && extracted_dom.include?(keyword)
  end

  def notify

  end

  private

  def extract_dom
    EXTRACT_EXPRESS.each { |e| dom.xpath("//#{e}").remove() }
    dom.xpath('//text()').to_s.gsub(/\s/, '')
  end

  def store_main_url_title
    rdb.main_url_title = dom.search('title').text
  end

end