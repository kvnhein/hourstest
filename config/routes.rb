Rails.application.routes.draw do
  root 'events#landing'

  resources :daily_specials do
     member do
          patch :dish_limited, :dish_not_limited
          put "like", to: "daily_specials#upvote"
          put "dislike", to: "daily_specials#downvote"
        end
      end
  resources :liqours do
    member do
      patch :add_to_reserve, :add_to_current
    end
  end

  resources :drinks do
    member do
      patch :add_to_reserve, :add_to_current
    end
  end

  resources :lists do
   member do
          patch :add_to_reserve, :add_to_current
        end
      end

  resources :brews
  get 'beers/autocomplete_beer_name'

  resources :beers do
      member do
          patch :beer_level_low, :beer_level_full, :add_to_reserve, :add_to_current
        end
      end

 devise_for :users
 get 'south_side/autocomplete_event_special'
      get 'south_side' => 'events#south_side'
         resources :events
get 'shadyside/autocomplete_event_special'
      get 'shadyside' => 'events#shadyside'
         resources :events
get 'market_square/autocomplete_event_special'
      get 'market_square' => 'events#market_square'
         resources :events
get 'oakland/autocomplete_event_special'
      get 'oakland' => 'events#oakland'
         resources :events
  get 'lawrenceville/autocomplete_event_special'
      get 'lawrenceville' => 'events#lawrenceville'
         resources :events
  get 'bloomfield/autocomplete_event_special'
      get 'bloomfield' => 'events#bloomfield'
         resources :events

  resources :venues do
    member do
      get :venue_verified
    end
  end

  resources :neighborhoods

   get 'shadyside/autocomplete_event_special'
   get 'market_square' => 'events#market_square'
   get 'landing' => 'events#landing'
   get 'shadyside' => 'events#shadyside'
   get 'lawrenceville' => 'events#lawrenceville'
   get 'venue_beer_list' => 'beers#venue_beer_list'
   get 'venue_liqour_list' => 'liqours#venue_liqour_list'
   get 'venue_drink_list' => 'drinks#venue_drink_list'
   get 'oakland' => 'events#oakland'
   get 'users_venues' => 'venues#users_venues'
   get 'about_us' => 'events#about_us'
   get 'urbanist' => 'events#urbanist'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
