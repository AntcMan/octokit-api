class PagesController < ApplicationController
  def form_page
    render partial: 'shared/form'
  end
end
