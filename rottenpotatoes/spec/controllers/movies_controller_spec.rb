require 'rails_helper'

RSpec.describe MoviesController, type: :controller do

  describe "MoviesController" do
    render_views
   
    context "how to show a Movie" do
      before :each do
        Movie.create(title: 'test1', rating: 'R', director: 'testdir', release_date: Date.new(2020,1,1))
        @movies = Movie.all
      end

      it "Should be show a movie" do
        get :show, id: @movies.take.id
        expect(assigns(:movie)).to eq(@movies.take)
      end

    end


    context "how to create Movies" do
      before :each do
        Movie.create(title: 'test1', rating: 'R', director: 'testdir', release_date: Date.new(2020,1,1))
        @movies = Movie.all
      end

      it "Should be create a movie" do
        movies_count = Movie.all.count
        movie = {title: 'test1', director: 'testdir',rating: 'R', description: 'Movie', release_date: Date.new(2020,1,1)}
        post :create, movie: movie
        expect(flash[:notice]).to eq("#{movie[:title]} was successfully created.")
        expect(response).to redirect_to(movies_path)
        expect(@movies.count).to eq(movies_count + 1)
      end

    end

    context "how to edit a Movie" do
      before :each do
        Movie.create(title: 'test1',director: 'testdir',rating: 'R', release_date: Date.new(2020,1,1))
        @movies = Movie.all
      end

      it "Should be edit a movie" do
        get :edit, id: @movies.take.id
        expect(assigns(:movie)).to eq(@movies.take)
      end
    end


    context "how to update Movies" do
      before :each do
        Movie.create(title: 'test1',director: 'testdir',rating: 'R', release_date: Date.new(2020,1,1))
        @movies = Movie.all
      end

      it "Should be updating a movie" do
        movie = @movies.take
        movie_param = {title: 'test2'}
        put :update, id: movie.id, movie: movie_param
      
        expect(flash[:notice]).to eq("#{movie_param[:title]} was successfully updated.")
        expect(response).to redirect_to(movie_path(movie.id ))
        expect(Movie.find(movie.id).title).to eq('test2')

      end

    end
    
    context "how to delete Movies" do
      before :each do
        Movie.create(title: 'test1',director: 'testdir',rating: 'R', release_date: Date.new(2020,1,1))
        @movies = Movie.all
      end

      it "Should be destroy a movie" do
        movies_count = Movie.all.count
        movie = @movies.take
        delete :destroy, id: movie.id 
      
        expect(flash[:notice]).to eq("Movie '#{movie.title}' deleted.")
        expect(response).to redirect_to(movies_path)
        expect(@movies.count).to eq(movies_count -1)
      end

    end


    context "Sorting Movies" do
      before :each do
        Movie.create(title: 'test1',director: 'testdir1',rating: 'R', release_date: Date.new(2020,1,1))
        Movie.create(title: 'test2',director: 'testdir2',rating: 'PG', release_date: Date.new(2020,1,2))
        Movie.create(title: 'test3',director: 'testdir3',rating: 'PG-13', release_date: Date.new(2020,1,3))

        @movies = Movie.all
      end

      it "Should be sort based on title" do
        get :index, sort: 'title'
      end

      it "Should be sort based on release_date" do
        get :index, sort: 'release_date'
      end

      it "Should be show all movies if sort params is not provided" do
        get :index
      end

    end
 context "find similar Movies" do
      before :each do
        Movie.create(title: 'test1',director: 'testdir1',rating: 'R', release_date: Date.new(2020,1,1))
        Movie.create(title: 'test2',director: 'testdir2',rating: 'PG', release_date: Date.new(2020,1,2))
        Movie.create(title: 'test3',director: 'testdir3',rating: 'PG-13', release_date: Date.new(2020,1,3))
        @movies = Movie.all
      end

      it "Should be redirect to the home page with an error when can't find similar movies" do
        expect(Movie).to receive(:similar_movies).with('test4')
        
        get :search,  { title: 'test4' }
        expect(response).to redirect_to('/movies')
        expect(flash[:notice]).to eq("'test4' has no director info")
      end

      

    end

  end

end