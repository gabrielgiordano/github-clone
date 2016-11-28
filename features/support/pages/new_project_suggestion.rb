class NewProjectSuggestionPage < SitePrism::Page
  set_url "/projects{/project}/suggestions/new"

  element :title, "input[name='title']"
  element :description, "textarea[name='description']"
  element :file, "input[type='file']"
  element :create_suggestion, "input[type='submit']"
end
