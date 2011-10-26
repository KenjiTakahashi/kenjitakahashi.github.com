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
      shouter_html << "<a href=\"/tag/shouter/#{tag}/\" title=\"Pages tagged #{tag}\" style=\"font-size: #{shout_font_size}px; line-height:#{shout_font_size}px\" rel=\"tag\">#{tag}</a>"
    end
    if blog_s > 0
      blog_html << "<a href=\"/tag/blog/#{tag}/\" title=\"Entires tagged #{tag}\" style=\"font-size: #{blog_font_size}px; line-height: #{blog_font_size}px\" rel=\"tag\">#{tag}</a>"
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
