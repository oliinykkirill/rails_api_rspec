RSpec::Matchers.define :have_pagination_links do
  match do |json_response|
    links = json_response['links'] || json_response[:links]
    links && links.key?('first') && links.key?('last')
  end
end
