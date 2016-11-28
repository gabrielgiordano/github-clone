def register_user(email)
  page = RegisterPage.new
  page.load
  page.email.set email
  page.password.set "password"
  page.password_confirmation.set "password"
  page.register_button.click
end

def create_public_project(project_name)
  FileUtils.rm_rf("repositories/#{project_name}")
  page = NewProjectPage.new
  page.load
  page.name.set project_name
  page.description.set "description"
  page.create_button.click
  id_from_url(current_url)
end

def create_suggestion(suggestion, project_id)
  page = NewProjectSuggestionPage.new

  page.load(project: project_id)

  with_temporary_file(suggestion[:arquivo], suggestion[:conteudo]) do
    page.title.set suggestion[:nome]
    page.description.set suggestion[:descricao]
    page.file.set "features/fixtures/#{suggestion[:arquivo]}"
    page.create_suggestion.click
  end

  id_from_url(current_url)
end

def create_empty_suggestions(project_id, suggestion_names)
  page = NewProjectSuggestionPage.new
  suggestion_ids = {}

  suggestion_names.each do |name|
    page.load(project: project_id)
    page.title.set name
    page.description.set "description"
    page.file.set "features/fixtures/empty.rb"
    page.create_suggestion.click
    suggestion_ids[id_from_url(current_url)] = {name: name}
  end

  suggestion_ids
end

def id_from_url(url)
  id_index = url =~ /\d+$/
  url[id_index..-1]
end

def with_temporary_file(file_name, content)
  path = "features/fixtures/#{file_name}"
  temp_file = File.new(path, "w")
  temp_file.puts(content)
  temp_file.close

  yield temp_file

  File.delete(path)
end

def upload_temporary_file(page, file)
  with_temporary_file(file[:nome], file[:conteudo]) do
    page.new_file.set "features/fixtures/#{file[:nome]}"
    page.upload_file.click
  end
end
