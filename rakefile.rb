require 'rubygems'
require 'jekyll'

desc 'Generate tag cloud'
task :cloud do
  puts 'Generating tag cloud...'
  include Jekyll::Filters

  options = Jekyll.configuration({})
  site = Jekyll::Site.new(options)
  site.read_posts('')

  blog_html = ''

  site.tags.sort.each do |tag, posts|
    blog_s = posts.count
    blog_font_size = 12 + (blog_s * 1.3)
    blog_html << "<a href=\"#/tag/blog/#{tag}.html\" title=\"Entires tagged #{tag}\" style=\"font-size: #{blog_font_size}px; line-height: #{blog_font_size}px\" rel=\"tag\">#{tag}</a>\n"
  end

  File.open('_includes/blog_tags.html', 'w+') do |file|
    file.puts blog_html
  end

  puts 'Done.'
end

desc 'Generate tags pages'
task :tags do
  puts "Generating tags..."
  include Jekyll::Filters

  options = Jekyll.configuration({})
  site = Jekyll::Site.new(options)
  site.read_posts('')

  site.tags.sort.each do |tag, posts|
    blogs = posts.count
    html = ''
    if blogs > 0
      html << <<-HTML
---
type: blog
layout: blog
title: Posts tagged "#{tag}"
tag: #{tag}
---
HTML
    end
    FileUtils.mkdir_p "tag/blog"
    File.open("tag/blog/#{tag}.html", 'w+') do |file|
      file.puts html
    end
  end
  puts 'Done.'
end

desc "Generate dates/titles for calendar"
task :calendar do
  puts "Generating calendar dates/titles..."

  options = Jekyll.configuration({})
  site = Jekyll::Site.new(options)
  site.read_posts('')

  dates = {}
  site.posts.each do |post|
    (dates[post.date.to_s[0..9]] ||= []) << [post.data['title'][0..34] + (post.data['title'].length > 34 ? '...' : ''), post.url]
  end

  File.open('js/calendar.coffee.2', 'w') do |f|
    f.puts 'dates = ' + dates.to_s.gsub('=>',': ')
    File.foreach('js/calendar.coffee').with_index do |ff, i|
      if i != 0 or ff[0] != 'd'
        f.puts ff
      end
    end
  end
  File.rename('js/calendar.coffee.2', 'js/calendar.coffee')
  puts 'Done.'
end
