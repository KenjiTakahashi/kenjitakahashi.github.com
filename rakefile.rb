desc 'Generate tag cloud'
task :cloud do
  puts 'Generating tag cloud...'
  require 'rubygems'
  require 'jekyll'
  include Jekyll::Filters

  options = Jekyll.configuration({})
  site = Jekyll::Site.new(options)
  site.read_posts('')

  shouter_html = ''
  blog_html = ''

  site.tags.sort.each do |tag, posts|
    shout_s = posts.select {|p| p if p.data['type'] == 'shout'}.count
    blog_s = posts.select {|p| p if p.data['type'] == 'post'}.count
    shout_font_size = 12 + (shout_s * 1.3)
    blog_font_size = 12 + (blog_s * 1.3)
    if shout_s > 0
      shouter_html << "<a href=\"/tag/shouter/#{tag}.html\" title=\"Pages tagged #{tag}\" style=\"font-size: #{shout_font_size}px; line-height: #{shout_font_size}px\" rel=\"tag\">#{tag}</a>"
    end
    if blog_s > 0
      blog_html << "<a href=\"/tag/blog/#{tag}.html\" title=\"Entires tagged #{tag}\" style=\"font-size: #{blog_font_size}px; line-height: #{blog_font_size}px\" rel=\"tag\">#{tag}</a>"
    end
  end

  File.open('_includes/shouter_tags.html', 'w+') do |file|
    file.puts shouter_html
  end
  File.open('_includes/blog_tags.html', 'w+') do |file|
    file.puts blog_html
  end

  puts 'Done.'
end

desc 'Generate tags pages'
task :tags do
  puts "Generating tags..."
  require 'rubygems'
  require 'jekyll'
  include Jekyll::Filters

  options = Jekyll.configuration({})
  site = Jekyll::Site.new(options)
  site.read_posts('')
  site.tags.sort.each do |tag, posts|
    shouts = posts.select {|p| p if p.data['type'] == 'shout'}
    blogs = posts.select {|p| p if p.data['type'] == 'post'}
    html = ''
    if shouts.count > 0
      html << <<-HTML
---
type: shout
layout: default
title: Shouts tagged "#{tag}"
tag: #{tag}
---
HTML
      FileUtils.mkdir_p "tag/shouter"
      File.open("tag/shouter/#{tag}.html", 'w+') do |file|
        file.puts html
      end
    end
    html = ''
    if blogs.count > 0
      html << <<-HTML
---
type: blog
layout: blog
title: Posts tagged "#{tag}"
tag: #{tag}
---
HTML
      FileUtils.mkdir_p "tag/blog"
      File.open("tag/blog/#{tag}.html", 'w+') do |file|
        file.puts html
      end
    end
  end
  puts 'Done.'
end
