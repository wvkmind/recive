Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'push'=>'push#create'
  get 'image'=>'push#image'
  get 'last_time' => 'push#last_time'
end
