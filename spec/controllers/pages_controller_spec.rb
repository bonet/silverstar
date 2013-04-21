require 'spec_helper'

describe PagesController do
  render_views
  
  
  before(:each) do
    @base_title = "Project Silverstar"  
  end
  
  describe "GET 'home'" do
    it "should be successful " do
      get 'home'
      expect(response).to be_success
    end
    
    it "should have the right title" do
      get 'home'
      expect(response).to have_selector("title",
                                        :content => @base_title + " | Home")
    end
  end
  
  describe "GET 'contact'" do
    it "should be successful " do
      get 'contact'
      expect(response).to be_success
    end
    
    it "should have the right title" do
      get 'contact'
      expect(response).to have_selector("title",
                          :content => @base_title + " | Contact Us")
    end
  end
  
  describe "GET 'about'" do
    it "should be successful " do
      get 'about'
      expect(response).to be_success
    end
    
    it "should have the right title" do
      get 'about'
      expect(response).to have_selector("title",
                          :content => @base_title + " | About Us")
    end
  end
end
