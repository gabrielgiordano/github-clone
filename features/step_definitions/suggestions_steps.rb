Dado(/^o usuário "([^"]*)" logado no sistema$/) do |email|
  register_user(email)
end

Dado(/^um projeto público chamado "([^"]*)" com as sugestões$/) do |project_name, suggestions_table|
  suggestions = suggestions_table.raw.flatten
  @project_id = create_public_project(project_name)
  @suggestion_ids = create_empty_suggestions(@project_id, suggestions)
end

Quando(/^"([^"]*)" visualizar as sugestões$/) do |email|
  @current_page = ProjectSuggestionsPage.new
  @current_page.load(project: @project_id)
end

Então(/^ele deve ver as seguintes sugestões na lista de sugestões$/) do |suggestions_table|
  suggestions = suggestions_table.raw.flatten

  suggestions.each do |suggestion|
    expect(@current_page.has_suggestion_named?(suggestion)).to be true
  end
end

Dado(/^um projeto público chamado "([^"]*)" com uma sugestão chamada "([^"]*)"$/) do |project_name, suggestion_name|
  @project_id = create_public_project(project_name)
  @suggestion_ids = create_empty_suggestions(@project_id, [suggestion_name])
end

Quando(/^"([^"]*)" deletar a sugestão "([^"]*)"$/) do |email, suggestion_name|
  @current_page = ProjectSuggestionsPage.new
  @current_page.load(project: @project_id)
  @current_page.destroy_link_for_suggestion_named(suggestion_name).click
end

Então(/^ele não deve ver nenhuma sugestão na lista de sugestões$/) do
  expect(@current_page.suggestions.size).to eq 0
end

Dado(/^um projeto público chamado "([^"]*)" com os seguintes arquivos$/) do |project_name, files|
  @project_id = create_public_project(project_name)
  @current_page = ProjectPage.new
  @current_page.load(project: @project_id)

  files.hashes.each { |file| upload_temporary_file(@current_page, file) }
end

Quando(/^"([^"]*)" criar? uma sugestões com os seguintes dados$/) do |email, suggestions|
  suggestions.hashes.each { |suggestion| create_suggestion(suggestion, @project_id) }
end

Então(/^ele deve visualizar a sugestão contendo os seguintes dados$/) do |suggestions|
  suggestion = suggestions.hashes.first

  expect(has_content?(suggestion[:nome])).to eq true
  expect(has_content?(suggestion[:descricao])).to eq true
  expect(has_content?(suggestion[:arquivo])).to eq true
end

Quando(/^a sugestão chamada "([^"]*)" for aceita$/) do |suggestion_name|
  @current_page = ProjectSuggestionsPage.new
  @current_page.load(project: @project_id)
  @current_page.accept_link_for_suggestion_named(suggestion_name).click
end


Então(/^o projeto deve conter os seguintes arquivos$/) do |files_table|
  files = files_table.hashes

  files.each do |file|
    visit(project_file_path(@project_id, file[:nome]))

    expect(has_content?(file[:conteudo])).to eq true
  end
end
