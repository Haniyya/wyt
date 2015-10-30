require 'nokogiri'
require 'open-uri'

class Newspaper < ActiveRecord::Base
  validates :name, presence: true
  validates :feed, presence: true
  Struct.new("Article", :title, :intro, :content)

  def articles
    res = Array.new()
    article_links(feed).each do |link|
      res << parse_article(link)
    end

    return res
  end

  private 

  def pages(link)
    doc = Nokogiri::HTML(open(link))

    pages = Array.new()

    doc.css("a.link-gradient-button").each do |anchor|
      pages << anchor['href']
    end

    return pages
  end

  def article_links(link)
    doc = Nokogiri::HTML(open(link))
    links = Array.new()
    doc.css(".search-teaser > a").each do |anchor|
      links << anchor['href'] if anchor['href'].include?("http://www.spiegel.de") 
    end

    return links 
  end

  def parse_article(link)
    doc = Nokogiri::HTML(open(link)) 
    article = Struct::Article.new('','','')

    doc.css(".article-title *").each do |child|
      article.title += child.content
    end

    article.intro = doc.css(".article-intro").first.content

    doc.css(".article-section.clearfix p").each do |p|
      article.content += p.content
    end

    return article
  end
end
