require 'yaml'
require 'httparty'
require 'pry'
recepie = YAML.load(File.open('recepies.yaml'))[rand(1..1626)]
title, ingredients, link = recepie.values_at(:title, :ingredients, :link)
text_to_send = <<-EOF
#{title}

Нужно купить:
#{ingredients.map { |i| '* ' + i.strip }.join("\n")}

[Ссылка](#{link})
EOF
API_KEY = ENV['API_KEY']
LINK = "https://api.telegram.org/bot#{API_KEY}/sendMessage"

puts HTTParty.post LINK,
  body: {
    chat_id: 89368230,
    text: text_to_send,
    disable_web_page_preview: true,
    parse_mode: 'Markdown'
  }
