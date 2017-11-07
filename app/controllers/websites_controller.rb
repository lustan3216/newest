class WebsitesController < ApplicationController

  def index
    websites = current_user&.websites&.order('created_at desc')

    respond_to do |format|
      format.html
      format.json { render json: serialize_data(websites, WebsiteSerializer) }
    end
  end

  def create
    website = current_user.websites.new(website_params)

    if current_user.websites.find_by_url(website_params[:url])
      render json: { messages: 'already have' } and return
    end

    begin
      open(website.main_url, OPENURL_SETTING)
    rescue
      render json: { messages: 'this website is blocked' } and return
    end

    if website_params[:keyword_url].blank? && website.continuousness?
      keyword_urls = Crawler::Website.new(website).keyword_urls

      case keyword_urls.to_a.size
      when 0
        render json: { data: keyword_urls, type: 'not_found' } and return
      when 1
        website.keyword_url = keyword_urls.first[:url]
      else
        render json: { data: keyword_urls, type: 'keyword_urls' } and return
      end
    end

    if website.save
      render json: serialize_data(website, WebsiteSerializer)
    else
      render json: { messages: website.errors.full_messages.join(', ') }
    end
  end

  def destroy
    current_user.websites.find(params[:id]).delete
  end

  private

  def website_params
    params.require(:website).permit(:url, :keyword, :pattern, :keyword_url)
  end
end
