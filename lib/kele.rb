require 'httparty'

class Kele

  include HTTParty

  base_uri "https://www.bloc.io/api/v1"

  def initialize(email, password)
    options = {
      body: {
        email: email,
        password: password
      }
    }

    @auth_token = self.class.post('/sessions', options)['auth_token']
    raise InvalidError unless @auth_token
  end

end

class InvalidError < StandardError
  def initialize(msg="Invalid login credentials")
    super
  end
end
