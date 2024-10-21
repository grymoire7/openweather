require 'rails_helper'

RSpec.describe HomeController, type: :request do
  describe "GET #index" do
    it "returns http success" do
      address = "1 Infinite Loop, Cupertino, CA 95014"
      get root_url, params: { address: address }
      expect(response).to have_http_status(:success)
    end
  end
end
