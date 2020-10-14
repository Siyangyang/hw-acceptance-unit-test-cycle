require 'rails_helper'

RSpec.describe MoviesController, type: :controller do

  describe "MoviesController" do
    render_views
   
    context "Showing a Movie" do
      before :each do
        Movie.create(title: 'Star Wars', rating: 'PG', director: 'George Lucas', release_date: Date.new(1977,5,25))
        @movies = Movie.all
      end

      it "Should be show a movie" do
        get :show, id: @movies.take.id
      
        expect(assigns(:movie)).to eq(@movies.take)
      end

    end


    context "Creating Movies" do
      before :each do
        Movie.create(title: 'Star Wars', rating: 'PG', director: 'George Lucas', release_date: Date.new(1977,5,25))
        @movies = Movie.all
      end

      it "Should be create a movie" do

        movies_count = Movie.all.count
        movie = {title: 'Star Wars', director: 'George Lucas',rating: 'PG', description: 'Great Movie', release_date: Date.new(1977,5,25)}
        post :create, movie: movie
      
        expect(flash[:notice]).to eq("#{movie[:title]} was successfully created.")
        expect(response).to redirect_to(movies_path)
        expect(@movies.count).to eq(movies_count + 1)
      end

    end

    context "Editing a Movie" do
      before :each do
        Movie.create(title: 'Star Wars', rating: 'PG', director: 'George Lucas', release_date: Date.new(1977,5,25))
        @movies = Movie.all
      end

      it "Should be edit a movie" do
        get :edit, id: @movies.take.id
      
        expect(assigns(:movie)).to eq(@movies.take)
      end

    end


    context "Updating Movies" do
      before :each do
        Movie.create(title: 'Star Wars', rating: 'PG', director: 'George Lucas', release_date: Date.new(1977,5,25))
        @movies = Movie.all
      end

      it "Should be updating a movie" do
        movie = @movies.take
        movie_param = {title: 'Star Wars: A new Hope'}
        put :update, id: movie.id, movie: movie_param
      
        expect(flash[:notice]).to eq("#{movie_param[:title]} was successfully updated.")
        expect(response).to redirect_to(movie_path(movie.id ))
        expect(Movie.find(movie.id).title).to eq('Star Wars: A new Hope')

      end

    end


    context "Destroy Movies" do
      before :each do
        Movie.create(title: 'Star Wars', rating: 'PG', director: 'George Lucas', release_date: Date.new(1977,5,25))
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
        Movie.create(title: 'Star Wars', rating: 'PG', director: 'George Lucas', release_date: Date.new(1977,5,25))
        Movie.create(title: 'Blade Runner', rating: 'PG', director: 'Ridley Scott', release_date: Date.new(1982,6,25))
        Movie.create(title: 'THX-1138', rating: 'R', director: 'George Lucas', release_date: Date.new(1971,3,11))

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

 
      
  end

end