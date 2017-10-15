class WebsitesController < ApplicationController

  def index
    @websites = current_user.websites.order('created_at desc')

    respond_to do |format|
      format.html
      format.json do
        render json: serialize_data(@websites, WebsiteSerializer)
      end
    end
  end

  def create
    website = current_user.websites.new(website_params)
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
    params.require(:website).permit(:url, :keyword)
  end
end
