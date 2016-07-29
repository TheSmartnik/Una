require 'nokogiri'
require 'pry'
require 'httparty'

LINK = "http://kitchenmag.ru/recipes?tag_ids%5B%5D=28&per_page=2000"
puts('Downloading menu...')
recipies_html_page = HTTParty.get(LINK).body
doc = Nokogiri::HTML(recipies_html_page)
links_to_recipies = doc.css('a.recipe-preview').xpath('@href').map do |href|
  "http://kitchenmag.ru#{href.value}"
end

recipies = {}
print('Downloading recipies')
links_to_recipies.each_with_index do |link, i|
  recipie_document = Nokogiri::HTML(HTTParty.get(link).body)
  recipie = {
    title: recipie_document.css('h1').first.text,
    link: link,
    ingredients: recipie_document.css('ul.article-list li').map(&:children).map(&:children).map(&:text)
  }

  recipies[i] = recipie
  print('.')
end
puts("\nSaving recepies")
File.open('recepies.yaml', 'w') do |f|
  f.write YAML.dump(recipies)
end
