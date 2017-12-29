require 'rails_helper'

RSpec.describe "Articles", type: :request do

  before do
    @john = User.create(email: "john@example.com", password: "password")
    @fred = User.create(email: "fred@example.com", password: "password")
    @article = Article.create!(title: "Title One", body: "Body of article one", user: @john)
  end
  
  describe 'GET /articles/:id/edit' do
    context 'with non-signed in user' do
      before { get "/articles/#{@article.id}/edit" }
      
      it "redirects to the signin page" do
        expect(response.status).to eq 302
        flash_message = "You need to sign in or sign up before continuing."
        expect(flash[:alert]).to eq flash_message
      end
    end
    
    context 'with signed in user who is non-owner' do
      before do
        login_as(@fred)
        get "/articles/#{@article.id}/edit"
      end
    
      it "redirects to the home page" do
        expect(response.status).to eq 302
        flash_message = "You can only edit your own articles."
        expect(flash[:alert]).to eq flash_message
      end
    end
    
    context 'with signed in user as owner successfull edit' do
      before do
        login_as(@john)
        get "/articles/#{@article.id}/edit"
      end
      
      it "successfully edits article" do
        expect(response.status).to eq 200
      end
    end
  end
  
  describe 'GET/articles/:id' do
    context 'with existing article' do
      before { get "/articles/#{@article.id}" }
      
      it "handles existing article" do
        expect(response.status).to eq 200
      end
    end
    
    context 'with none existing article' do
      before { get "/articles/xxxx" }
      
      it "handles none existing article" do
        expect(response.status).to eq 302
        flash_message = "The article you are looking for could not be found."
        expect(flash[:alert]).to eq flash_message
      end
    end
  end
  
  describe 'PUT /articles/:id' do
    context 'with user not signed in' do
      before { put "/articles/#{@article.id}",
              params: { article: {title: "New Title", body: "New body"} } }
      it "redirects to the signin page" do
        expect(response.status).to eq 302
        flash_message = "You need to sign in or sign up before continuing."
        expect(flash[:alert]).to eq flash_message
      end
    end
    context 'with user signed in who doesn\'t own the article' do
      before do
        login_as(@fred)
        put "/articles/#{@article.id}",
              params: { article: {title: "New Title", body: "New Body"} }
      end
      it "redirects to the home page" do
        expect(response.status).to eq 302
        flash_message = "You can only edit your own articles."
        expect(flash[:alert]).to eq flash_message
      end
    end
    
    context "with user signed in and who owns the article" do
      before { login_as(@john) }
      it "successfully updates the article" do
        put "/articles/#{@article.id}", 
                params: { article: {title: "New Title", body: "New Body"} }
          expect(response.status).to eq 302
        end
        it "unsuccessfully updates the article" do
          put "/articles/#{@article.id}", 
                params: { article: {title: "", body: ""} }
          expect(flash[:danger]).to eq("Article has not been updated")
          expect(response.status).to eq 200
        end
      end
    end
  
  describe 'DELETE /articles/:id' do
    context 'with user not signed in' do
      before { delete "/articles/#{@article.id}" }
      
      it 'redirects to sign in page' do
        expect(response.status).to eq 302
        flash_message = "You need to sign in or sign up before continuing."
        expect(flash[:alert]).to eq flash_message
      end
    end
    
    context 'with signed in user who is not the owner of the article' do
      before do
        login_as(@fred)
        delete "/articles/#{@article.id}"
      end
      
      it "redirects to homepage" do
        expect(response.status).to eq 302
        flash_message = "You can only delete your own articles."
        expect(flash[:alert]).to eq flash_message
      end
    end
    
    context 'with signed in user who owns the article' do
      before do 
       login_as(@john)
       delete "/articles/#{@article.id}"
      end
      
      it "successfully deletes  an article" do
        expect(response.status).to eq 302
      end
    end
  end
end