require "spec_helper"

describe ContactMailer do
  describe '#contact_email' do
    let(:params) { {email: 'teste@mailinator.com', message: 'this is a message'} }
    let(:mail) { ContactMailer.contact_email(params) }

    it 'should have correct from' do
      expect(mail.from).to eql(['teste@mailinator.com'])
    end

    it "should set right subject" do
      expect(mail.subject).to eq("Email de contato - Dungeon Masters")
    end

    it 'should show informations on the email body' do
      expect(mail.body.encoded).to match(/#{params[:email]}/)
      expect(mail.body.encoded).to match(/#{params[:message]}/)
    end
  end
end
