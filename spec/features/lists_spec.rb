require 'rails_helper'

RSpec.feature "Lists", type: :feature, js: true do
  let!(:list) { create(:list, title: "Some list") }

  before do
    sign_in list.user
  end
  
  scenario "user create a new list" do
    visit root_path
    
    expect{
      click_link "New List"
      fill_in 'list_title' , with: "some new list"
      click_button "Save"
      sleep 3
      visit root_path
    }.to change(List.all, :count).by(1)
    
    visit root_path

    expect(page).to have_content "some new list"
  end

  scenario "user update a list" do
    visit root_path
  
    find("#list-#{list.id}").hover.click_on class: 'fa-edit'
    fill_in "list_title", with: "Edited list"
    click_button "Save"
    sleep 3
    
    visit root_path

    expect(page).to have_content "Edited list"
  end

  context "with a empty title" do
    scenario "user can't create new list" do
      visit root_path

      expect{
        click_link "New List"
        fill_in "Title", with: ""
        click_button "Save"
      }.not_to change(List.all, :count)
      
      # TODO: Uncomment this after notice refactor:
      # expect(page).to have_content "Title can't be blank"
    end

    scenario "user can't update a list" do
      old_title = list.title
      visit root_path
      find("#list-#{list.id}").hover.click_on class: 'fa-edit'
      fill_in "Title", with: ""
      click_button "Save"
      
      expect(list.title).to include(old_title)

      # TODO: Uncomment this after notice refactor:
      # expect(page).to have_content "Title can't be blank"
    end
  end

  context "with same title" do
    scenario "user can't create new list" do
      create(:list, title: "same title", user: list.user)
      visit root_path

      expect{
        click_link "New List"
        fill_in "Title", with: "same title"
        click_button "Save"
      }.not_to change(List.all, :count)

      # TODO: Uncomment this after notice refactor:
      # expect(page).to have_content "Title has already been taken"
    end

    scenario "user can't update list" do
      old_title = list.title
      create(:list, title: "same title", user: list.user)
      visit root_path
      find("#list-#{list.id}").hover.click_on class: 'fa-edit'

      fill_in "Title", with: "same title"
      click_button "Save"
      
      expect(list.title).to include(old_title)

      # TODO: Uncomment this after notice refactor:
      # expect(page).to have_content "Title has already been taken"
    end
  end

  scenario "user show list of tasks" do
    visit root_path
    click_link "Some list"
    
    expect(page).to have_content (list.title)
  end

  scenario "user delete a list" do
    visit root_path

    expect {
      find("#list-#{list.id}").hover.click_on class: 'fa-trash'
      page.driver.browser.switch_to.alert.accept
      visit root_path
    }.to change(List.all, :count).by(-1)

    visit root_path

    expect(page).not_to have_content(list.title)
  end

end
