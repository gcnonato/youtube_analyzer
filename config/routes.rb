YoutubeAnalyzer::Application.routes.draw do

  root to: 'watch_data#index'

  resources :youtube_analyzers, :only => [:index] do
    get :oauth2callback, :on => :collection
  end

  resources :youtube_analitics_graphs, only: %i(index)
end
