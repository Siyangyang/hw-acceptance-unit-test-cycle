require 'rails_helper'

describe MoviesController, type: :controller do

    describe '.similar' do
        
        it "found similar movies" do
            Movie.create(title: 'Movie1', rating: 'G', director: 'Director1', release_date: Date.new(2003,10,10))
            Movie.create(title: 'Movie2', rating: 'G', director: 'Director1', release_date: Date.new(2004,1,1))
            Movie.create(title: 'Movie3', rating: 'G', director: 'Director2', release_date: Date.new(2005,5,5))
            @movies = Movie.all
    
            movie = @movies.take
            get :similar, movie_id: movie.id
            expect(response).to render_template('movies/similar')
        end
        
        it 'not found movies' do
            Movie.create(title: 'Movie1', rating: 'G', director: 'Director1', release_date: Date.new(2003,10,10))
            Movie.create(title: 'Movie2', rating: 'G', director: 'Director1', release_date: Date.new(2004,1,1))
            Movie.create(title: 'Movie3', rating: 'G', director: 'Director2', release_date: Date.new(2005,5,5))


            movie = Movie.all.where(title: 'Movie3').take
            get :similar, movie_id: movie.id
            expect(response).to redirect_to('/movies')
        end
    end
    
    describe ".show" do
        it 'show a movie by id' do
            Movie.create(title: 'Movie1', rating: 'G', director: 'Director1', release_date: Date.new(2003,10,10))
            get :show, id: 1
            expect(response).to render_template('movies/show')
        end
    end
    
    describe ".create" do
        it "creates a movie" do
            movie_p = Hash.new
            movie_p["title"] = "Movie1"
            movie_p["rating"] = "G"
            movie_p["director"] = "Director1"
            movie_p["release_date"] = Date.new(2003,10,10)
            
            post :create, movie: movie_p
            expect(response).to redirect_to("/movies")
        end
    end
    
    describe ".update" do
        it "updates a movie" do
            Movie.create(title: 'Movie1', rating: 'G', director: 'Director1', release_date: Date.new(2003,10,10))
            movie_p = Hash.new
            movie_p["title"] = "Movie1"
            movie_p["rating"] = "G"
            movie_p["director"] = "Director1"
            movie_p["release_date"] = Date.new(2003,10,10)
            
            movie = Movie.all.where(id: 1).take
            get :update, id: 1, movie: movie_p

            expect(response).to redirect_to("/movies/#{movie.id}")
        end
    end
    
    describe ".index" do
        it "sorts by title" do
            get :index, sort: "title"
        end
    end
end