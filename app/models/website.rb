class Website < ApplicationRecord

  belongs_to :user

  validates_presence_of :keyword, :url
  validates_presence_of :keyword_url, if: -> { continuousness? }
  validates :url, uniqueness: { scope: :user_id }, on: :create

  before_save :strip_column
  before_create :assign_current_episode
  after_commit :crawl_data, on: :create

  enum pattern: { specific: 0, continuousness: 1 }

  def rdb
    Rdb::Website.new(self)
  end

  def title
    rdb.main_url_title
  end

  def sub_urls
    not_yet_seen(rdb.sub_urls)
  end

  def sub_urls_title
    not_yet_seen(rdb.sub_urls_title)
  end

  def not_yet_seen(hash)
    hash.select { |k, v| k.to_s.to_i >= current_episode }
  end

  private

  def assign_current_episode
    if continuousness?
      episode = keyword.match(/(\d+)/)[-1]
      assign_attributes(current_episode: episode.strip)
    end
  end

  def strip_column
    assign_attributes(url: url&.strip,
                      keyword: keyword&.strip,
                      keyword_url: keyword_url&.strip)
  end

  def crawl_data
    if continuousness?
      Crawler::Continuousness.new(self).update
    elsif specific?
      Crawler::Specific.new(self).save
    end
    update_column(:crawled_at, Time.current)
  end

end