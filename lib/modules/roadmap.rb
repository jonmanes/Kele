module Roadmap
  def get_roadmap()
    roadmap_id = @user_data["current_enrollment"]["roadmap_id"]
    @roadmap_data = JSON.parse(self.class.get("/roadmaps/#{roadmap_id}", body: { id: roadmap_id },headers: { "authorization" => @auth_token }).body)
  end

  def get_checkpoint(checkpoint_id) #Used 2158 for testing --> Retrieve Users
    @checkpoint_data = JSON.parse(self.class.get("/checkpoints/#{checkpoint_id}", headers: { "authorization" => @auth_token }).body)
  end
end
