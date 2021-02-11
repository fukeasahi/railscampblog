class ArticlesController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    def index
        @articles = Article.all
        @ranks = REDIS.zrevrange "ranking", 0, 2, withscores: true
    end
    
    def new
        @article = Article.new
    end
    
    def create
        @article = Article.new(article_params)
        @article.user_id = current_user.id
        @article.save
        redirect_to article_path(@article)
    end
    
    def show
        @article = Article.find(params[:id])
        REDIS.zincrby "ranking", 1, "#{@article.title}"

        @ranks = REDIS.zrevrange "ranking", 0, 2, withscores: true
    end
    
    def edit
         @article = Article.find(params[:id])
        if current_user.id != @article.user.id
            flash[:notice] = "Not yours"
            redirect_to root_path
        end
    end
    
    def update
        @article = Article.find(params[:id])
        @article.update(article_params)
        redirect_to article_path(@article)
    end
    
    def destroy
        @article = Article.find(params[:id])
        if current_user.id != @article.user.id
            flash[:notice] = "Not yours"
            redirect_to root_path
        else
            @article.destroy
            redirect_to root_path
        end
    end
    
    private

  def article_params
    params.require(:article).permit(:title, :body)
  end
end
