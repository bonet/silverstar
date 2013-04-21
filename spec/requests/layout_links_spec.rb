require 'spec_helper'

describe "LayoutLinks" do
  
  describe "GET /layout_links" do
    
    it"should have a Home page at '/'" do
      get '/'
      expect(response).to have_selector('title', :content => "Home")
    end
    
    it"should have a Contact page at '/contact'" do
      get '/contact'
      expect(response).to have_selector('title', :content => "Contact Us")
    end
    
    it"should have a About page at '/about'" do
      get '/about'
      expect(response).to have_selector('title', :content => "About Us")
    end
    
    it "should have a signup page at '/signup'" do
      get 'signup'
      response.should have_selector('title', :content => "Sign Up")
    end
  end
end
