require 'httparty'

class Kele
  include HTTParty
  include JSON


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
    response = self.class.get('https://www.bloc.io/api/v1/mentors/'+(mentor_id.to_s)+'/student_availability', headers: { "authorization" => @auth_token})
    JSON.parse(response.body).to_a
  end
end
