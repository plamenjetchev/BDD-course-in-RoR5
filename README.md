# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version 2.4.2

* Rails version 5.1.4

* System dependencies
* ran into "NoMethodError: undefined method `last_comment' 
* for #<Rake::Application:0x0000000002d97630>"
* fix: go to Gemfile change gem 'rspec-rails', to version '>= 3.4.4'

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* Scenario:
* 
-visit root page
-click on new article
-fill in title
-fill in body
-create an article

-Expectations:

-article has been created
-articleles path

ran into an error:
 ArticlesController / returns http success
Failure/Error: root "index"
NoMethodError:undefined method `root' for 
#<RSpec::ExampleGroups::ArticlesController::Nested:0x000000000522bbb8>

fix it in articles_controller_spec.rb..:
code with the error:
       
require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do

  describe "/" do
    it "returns http success" do
      root "index"
      expect(response).to have_http_status(:success)
    end
  end
end

the fix:

require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do

  describe "/" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end

