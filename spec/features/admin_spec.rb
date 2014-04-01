require 'spec_helper'
require 'capybara'

feature 'Admin panel' do
  context "on admin homepage" do
    it "can see a list of recent posts" do
      post = Post.create(title: "SOME RANDOM TITLE", content: "here's some content")
      page.driver.browser.authorize 'geek', 'jock'
      visit admin_posts_url
      expect(page).to have_content post.title
    end

    it "can edit a post by clicking the edit link next to a post" do
      post = Post.create(title: "SOME RANDOM TITLE2", content: "here's some content")
      page.driver.browser.authorize 'geek', 'jock'
      visit admin_posts_url
      expect(page).to have_link 'Edit'
      click_link('Edit')

      fill_in('post[title]', :with => 'a new title')
      fill_in('post[content]', :with => 'heres some new content')
      check('post[is_published]')
      click_button( 'Save' )

      expect(page).to have_content 'A New Title'

      Post.first.title.should == 'A New Title'
    end

    it "can delete a post by clicking the delete link next to a post" do
      post = Post.create(title: "SOME RANDOM TITLE2", content: "here's some content")
      page.driver.browser.authorize 'geek', 'jock'
      visit admin_posts_url
      expect(page).to have_link 'Delete'
      click_link('Delete')

      Post.all.should be_empty
    end

    it "can create a new post and view it" do
       visit new_admin_post_url

       expect {
         fill_in 'post_title',   with: "Hello world!"
         fill_in 'post_content', with: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat."
         page.check('post_is_published')
         click_button "Save"
       }.to change(Post, :count).by(1)

       expect(page).to have_content "Published: true"
       expect(page).to have_content "Post was successfully saved."
     end
  end

  context "editing post" do
    it "can mark an existing post as unpublished" do
      post = Post.create(title: "SOME RANDOM TITLE2", content: "here's some content")
      visit edit_admin_post_path(post)
      uncheck('post[is_published]')
      click_button "Save"


      expect(page).to have_content "Published: false"
    end
  end

  context "on post show page" do
    it "can visit a post show page by clicking the title" do
      post = Post.create(title: "SOME RANDOM TITLE2", content: "here's some content")
      page.driver.browser.authorize 'geek', 'jock'
      visit admin_posts_url
      click_link(post.title)

      current_path == post_path(post)
    end

    it "can see an edit link that takes you to the edit post path" do
      post = Post.create(title: "SOME RANDOM TITLE2", content: "here's some content")
      page.driver.browser.authorize 'geek', 'jock'
      visit admin_posts_url
      expect(page).to have_link 'Edit'
      click_link('Edit')

      current_path == edit_admin_post_path(post)
    end

    it "can go to the admin homepage by clicking the Admin welcome page link" do
      post = Post.create(title: "SOME RANDOM TITLE2", content: "here's some content")
      visit admin_post_path(post)
      click_link('Admin welcome page')

      current_path == admin_posts_path
    end
  end
end
