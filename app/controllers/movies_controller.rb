class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :sort)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
      @all_ratings = {'G' => 1,'PG' => 1,'PG-13' => 1,'R' => 1}
      
      if params[:ratings] then
        @all_ratings.each do |x,y|
          @all_ratings[x] = 0
        end
        
        ratings = params[:ratings]
        ratings.each do |x,y|
          if @movies == nil then
            @movies = Movie.where(rating: x)
          else
            @movies = @movies + Movie.where(rating: x)
          end
          @all_ratings[x] = 1
        end
      else
        @movies = Movie.all 
      end
      
      if params[:sort] == 'title' then
        @movies = @movies.order(:title)
      end
      
      if params[:sort] == 'release_date' then
        @movies = @movies.order(:release_date)
      
      end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  

end
