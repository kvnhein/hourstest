Rails.application.routes.draw do
  root 'events#landing'


  devise_for 	:users,
  						:path => '',
  						:path_names => {:sign_in => 'login', :sign_out => 'logout', :edit => 'profile'},
  						:controllers => { :omniauth_callbacks => "omniauth_callbacks",:registrations => "users/registrations",:sessions => "users/sessions" }
  						
 

  get 'past_features/:past_tag', to: 'daily_specials#past_features', as: :past_tag
  get 'past_features' => 'daily_specials#past_features'
  get 'tags/:tag', to: 'daily_specials#index', as: :tag
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

resources :events do
    member do
          put "like", to: "events#event_upvote"
          put "dislike", to: "events#event_downvote"
        end
   end

 get 'south_side/:south_tag', to: 'events#south_side', as: :south_tag
 get 'south_side/autocomplete_event_special'
      get 'south_side' => 'events#south_side'
         resources :events

  get 'shadyside/:shady_tag', to: 'events#shadyside', as: :shady_tag
  get 'shadyside/autocomplete_event_special'
      get 'shadyside' => 'events#shadyside'
         resources :events

  get 'downtown/:down_tag', to: 'events#downtown', as: :down_tag
  get 'downtown/autocomplete_event_special'
      get 'downtown' => 'events#downtown'
         resources :events

  get 'oakland/:oakland_tag', to: 'events#oakland', as: :oakland_tag
  get 'oakland/autocomplete_event_special'
      get 'oakland' => 'events#oakland'
         resources :events

  get 'lawrenceville/:law_tag', to: 'events#lawrenceville', as: :law_tag
  get 'lawrenceville/autocomplete_event_special'
      get 'lawrenceville' => 'events#lawrenceville'
         resources :events

  get 'bloomfield/:bloom_tag', to: 'events#bloomfield', as: :bloom_tag
  get 'bloomfield/autocomplete_event_special'
      get 'bloomfield' => 'events#bloomfield'
         resources :events

  get 'urbanist/:urb_tag', to: 'events#urbanist', as: :urb_tag
  get 'urbanist/autocomplete_event_special'
      get 'urbanist' => 'events#urbanist'
         resources :events

  get 'squirrel_hill/:sq_tag', to: 'events#squirrel_hill', as: :sq_tag
  get 'squirrel_hill/autocomplete_event_special'
     get 'squirrel_hill' => 'events#squirrel_hill'
        resources :events

  get 'strip_district/:strip_tag', to: 'events#strip_district', as: :strip_tag
  get 'strip_district/autocomplete_event_special'
     get 'strip_district' => 'events#strip_district'
        resources :events

  get 'mt_washington/:mt_tag', to: 'events#mt_washington', as: :mt_tag
  get 'mt_washiington/autocomplete_event_special'
     get 'mt_washington' => 'events#mt_washington'
        resources :events

  get 'north_side/:north_tag', to: 'events#north_side', as: :north_tag
  get 'north_side/autocomplete_event_special'
     get 'north_side' => 'events#north_side'
        resources :events


  resources :venues do
    member do
      get :venue_verified
    end
  end

  resources :neighborhoods
   get "daily_mailer" => "events#daily_mailer"
   get 'landing' => 'events#landing'
   get 'past_features' => 'daily_specials#past_features'
   get 'underconstruction' => 'daily_specials#underconstruction'

   get 'venue_beer_list' => 'beers#venue_beer_list'
   get 'venue_liqour_list' => 'liqours#venue_liqour_list'
   get 'venue_drink_list' => 'drinks#venue_drink_list'

   get 'users_venues' => 'venues#users_venues'
   get 'about_us' => 'events#about_us'


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
