class PageController < ApplicationController
  before_action :authenticate_user!, only: [:blog_dashboard]

  def index
    @page_title = "Affordable Book Editing Services"
    @page_description = "Book editing services for serious writers. Serving writers since 2007. 100+ testimonials."
    @testimonial_count = Testimonial.all.count
  end

  def about
    @page_title = "About BubbleCow"
    @page_description = "BubbleCow started editing books and helping writers to success in 2007. Discover the BubbleCow story and meet our founder."
  end

  def writer_dashboard
  end

  def writing_manual
  end 

  def admin_dashboard
    @posts = Post.all
    @authors = PostAuthor.all
    @categories = PostCategory.all
    @testimonials = Testimonial.all
  end

end
