class ImagesController < ApplicationController
  before_action :authenticate_user!

  def destroy
    flag = true
    image = Image.find_by id: params[:image_id]
    image.nil? ? flag = false : image.destroy
    respond_to do |format|
      format.json{render json: {status: flag}}
    end
  end
end
