class PagesController < ApplicationController

  def index
    render 'index', layout: 'pages'
  end
  def success 
    render 'success', layout: 'pages'
  end
  def fail
    render 'fail', layout: 'pages'
  end

end
