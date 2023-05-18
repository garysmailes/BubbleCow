require 'sidekiq/web'

Rails.application.routes.draw do

  # Old redirects
  draw :redirects

  resources :notifications, only: [:index]
  resources :announcements, only: [:index]
  # resources :users, only: [:show]

  #  Trix youtube plugin
  resource :embed, only: :update

  # services
  resources :testimonials

  # books
  resources :books do
    resources :orders
  end

  # allows orders
  resources :orders, only: [:index]

  namespace :services do
    resources :service_prices
    resources :sample_developmental_edits do 
      put 'sample_developmental_edit_accepted' => 'state_buttons#sample_developmental_edit_accepted', on: :member
      put 'sample_developmental_edit_rejected' => 'state_buttons#sample_developmental_edit_rejected', on: :member
    end
    resources :developmental_edits do
      put 'developmental_edit_accepted' => 'state_buttons#developmental_edit_accepted', on: :member
      put 'developmental_edit_rejected' => 'state_buttons#developmental_edit_rejected', on: :member
    end

    root to: "pages#index"
  end

  # customer pages
  scope controller: :customer_pages do
    get 'about'
    get 'writing_manual'
    get 'thanks'
    get 'file-safety'
    get 'developmental_editing'
    get 'content-editing', action: :developmental_editing
    get 'substantive-editing', action: :developmental_editing
    get 'novel-editing', action: :developmental_editing
    get 'manuscript-editing', action: :developmental_editing
    get 'book-editing', action: :developmental_editing
    get 'mentoring'
    get 'manuscript-assessment'
    get 'book-editing-portal'
    get 'terms-and-conditions'
    get 'privacy-policy'
    get 'may-2022-giveaway'
    get 'book-proposal'
    get 'copy-editing'
  end

  # dashboards
  get 'content-creator-dashboard', to: 'dashboards#content_creator_dashboard'
  get 'admin-dashboard', to: 'dashboards#admin_dashboard'
  get 'manager-dashboard', to: 'dashboards#manager'
  get 'writer-dashboard', to: 'dashboards#writer_dashboard'

  get 'writer_area', to: 'dashboards#writer_dashboard'

  # Blog
  namespace :blog do
    resources :post_authors, :post_categories
    resources :posts, path: '' do
      put 'publish' => 'posts#publish', on: :member, as: :publish
      put 'unpublish' => 'posts#unpublish', on: :member, as: :unpublish
    end
    root to: "posts#index"
  end

  # Messages
  resources :messages do
    put 'read' => 'messages#read', on: :member, as: :read
    put 'unread' => 'messages#unread', on: :member, as: :unread
    put 'archive' => 'messages#archive', on: :member, as: :archive
    put 'unarchive' => 'messages#unarchive', on: :member, as: :unarchive
  end
  get '/thank-you', to: 'messages#thank_you'

  # Mailing List
  resources :mailing_lists
  get '/writing_manual_download', to: 'mailing_lists#writing_manual_download'
  get '/writing_manual_pdf_download', to: "mailing_lists#writing_manual_pdf_download"

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # Users
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", registrations: 'users/registrations', sessions: 'users/sessions' }
  resources :users, :only => [ :index, :show, :edit, :update, :destroy]  

  # Courses
  resources :courses do
    resources :lessons
  end

  # Products
  resources :products

  root to: 'customer_pages#index'

end