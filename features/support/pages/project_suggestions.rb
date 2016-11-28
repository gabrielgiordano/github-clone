class ProjectSuggestionsPage < SitePrism::Page
  set_url "/projects{/project}/suggestions"

  elements :suggestions, "td a"

  def has_suggestion_named?(name)
    suggestions.any? { |s| s.text == name }
  end

  def destroy_link_for_suggestion_named(name)
    return unless has_suggestion_named? name
    index = index_link_for_suggestion_named(name)
    suggestions[index + 2]
  end

  def accept_link_for_suggestion_named(name)
    return unless has_suggestion_named? name
    index = index_link_for_suggestion_named(name)
    suggestions[index + 3]
  end

  private

  def index_link_for_suggestion_named(name)
    suggestions.find_index { |s| s.text == name }
  end

  class Suggestion < SitePrism::Section
    element :suggestion_link, 'a'
  end
end
