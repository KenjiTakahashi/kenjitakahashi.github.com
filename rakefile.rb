@@site_url = 'http://www.kenjitakahashi.github.com'

task :cloud_basic do
  puts 'Generating tag cloud...'
  require 'rubygems'
  require 'jekyll'
  include Jekyll::Filters

  options = Jekyll.configuration({})
  site = Jekyll::Site.new(options)
  site.read_posts('')

  html = ''

  site.tags.sort.each do |tag, posts|
    s = posts.count
    font_size = 12 + (s * 1.3);
    html << "<a href=\"#{@@site_url}/tag/#{tag}/\" title=\"Pages tagged #{tag}\" style=\"font-size: #{font_size}px; line-height:#{font_size}px\" rel=\"tag\">#{tag}</a> "
  end

  File.open('_includes/tags.html', 'w+') do |file|
    file.puts html
  end

  puts 'Done.'
end

task :cloud do
  puts 'Generating tag cloud...'
  require 'rubygems'
  require 'jekyll'
  include Jekyll::Filters

  options = Jekyll.configuration({})
  site = Jekyll::Site.new(options)
  site.read_posts('')

  html =<<-HTML
---
layout: default
title: Tags
type: A tag cloud
---

<h1>Tag cloud for {{site.title}}</h1>

    <p>Click on a tag to see the relevant posts.</p>
    HTML

  site.tags.sort.each do |tag, posts|
    next if tag == ".net"
    html << <<-HTML
    HTML

    s = posts.count
    font_size = 12 + (s*1.5);
    html << "<a href=\"#{@@site_url}/tag/#{tag}/\" title=\"Entries tagged #{tag}\" style=\"font-size: #{font_size}px; line-height:#{font_size}px\">#{tag}</a> "
  end

  html << "<p>You may also wish to browse the <a href=\"#{@@site_url}/archives/\" title=\"Archives for {{site.title}}\">archives</a>."

  File.open('tags/index.html', 'w+') do |file|
    file.puts html
  end

  puts 'Done.'
end

desc 'Generate tags page'
task :tags do
  puts "Generating tags..."
  require 'rubygems'
  require 'jekyll'
  include Jekyll::Filters

  options = Jekyll.configuration({})
  site = Jekyll::Site.new(options)
  site.read_posts('')
  site.tags.sort.each do |tag, posts|

  html = ''
  html << <<-HTML
---
layout: default
title: Entries tagged "#{tag}"
type: "#{tag.gsub(/\b\w/){$&.upcase}}"
---
    <h1 id="#{tag}">Entries tagged "#{tag}"</h1>
    <a href="#{@@site_url}/tags/" title="Tag cloud for {{site.title}}">&laquo; Show all tags...</a>
    HTML

  html << '<ul class="posting_list">'
  posts.each do |post|
    post_data = post.to_liquid
    html << <<-HTML
      <li><a href="#{@@site_url}/#{post.url}" rel="tag" title="Entries tagged #{post_data['title']}">#{post_data['title']}</a></li>
    HTML
  end
  html << '</ul>'

  html << '<p>You may also be interested in browsing the <a href="#'+@@site_url+'/archives/" title="Archives for {{site.title}}">archives</a> or seeing <a href="'+@@site_url+'/tags/" title="Tag cloud for {{site.title}}">the tag cloud for {{site.title}}</a>.'
    FileUtils.mkdir_p "tag/#{tag}"
    File.open("tag/#{tag}/index.html", 'w+') do |file|
      file.puts html
    end
  end
  puts 'Done.'
end
