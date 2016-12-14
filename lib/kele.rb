require 'httparty'
require 'json'

class Kele

  include HTTParty

  base_uri "https://www.bloc.io/api/v1"

  def initialize(email, password)
    @auth_token = self.class.post('/sessions', body: { email: email, password: password })['auth_token']
    raise InvalidError unless @auth_token
  end

  def get_me()
    @user_data = JSON.parse(self.class.get('/users/me', headers: { "authorization" => @auth_token }).body)
  end

  def get_mentor_availability()
    mentor_id = @user_data["current_enrollment"]["mentor_id"]
    @mentor_availability_data = JSON.parse(self.class.get("/mentors/#{mentor_id}/student_availability", body: { id: mentor_id },headers: { "authorization" => @auth_token }).body)
  end

end

class InvalidError < StandardError
  def initialize(msg="Invalid login credentials")
    super
  end
end
