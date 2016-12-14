require './lib/modules/roadmap'
require 'httparty'
require 'json'

class Kele

  include HTTParty
  include Roadmap

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

  def get_messages(page = nil)
    if page == nil
      total_pages = (JSON.parse(self.class.get("/message_threads", headers: { "authorization" => @auth_token }).body)["count"])/10+1
      @get_messages = (1..total_pages).map{ |n| JSON.parse(self.class.get("/message_threads", body: { page: n }, headers: { "authorization" => @auth_token }).body) }
    else
      @get_messages = JSON.parse(self.class.get("/message_threads", body: { page: page }, headers: { "authorization" => @auth_token }).body)
    end
  end

  def create_message(recipient_id, subject, message)
    puts self.class.post('/messages', body: { "user_id": @user_data["id"], "recipient_id": recipient_id, "subject": subject, "stripped-text": message }, headers: { "authorization" => @auth_token })
  end

end

class InvalidError < StandardError
  def initialize(msg="Invalid login credentials")
    super
  end
end
