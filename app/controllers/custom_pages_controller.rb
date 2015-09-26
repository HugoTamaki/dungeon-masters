class CustomPagesController < ApplicationController
  def index
    @stories = Story.published.last(8)
  end

  def contact

  end

  def send_message
    unless params[:email].empty? && params[:message].empty? && params[:howdy].nil?
      ContactMailer.contact_email(params).deliver
      redirect_to :back, notice: "Contato enviado!"
    else
      redirect_to :back, alert: "Preencha corretamente os dados."
    end
  end
end
