require "rails_helper"

RSpec.feature "Showing an Article" do
  
  before do
    @article = Article.create(title: "Article", body: "Lorem ipsum.")
  end
  
  scenario "A user is displaying an article" do
    visit "/"
    click_link @article.title
    
    expect(page).to have_content(@article.title)
    expect(page).to have_content(@article.body)
    expect(current_path).to eq(article_path(@article))
  end
end