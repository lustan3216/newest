class Websites::CurrentEpisodesController < ApplicationController
  before_action :find_website


  def update
    @website.assign_attributes(current_episode: params[:episode])
    unless @website.save
      render json: { messages: @website.errors.full_messages.join(', ') }
    end
  end

  private

  def find_website
    @website = current_user.websites.find(params[:website_id])
  end

end
