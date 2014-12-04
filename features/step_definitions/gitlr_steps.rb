When(/^using mock `([^"]*)`$/) do |mock|
  stub_request(:any, "https://api.github.com/orgs/amedia/repos?per_page=100").to_return(File.new("./test/mock/#{mock}"))
end
