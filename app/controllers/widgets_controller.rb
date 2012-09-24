class WidgetsController < ApplicationController
  def new
  end

  def create
    @widget = Widget.new(params[:widget])
    if @widget.save
      render :show
    else
      render :new
    end
  end
end
