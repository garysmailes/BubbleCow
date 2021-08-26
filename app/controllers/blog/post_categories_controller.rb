module Blog
  class PostCategoriesController < Blog::ApplicationController
    before_action :set_post_category, only: [:show, :edit, :update, :destroy]
    before_action :set_admin_nav_bar, only: [:index, :edit, :update, :new]
    layout :set_template

    def index
      @post_categories = PostCategory.all
      authorize @post_categories
    end

    def show
      authorize @post_category
      @categories = PostCategory.all
      @page_title = "Articles in the category" + " " + @post_category.name
      @page_description = 'The complete collection of articles in the category' + " " + @post_category.name
    end

    def new
      @post_category = PostCategory.new
      authorize @post_category
    end

    def edit
      authorize @post_category
    end

    def create
      @post_category = PostCategory.new(post_category_params)
      authorize @post_category
      respond_to do |format|
        if @post_category.save
          format.html { redirect_to admin_dashboard_path, notice: 'Post category was successfully created.' }
          format.json { render :show, status: :created, location: @post_category }
        else
          format.html { render :new }
          format.json { render json: @post_category.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      authorize @post_category
      respond_to do |format|
        if @post_category.update(post_category_params)
          format.html { redirect_to admin_dashboard_path, notice: 'Post category was successfully updated.' }
          format.json { render :show, status: :ok, location: @post_category }
        else
          format.html { render :edit }
          format.json { render json: @post_category.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      authorize @post_category
      @post_category.destroy
      respond_to do |format|
        format.html { redirect_to admin_dashboard_path, notice: 'Post category was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
      def set_post_category
        @post_category = PostCategory.friendly.find(params[:id])
      end

      def post_category_params
        params.require(:post_category).permit(:name, :slug)
      end

      def set_template
        case action_name
        when 'index', 'edit', 'new'
            'admin_template'
        else
            'application'
        end
      end

      def set_admin_nav_bar
        @unread_messages = Message.unread
        @unprocessed_developmental_edits = DevelopmentalEdit.developmental_edit_submitted
        @unprocessed_sample_developmental_edits = SampleDevelopmentalEdit.sample_developmental_edit_submitted
      end

  end
end
