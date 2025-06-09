class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_article, only: [:show, :edit, :update, :destroy, :report]
  load_and_authorize_resource

  def index
    @articles = Article.where(archived: [false, nil])
  end

  def show; end

  def new
    @article = current_user.articles.new
  end

  def create
    @article = current_user.articles.new(article_params)
    if @article.save
      redirect_to @article, notice: "Article created."
    else
      render :new
    end
  end

  def edit; end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: "Updated!"
    else
      render :edit
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path, notice: "Deleted!"
  end

  def report
    @article = Article.find(params[:id])
    @article.increment!(:reports_count)
    @article.save  # <- triggers before_save callback
  
    redirect_to articles_path, notice: "Article reported successfully."
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :content, :image)
  end
end
