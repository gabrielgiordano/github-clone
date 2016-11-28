class NewProjectPage < SitePrism::Page
  set_url "/projects/new"

  element :name, "input[name='project[name]']"
  element :description, "input[name='project[description]']"
  element :visibility, "input[name='project[private]']"
  element :create_button, "input[type='submit']"
end
