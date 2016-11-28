class ProjectPage < SitePrism::Page
  set_url "/projects{/project}"

  element :new_file, "input[type='file']"
  element :upload_file, "input[type='submit']"
end
