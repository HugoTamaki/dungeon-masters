class ContactMailer < ActionMailer::Base
  default from: 'no-reply@dungeonmasters.com.br'
 
  def contact_email(params)
    @from_email = params[:email]
    @message = params[:message]
    mail(from: @from_email, to: ENV["mail_to"], subject: 'Email de contato - Dungeon Masters')
  end
end
