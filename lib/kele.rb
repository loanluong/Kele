require 'httparty'
require './lib/roadmap.rb'

class Kele
  include HTTParty
  include JSON
  include Roadmap

  def initialize(email, password)
    response = self.class.post('https://www.bloc.io/api/v1/sessions', body: { email: email, password: password })
    if response.code != 200
      raise "Error!!"
    end
    @auth_token = response["auth_token"]
  end

  def get_me
    response = self.class.get('https://www.bloc.io/api/v1/users/me', headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get('https://www.bloc.io/api/v1/mentors/'+(mentor_id.to_s)+'/student_availability', headers: { "authorization" => @auth_token })
    JSON.parse(response.body).to_a
  end

  def get_messages(*page)
    response = self.class.get('https://www.bloc.io/api/v1/message_threads', headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end

  def create_messages(sender, recipient_id, subject, stripped_text)
    response = self.class.post('https://www.bloc.io/api/v1/messages', body: { sender: sender, recipient_id: recipient_id, subject: subject, stripped_text: stripped_text }, headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end
end
